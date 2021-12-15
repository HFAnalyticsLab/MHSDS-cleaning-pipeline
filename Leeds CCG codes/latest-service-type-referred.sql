--Latest Service Type Referred to data (based on table [MHS102ServiceTypeReferredTo])

CREATE VIEW [dbo].[v_SF_Latest_ServiceTypeReferredTo]
AS

with A as
(
select CAST([SK] as varchar(500)) as [SK]
	,[CareProfTeamLocalId]
	,[ServiceRequestId]
	,[ServTeamTypeRefToMH]
	,[ReferClosureDate]
	,[ReferClosureTime]
	,[ReferRejectionDate]
	,[ReferRejectionTime]
	,[ReferClosReason]
	,[ReferRejectReason]
	,[RecordNumber]
	,[MHS102UniqID]
	,[OrgIDProv]
	,CAST([Person_ID] as varchar(100)) AS [Person_ID]
	,[UniqSubmissionID]
	,[UniqServReqID]
	,[UniqCareProfTeamID]
	,CAST([AgeServReferClosure] as int) as [AgeServReferClosure]
	,CAST([AgeServReferRejection] as int) as [AgeServReferRejection]
	,CAST([UniqMonthID] as int) as [UniqMonthID]
	,[RecordStartDate]
	,[RecordEndDate]
	,[InactTimeST]
	,[EFFECTIVE_FROM]
	,[dmicImportLogId]
	,[dmicIsCYPServiceTypeIndicator]
	,[dmicIsLDAServiceTypeIndicator]
	,[dmicIsAMHServiceTypeIndicator]
	,[dmicUniqCareProfTeamIdPercentUnder18]
	,[dmicSystemId]
	,[dmicCCGCode]
	,CAST([dmicDateAdded] as date) as [dmicDateAdded]
	,[UniqMHSDSPersID]
	,[FileType]
	,[ReportingPeriodStartDate]
	,[ReportingPeriodEndDate]
	,[dmicDataset]
from [mhsds].[MHS102ServiceTypeReferredTo]

UNION

SELECT [SK]
		,CAST([CareProfTeamLocalId] as varchar(20)) as [CareProfTeamLocalId]
		,CAST([ServiceRequestId] as varchar(20)) as [ServiceRequestId]
		,CAST([ServTeamTypeRefToMH] as varchar(3)) as [ServTeamTypeRefToMH]
		,CAST([ReferClosureDate] as date) as [ReferClosureDate]
		,[ReferClosureTime]
		,CAST([ReferRejectionDate] as date)
		,[ReferRejectionTime]
		,[ReferClosReason]
		,[ReferRejectReason]
		,CAST([RecordNumber] as varchar(19)) as [RecordNumber]
		,CAST([MHS102UniqID] as varchar(19)) as [MHS102UniqID]
		,[OrgIDProv]
		,[Person_ID]
		,CAST([UniqSubmissionID] as varchar(6)) as [UniqSubmissionID]
		,[UniqServReqID]
		,[UniqCareProfTeamID]
		,[AgeServReferClosure]
		,[AgeServReferRejection]
		,[month_id]
		,[Record_Start_Date]
		,[Record_End_Date]
		,NULL as [InactTimeST]
		,NULL as [EFFECTIVE_FROM]
		,NULL as [dmicImportLogId]
		,NULL as [dmicIsCYPServiceTypeIndicator]
		,NULL as [dmicIsLDAServiceTypeIndicator]
		,NULL as [dmicIsAMHServiceTypeIndicator]
		,NULL as [dmicUniqCareProfTeamIdPercentUnder18]
		,NULL as [dmicSystemId]
		,[dmicCCG] as dmicCCGCode
		,[DMIC_InsertedDate]
		,[UniqMHSDSPersID]
		,[FILE TYPE]
		,[Reporting Period Start Date]
		,[Reporting Period End Date]
		,[dmicDataset]
FROM [mhsds_v4].[MHS102ServiceTypeReferredTo]
WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY [UniqServReqID], [UniqCareProfTeamID] ORDER BY [ReportingPeriodEndDate] DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
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
 