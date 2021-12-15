--Latest Social/Personal Circumstances data (based on table [MHS011SocPerCircumstances])

CREATE VIEW [dbo].[v_SF_Latest_SocPerCircumstance]

AS

WITH A as
(
SELECT CAST([SK] as varchar(500)) as [SK]
		,[LocalPatientId]
		,SocPerCircumstanceType = CASE
									WHEN SocPerCircumstance in ('1400009','160540005','160542002','160543007','160545000','160549006','160552003','160567004','205061000000101'
																,'205081000000105','205141000000101','271390004','271448006','276113008','276114002','276116000','276120001'
																,'309687009','309884000','309887007','312864006','344151000000101','366740002','368071000000109','368171000000108'
																,'429732005','62458008','763896000') THEN 'Religion'
									WHEN SocPerCircumstance in ('1064711000000108','20430005','38628009','42035005','440583007','699042003','76102007','89217008') THEN 'Sexual orientation'
									ELSE 'Unknown'
								END
		,[SocPerCircumstance]
		,[SocPerCircumstanceRecDate]
		,[RecordNumber]
		,[MHS011UniqID]
		,[OrgIDProv]
		,[Person_ID]
		,[UniqSubmissionID]
		,CAST([UniqMonthID] as INT) as [UniqMonthID]
		,[RecordStartDate]
		,[RecordEndDate]
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
FROM [mhsds].[MHS011SocPerCircumstances]

UNION

SELECT [SK]
		,NULL as [LocalPatientId]
		,SocPerCircumstanceType = CASE
									WHEN CAST([SocPerCircumstance] as varchar(18)) in ('1400009','160540005','160542002','160543007','160545000','160549006','160552003','160567004'
																,'205061000000101','205081000000105','205141000000101','271390004','271448006','276113008','276114002','276116000','276120001'
																,'309687009','309884000','309887007','312864006','344151000000101','366740002','368071000000109','368171000000108'
																,'429732005','62458008','763896000') THEN 'Religion'
									WHEN CAST([SocPerCircumstance] as varchar(18)) in ('1064711000000108','20430005','38628009','42035005','440583007','699042003','76102007','89217008') THEN 'Sexual orientation'
									ELSE 'Unknown'
								END
		,CAST([SocPerCircumstance] as varchar(18)) as [SocPerCircumstance]
		,CAST([SocPerCircumstanceRecDate] as DATE) as [SocPerCircumstanceRecDate]
		,CAST([RecordNumber] as varchar(19)) as [RecordNumber]
		,CAST([MHS011UniqID] as varchar(19)) as [MHS011UniqID]
		,[OrgIDProv]
		,[Person_ID]
		,CAST([UniqSubmissionID] as varchar(6)) as [UniqSubmissionID]
		,[UniqMonthID]
		,NULL as [RecordStartDate]
		,NULL as [RecordEndDate]
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
FROM [mhsds_v4].[MHS011SocPerCircumstances]
WHERE IC_USE_Submission_Flag is null or IC_USE_Submission_Flag = 'Y'
),
B as
(
Select ROW_NUMBER() OVER (PARTITION BY coalesce([Person_ID],[UniqMHSDSPersID]),SocPerCircumstanceType  ORDER BY ReportingPeriodEndDate DESC, [FileType] DESC, dmicCCGCode desc) AS [RecPriority]
	,*
FROM A
)
SELECT [SK]
		,[LocalPatientId]
		,SocPerCircumstanceType
		,[SocPerCircumstance]
		,d.Term as [SocPerCircumstanceDesc]
		,[SocPerCircumstanceRecDate]
		,[RecordNumber]
		,[MHS011UniqID]
		,[OrgIDProv]
		,B.[Person_ID]
		,[UniqSubmissionID]
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
FROM B
	left outer join [mhsds].[Bridging] n1
		on n1.Person_Id = B.Person_ID
	left outer join [mhsds_v4].[Bridging] n2
		on n2.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID)
	left outer join [mhsds_v3].[Bridging] n3
		on n3.Person_Id = coalesce(B.Person_ID,B.UniqMHSDSPersID)
	left outer join [UK_Health_Dimensions].[SNOMED_Simplified_Model].[SCT_Concept_Descriptions] d
		on d.Concept_ID = B.[SocPerCircumstance] and d.Active_Concept = 1 and d.description_Type = 'Preferred Term'
WHERE [RecPriority] = 1
