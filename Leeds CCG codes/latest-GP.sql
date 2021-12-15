--Latest GP data (based on table MHS002GP)

CREATE VIEW [dbo].[v_SF_Latest_GP]
AS

WITH A as
(
SELECT CAST([SK] as varchar(500)) as [SK]
	,[LocalPatientId]
	,[GMPCodeReg]
	,[StartDateGMPRegistration]
	,[EndDateGMPRegistration]
	,[OrgIDGPPrac]
	,[RecordNumber]
	,[MHS002UniqID]
	,[OrgIDProv]
	,[Person_ID]
	,[UniqSubmissionID]
	,[OrgIDCCGGPPractice]
	,CAST([GPDistanceHome] as int) as [GPDistanceHome]
	,CAST([UniqMonthID] as int) as [UniqMonthID]
	,[RecordStartDate]
	,[RecordEndDate]
	,[EFFECTIVE_FROM]
	,[dmicImportLogId]
	,[dmicSystemId]
	,[dmicCCGCode]
	,[dmicDateAdded]
	,[UniqMHSDSPersID]
	,[Unique_LocalPatientId]
	,[FileType]
	,[ReportingPeriodStartDate]
	,[ReportingPeriodEndDate]
	,[dmicDataset]
FROM [mhsds].[MHS002GP]

UNION

SELECT [SK]
	,NULL as [LocalPatientId]
	,[GMPCodeReg]
	,CAST([StartDateGMPRegistration] as [date]) as [StartDateGMPRegistration]
	,CAST([EndDateGMPRegistration] as [date]) as [EndDateGMPRegistration]
	,[OrgIDGPPrac]
	,CAST([RecordNumber] as [varchar]) as [RecordNumber]
	,CAST([MHS002UniqID] as [varchar]) as [MHS002UniqID]
	,[OrgIDProv]
	,[Person_ID]
	,CAST([UniqSubmissionID] as [varchar]) as [UniqSubmissionID]
	,[OrgIDCCGGPPractice]
	,[GPDistanceHome]
	,[Month_Id] as [UniqMonthID]
	,[Record_Start_Date] as [RecordStartDate]
	,[Record_End_Date] as [RecordEndDate]
	,NULL as [EFFECTIVE_FROM]
	,NULL as [dmicImportLogId]
	,NULL as [dmicSystemId]
	,[dmicCCG] as [dmicCCGCode]
	,[DMIC_InsertedDate] as [dmicDateAdded]
	,[UniqMHSDSPersID]
	,NULL as [Unique_LocalPatientId]
	,[FILE TYPE] as [FileType]
	,[Reporting Period Start Date] as [ReportingPeriodStartDate]
	,[Reporting Period End Date] as [ReportingPeriodEndDate]
	,[dmicDataset]
FROM [mhsds_V4].[MHS002GP]
WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY COALESCE(Person_ID, UniqMHSDSPersID), GMPCodeReg ORDER BY [ReportingPeriodEndDate] DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
	,*
FROM A
)
SELECT [SK]
	,[LocalPatientId]
	,[GMPCodeReg]
	,[StartDateGMPRegistration]
	,[EndDateGMPRegistration]
	,[OrgIDGPPrac]
	,[RecordNumber]
	,[MHS002UniqID]
	,[OrgIDProv]
	,B.[Person_ID]
	,[UniqSubmissionID]
	,[OrgIDCCGGPPractice]
	,[GPDistanceHome]
	,[UniqMonthID]
	,[RecordStartDate]
	,[RecordEndDate]
	,[EFFECTIVE_FROM]
	,B.[dmicImportLogId]
	,[dmicSystemId]
	,[dmicCCGCode]
	,[dmicDateAdded]
	,[UniqMHSDSPersID]
	,[Unique_LocalPatientId]
	,[FileType]
	,[ReportingPeriodStartDate]
	,[ReportingPeriodEndDate]
	,[dmicDataset]
	,[Pseudo_NHS_Number] =  case
								WHEN coalesce(n1.[Pseudo_NHSNumber],n2.[Pseudo_NHS_Number],n3.[Pseudo_NHS_Number]) = '' THEN NULL
								ELSE coalesce(n1.[Pseudo_NHSNumber],n2.[Pseudo_NHS_Number],n3.[Pseudo_NHS_Number])
							END 
from B
	left outer join [mhsds].[Bridging] n1
		on n1.Person_Id = B.Person_ID
	left outer join [mhsds_v4].[Bridging] n2
		on n2.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID)
	left outer join [mhsds_v3].[Bridging] n3
		on n3.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID)
WHERE [RecPriority] = 1
 