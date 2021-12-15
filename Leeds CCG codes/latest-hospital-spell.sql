--Latest Hospital Spell data (based on table [MHS501HospProvSpell])

CREATE VIEW [dbo].[v_SF_Latest_HospProvSpell]
AS

with A as
(
SELECT CAST([SK] as varchar(500)) as [SK]
		,[HospProvSpellNum]
		,[ServiceRequestId]
		,[StartDateHospProvSpell]
		,[StartTimeHospProvSpell]
		,[SourceAdmCodeHospProvSpell]
		,[AdmMethCodeHospProvSpell]
		,[PostcodeMainVisitor Pseudo]
		,[EstimatedDischDateHospProvSpell]
		,[PlannedDischDateHospProvSpell]
		,[PlannedDischDestCode]
		,[DischDateHospProvSpell]
		,[DischTimeHospProvSpell]
		,[DischMethCodeHospProvSpell]
		,[DischDestCodeHospProvSpell]
		,[PostcodeDischDestHospProvSpell Pseudo]
		,[RecordNumber]
		,[MHS501UniqID]
		,[OrgIDProv]
		,[Person_ID]
		,[UniqSubmissionID]
		,[UniqServReqID]
		,[UniqHospProvSpellNum]
		,[PostcodeDistrictMainVisitor]
		,[PostcodeDistrictDischDest]
		,CAST([UniqMonthID] as INT) as [UniqMonthID]
		,[RecordStartDate]
		,[RecordEndDate]
		,[InactTimeHPS]
		,DATEDIFF(dd,[StartDateHospProvSpell],[DischDateHospProvSpell]) as [LOSDischHosSpell]
		,DATEDIFF(dd,[StartDateHospProvSpell],[ReportingPeriodEndDate]) as [LOSHosSpellEoRP]
		,[TimeEstDischDate]
		,[TimePlanDischDate]
		,[EFFECTIVE_FROM]
		,[dmicImportLogId]
		,[dmicSystemId]
		,[dmicCCGCode]
		,[dmicDateAdded]
		,[UniqMHSDSPersID]
		,[FileType]
		,[ReportingPeriodStartDate]
		,[ReportingPeriodEndDate]
		,[dmicDataset]
FROM [mhsds].[MHS501HospProvSpell]

UNION

SELECT [SK]
		,[HospProvSpellNum]
		,[ServiceRequestId]
		,[StartDateHospProvSpell]
		,[StartTimeHospProvSpell]
		,[SourceAdmCodeHospProvSpell]
		,[AdmMethCodeHospProvSpell]
		,[PostcodeMainVisitor] as [PostcodeMainVisitor Pseudo]
		,[EstimatedDischDateHospProvSpell]
		,[PlannedDischDateHospProvSpell]
		,[PlannedDischDestCode]
		,[DischDateHospProvSpell]
		,[DischTimeHospProvSpell]
		,CAST([DischMethCodeHospProvSpell] as varchar(1)) as [DischMethCodeHospProvSpell]
		,[DischDestCodeHospProvSpell]
		,[PostcodeDischDestHospProvSpell] as [PostcodeDischDestHospProvSpell Pseudo]
		,CAST([RecordNumber] as varchar(19)) as [RecordNumber]
		,CAST([MHS501UniqID] as varchar(19)) as [MHS501UniqID]
		,[OrgIDProv]
		,[Person_ID]
		,CAST([UniqSubmissionID] as varchar(6)) as [UniqSubmissionID]
		,[UniqServReqID]
		,[UniqHospProvSpellNum]
		,[PostcodeDistrictMainVisitor]
		,[PostcodeDistrictDischDest]
		,[month_id] as [UniqMonthID]
		,[Record_Start_Date] as [RecordStartDate]
		,[Record_End_Date] as [RecordEndDate]
		,NULL as [InactTimeHPS]
		,DATEDIFF(dd,[StartDateHospProvSpell],[DischDateHospProvSpell]) as [LOSDischHosSpell]
		,DATEDIFF(dd,[StartDateHospProvSpell],[Reporting Period End Date]) as [LOSHosSpellEoRP]
		,NULL as [TimeEstDischDate]
		,NULL as [TimePlanDischDate]
		,NULL as [EFFECTIVE_FROM]
		,NULL as [dmicImportLogId]
		,NULL as [dmicSystemId]
		,[dmicCCG] as [dmicCCGCode]
		,[DMIC_InsertedDate] as [dmicDateAdded]
		,[UniqMHSDSPersID] as [UniqMHSDSPersID]
		,[FILE TYPE] as [FileType]
		,[Reporting Period Start Date] as [ReportingPeriodStartDate]
		,[Reporting Period End Date] as [ReportingPeriodEndDate]
		,[dmicDataset] as [dmicDataset]
FROM [mhsds_v4].[MHS501HospProvSpell]
WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY [UniqHospProvSpellNum] ORDER BY [ReportingPeriodEndDate] DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
	,*
FROM A
)
SELECT [SK]
		,[HospProvSpellNum]
		,[ServiceRequestId]
		,[StartDateHospProvSpell]
		,[StartTimeHospProvSpell]
		,[SourceAdmCodeHospProvSpell]
		,[AdmMethCodeHospProvSpell]
		,[PostcodeMainVisitor Pseudo]
		,[EstimatedDischDateHospProvSpell]
		,[PlannedDischDateHospProvSpell]
		,[PlannedDischDestCode]
		,[DischDateHospProvSpell]
		,[DischTimeHospProvSpell]
		,[DischMethCodeHospProvSpell]
		,[DischDestCodeHospProvSpell]
		,[PostcodeDischDestHospProvSpell Pseudo]
		,[RecordNumber]
		,[MHS501UniqID]
		,[OrgIDProv]
		,B.[Person_ID]
		,[UniqSubmissionID]
		,[UniqServReqID]
		,[UniqHospProvSpellNum]
		,[PostcodeDistrictMainVisitor]
		,[PostcodeDistrictDischDest]
		,[UniqMonthID]
		,[RecordStartDate]
		,[RecordEndDate]
		,[InactTimeHPS]
		,[LOSDischHosSpell]
		,[LOSHosSpellEoRP]
		,[TimeEstDischDate]
		,[TimePlanDischDate]
		,[EFFECTIVE_FROM]
		,B.[dmicImportLogId]
		,[dmicSystemId]
		,[dmicCCGCode]
		,[dmicDateAdded]
		,[UniqMHSDSPersID]
		,[FileType]
		,[ReportingPeriodStartDate]
		,[ReportingPeriodEndDate]
		,[dmicDataset]
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
