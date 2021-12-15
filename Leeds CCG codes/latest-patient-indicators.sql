--Latest Patient Indicators data (based on table [MHS005PatInd])

CREATE VIEW [dbo].[v_SF_Latest_PatInd]

AS

WITH A as
(
SELECT CAST([SK]as [varchar](500)) as SK
	,[LocalPatientId]
	,[ConstSuperReqDueToDis]
	,[ParentalResp]
	,[YoungCarer]
	,[LACStatus]
	,[CPP]
	,[ExBAFIndicator]
	,[OffenceHistory]
	,[ProPsychDate]
	,[EmerPsychDate]
	,[ManPsychDate]
	,[PsychPrescDate]
	,[PsychTreatDate]
	,[RecordNumber]
	,[MHS005UniqID]
	,[OrgIDProv]
	,[Person_ID]
	,[UniqSubmissionID]
	,[UniqMonthID]
	,[EFFECTIVE_FROM]
	,[dmicImportLogId]
	,[dmicSystemId]
	,[dmicCCGCode]
	,CAST([dmicDateAdded] as DATE) as [dmicDateAdded]
	,[UniqMHSDSPersID]
	,[Unique_LocalPatientId]
	,[FileType]
	,[ReportingPeriodStartDate]
	,[ReportingPeriodEndDate]
	,[dmicDataset]
FROM [mhsds].[MHS005PatInd]

UNION

SELECT [SK]
	,NULL as [LocalPatientId]
	,[ConstSuperReqDueToDis]
	,[ParentalResp]
	,[YoungCarer]
	,[LACStatus]
	,[CPP]
	,[ExBAFIndicator]
	,[OffenceHistory]
	,CAST ([ProPsychDate] as DATE) as [ProPsychDate]
	,CAST ([EmerPsychDate] as DATE) as [EmerPsychDate]
	,CAST ([ManPsychDate] as DATE) as [ManPsychDate]
	,CAST ([PsychPrescDate] as DATE) as [PsychPrescDate]
	,CAST ([PsychTreatDate] as DATE) as [PsychTreatDate]
	,CAST ([RecordNumber] as varchar(19)) as [RecordNumber]
	,CAST ([MHS005UniqID] as varchar(19)) as [MHS005UniqID]
	,[OrgIDProv]
	,[Person_ID]
	,CAST ([UniqSubmissionID] as varchar(6)) as [UniqSubmissionID]
	,[Month_Id] as [UniqMonthID]
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
FROM [mhsds_v4].[MHS005PatInd]
WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY coalesce([Person_ID],[UniqMHSDSPersID]) ORDER BY ReportingPeriodEndDate DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
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
		on n3.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID)
WHERE [RecPriority] = 1