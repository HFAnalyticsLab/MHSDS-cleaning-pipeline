--Latest MPI data (based on table [MHS001MPI])

CREATE VIEW [dbo].[v_SF_Latest_MPI]
AS

with A as
(
SELECT CAST([SK] as varchar(500)) as [SK]
		,[LocalPatientId]
		,[OrgIDLocalPatientId]
		,[OrgIDResidenceResp]
		,[OrgIDEduEstab]
		,[NHSNumber Pseudo]
		,[NHSNumberStatus]
		,[PersonBirthDate Pseudo]
		,[Postcode Pseudo]
		,[Gender]
		,[MaritalStatus]
		,[EthnicCategory]
		,[LanguageCodePreferred]
		,[PersDeathDate]
		,[RecordNumber]
		,[MHS001UniqID]
		,[OrgIDProv]
		,[OrgIDCCGRes]
		,[Person_ID]
		,[UniqSubmissionID]
		,CAST([AgeRepPeriodStart] as INT) as [AgeRepPeriodStart]
		,CAST([AgeRepPeriodEnd] as INT) as [AgeRepPeriodEnd]
		,CAST([AgeDeath] as INT) as [AgeDeath]
		,[PostcodeDistrict]
		,[DefaultPostcode Pseudo]
		,[LSOA2011]
		,[LADistrictAuth]
		,[County]
		,[ElectoralWard]
		,CAST([UniqMonthID] as INT) as [UniqMonthID]
		,[NHSDEthnicity]
		,[PatMRecInRP]
		,[RecordStartDate]
		,[RecordEndDate]
		,[CCGGPRes]
		,[IMDQuart]
		,[EFFECTIVE_FROM]
		,[dmicImportLogId]
		,[dmicOrgIDCCGGPPractice]
		,[dmicEthnicCategoryGroup]
		,[dmicAgeGroupRPEndDate]
		,[dmicSystemId]
		,[dmicCCGCode]
		,CAST([dmicDateAdded] as DATE) as [dmicDateAdded]
		,[UniqMHSDSPersID]
		,[Unique_LocalPatientId]
		,[FileType]
		,[ReportingPeriodStartDate]
		,[ReportingPeriodEndDate]
		,NULL as [ValidNHSNumFlag]
		,[dmicDataset]
FROM [mhsds].[MHS001MPI]

UNION

SELECT [SK]
		,NULL as [LocalPatientId]
		,[OrgIDLocalPatientId]
		,[OrgIDResidenceResp]
		,[OrgIDEduEstab]
		,NULL as [NHSNumber Pseudo]
		,[NHSNumberStatus]
		,NULL as [PersonBirthDate Pseudo]
		,NULL as [Postcode Pseudo]
		,[Gender]
		,[MaritalStatus]
		,[EthnicCategory]
		,[LanguageCodePreferred]
		,NULL as [PersDeathDate]
		,CAST([RecordNumber] as varchar(19)) as [RecordNumber]
		,CAST([MHS001UniqID] as varchar(19)) as [MHS001UniqID]
		,[OrgIDProv]
		,[OrgIDCCGRes]
		,[Person_ID]
		,CAST([UniqSubmissionID] as varchar(6)) as [UniqSubmissionID]
		,[AgeRepPeriodStart]
		,[AgeRepPeriodEnd]
		,[AgeDeath]
		,[PostcodeDistrict]
		,[DefaultPostcode] as [DefaultPostcode Pseudo]
		,[LSOA2011]
		,[LADistrictAuth]
		,[County]
		,[ElectoralWard]
		,[Month_Id] as [UniqMonthID]
		,NULL as [NHSDEthnicity]
		,NULL as [PatMRecInRP]
		,[Record_End_Date] as [RecordStartDate]
		,[Record_Start_Date] as [RecordEndDate]
		,NULL as [CCGGPRes]
		,NULL as [IMDQuart]
		,NULL as [EFFECTIVE_FROM]
		,NULL as [dmicImportLogId]
		,NULL as [dmicOrgIDCCGGPPractice]
		,[IC_Ethnic_Category_Aggregate] as [dmicEthnicCategoryGroup]
		,NULL as [dmicAgeGroupRPEndDate]
		,NULL as [dmicSystemId]
		,[dmicCCG] as [dmicCCGCode]
		,[DMIC_InsertedDate] as [dmicDateAdded]
		,[UniqMHSDSPersID]
		,NULL as [Unique_LocalPatientId]
		,[FILE TYPE] as [FileType]
		,[Reporting Period Start Date] as [ReportingPeriodStartDate]
		,[Reporting Period End Date] as [ReportingPeriodEndDate]
		,[ValidNHSNumFlag]
		,[dmicDataset]
FROM [mhsds_v4].[MHS001MPI]
WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY coalesce(Person_ID,[UniqMHSDSPersID]) ORDER BY ReportingPeriodEndDate DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
	,*
FROM A
)
SELECT B.*
		,[Pseudo_NHS_Number] =  case
								WHEN coalesce(n1.[Pseudo_NHSNumber],n2.[Pseudo_NHS_Number],n3.[Pseudo_NHS_Number]) = '' THEN NULL
								ELSE coalesce(n1.[Pseudo_NHSNumber],n2.[Pseudo_NHS_Number],n3.[Pseudo_NHS_Number])
							END 
FROM B
	left outer join [mhsds].[Bridging] n1
		on n1.Person_Id = B.Person_ID
	left outer join [mhsds_v4].[Bridging] n2
		on n2.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID)
	left outer join [mhsds_v3].[Bridging] n3
		on n3.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID) and B.ValidNHSNumFlag = 'Y'
WHERE [RecPriority] = 1
 