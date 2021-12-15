--Latest Referrals data (based on table [MHS101Referral])

CREATE VIEW [dbo].[v_SF_Latest_Referrals]

AS

WITH A AS 
(
SELECT CAST([SK] as varchar(100)) as [SK]
	,[ServiceRequestId]
	,[LocalPatientId]
	,[OrgIDComm]
	,[ReferralRequestReceivedDate]
	,[ReferralRequestReceivedTime]
	,[NHSServAgreeLineNum]
	,[SpecialisedMHServiceCode]
	,[SourceOfReferralMH]
	,[OrgIDReferring]
	,[ReferringCareProfessionalStaffGroup]
	,[ClinRespPriorityType]
	,[PrimReasonReferralMH]
	,[ReasonOAT]
	,[DischPlanCreationDate]
	,[DischPlanCreationTime]
	,[DischPlanLastUpdatedDate]
	,[DischPlanLastUpdatedTime]
	,[ServDischDate]
	,[ServDischTime]
	,[DischLetterIssDate]
	,[RecordNumber]
	,[MHS101UniqID]
	,[OrgIDProv]
	,[Person_ID]
	,[UniqMHSDSPersID]
	,[UniqSubmissionID]
	,[UniqServReqID]
	,CAST([AgeServReferRecDate] as INT) as [AgeServReferRecDate]
	,CAST([AgeServReferDischDate] as INT) [AgeServReferDischDate]
	,CAST([UniqMonthID] as int) as [UniqMonthID]
	,[RecordStartDate]
	,[RecordEndDate]
	,[InactTimeRef]
	,[EFFECTIVE_FROM]
	,[dmicImportLogId]
	,[dmicServiceAreaCYPRefStartIndicator]
	,[dmicAreaEndRP]
	,[dmicSystemId]
	,[dmicCCGCode]
	,[Unique_LocalPatientId]
	,[FileType]
	,[ReportingPeriodStartDate]
	,[ReportingPeriodEndDate]
	,[dmicDataset]
	,CAST([dmicDateAdded] as DATE) as [dmicDateAdded]

FROM [mhsds].[MHS101Referral]

UNION

SELECT CAST([SK] as varchar(100)) as [SK]
	,[ServiceRequestId]
	,NULL as [LocalPatientId]
	,[OrgIDComm]
	,CAST([ReferralRequestReceivedDate] as DATE) as [ReferralRequestReceivedDate]
	,[ReferralRequestReceivedTime]
	,[NHSServAgreeLineNum]
	,[SpecialisedMHServiceCode]
	,[SourceOfReferralMH]
	,[OrgIDReferring]
	,[ReferringCareProfessionalStaffGroup]
	,[ClinRespPriorityType]
	,[PrimReasonReferralMH]
	,[ReasonOAT]
	,CAST([DischPlanCreationDate] as DATE) [DischPlanCreationDate]
	,[DischPlanCreationTime]
	,CAST([DischPlanLastUpdatedDate] as DATE) as [DischPlanLastUpdatedDate]
	,[DischPlanLastUpdatedTime]
	,CAST([ServDischDate] as DATE) as [ServDischDate]
	,[ServDischTime]
	,CAST([DischLetterIssDate] as DATE) as [DischLetterIssDate]
	,CAST([RecordNumber] as varchar(19)) as [RecordNumber]
	,CAST([MHS101UniqID] as varchar(19)) as [MHS101UniqID]
	,[OrgIDProv]
	,[Person_ID]
	,[UniqMHSDSPersID]
	,CAST([UniqSubmissionID] as varchar(6)) as [UniqSubmissionID]
	,[UniqServReqID]
	,[AgeServReferRecDate]
	,[AgeServReferDischDate]
	,[month_id] as [UniqMonthID]
	,[Record_Start_Date] as [RecordStartDate]
	,[Record_End_Date] as [RecordEndDate]
	,NULL as [InactTimeRef]
	,NULL as [EFFECTIVE_FROM]
	,NULL as [dmicImportLogId]
	,convert( bit,
			CASE [IC_Service_Area_CYP_Ref_Start] 
				WHEN 'N' THEN 0 
				WHEN 'Y' THEN 1
				else null 
			END)
	,[IC_Service_Area_end_RP]
	,NULL as [dmicSystemId]
	,[dmicCCG] as [dmicCCGCode]
	,NULL as [Unique_LocalPatientId]
	,[FILE TYPE] as [FileType]
	,[Reporting Period Start Date] as [ReportingPeriodStartDate]
	,[Reporting Period End Date] as [ReportingPeriodEndDate]
	,[dmicDataset]
	,[DMIC_InsertedDate] as [dmicDateAdded]
FROM [mhsds_v4].[MHS101Referral]
  WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY [UniqServReqID] ORDER BY ReportingPeriodEndDate DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
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
 