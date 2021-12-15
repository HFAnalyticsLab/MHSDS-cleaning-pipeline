<img src="ndlbanner.png" width="405" height="96">

# Mental Health Services Dataset (MHSDS) cleaning pipeline

#### Project Status: Completed

## Project Description

- The [Networked Data Lab](https://www.health.org.uk/funding-and-partnerships/our-partnerships/the-networked-data-lab)'s second research topic is children and young people's mental health. In order to carry out analyses on this topic, several of our analytical partners requested access to NHS Digital's Mental Health Services Dataset (MHSDS).

- It is a patient level, output based, secondary uses dataset which aims to deliver robust, comprehensive, nationally consistent and comparable person-based information for children, young people and adults who are in contact with services for mental health and wellbeing, Learning Disability, autism or other  neurodevelopmental conditions. It covers services located in England (or located outside England but treating patients commissioned by an English CCG) and any services which are at least partly funded by the NHS are within the remit of this dataset. Contacts with IAPT (the psychological therapies service) are not included.

- This dataset relies on a complex [data model](https://files.digital.nhs.uk/8B/1307C5/MHSDS%20_Analysis_Webinar_20190925.pdf). It included over 50 tables, and getting started with MHSDS can be daunting. To make things easier for other teams trying to use this data, we have shared the SQL codes used by two of our Networked Data Lab partners to process this data (Leeds and Liverpool/Wirral).

## Data source

MHSDS contains over 50 tables, but the code only processes and cleans those highlighted in bold below. However, a similar approach to what we have published could be used on those tables.

- MHS000 Header
- **MHS001 MPI**
- **MHS002 GP**
- MHS003 AccommStatus
- MHS004 EmpStatus
- **MHS005 PatInd**
- MHS006 MHCareCoord
- MHS007 DisabilityType
- MHS008 CarePlanType
- MHS009 CarePlanAgreement
- MHS010 AssTechToSupportDisTyp
- MHS011 SocPerCircumstances
- MHS012 OverseasVisitorChargCat
- MHS013 MHCurrencyModel
- **MHS101 Referral**
- **MHS102 ServiceTypeReferredTo**
- MHS103 OtherReasonReferral
- MHS104 RTT
- MHS105 OnwardReferral
- MHS106 DischargePlanAgreement
- MHS107 MedicationPrescription
- **MHS201 CareContact**
- MHS202 CareActivity
- MHS203 OtherAttend
- MHS204 IndirectActivity
- MHS301 GroupSession
- MHS302 MHDropInContact
- MHS401 MHActPeriod
- MHS402 RespClinicianAssignPeriod
- MHS403 ConditionalDischarge
- MHS404 CommTreatOrder
- MHS405 CommTreatOrderRecall
- **MHS501 HospProvSpell**
- MHS502 WardStay
- MHS503 AssignedCareProf
- MHS504 DelayedDischarge
- MHS505 RestrictiveInterventInc
- MHS515 RestrictiveInterventType
- MHS516 PoliceAssistanceRequest
- MHS506 Assault
- MHS507 SelfHarm
- MHS509 HomeLeave
- MHS510 LeaveOfAbsence
- MHS511 AbsenceWithoutLeave
- MHS512 HospSpellCommAssPer
- MHS513 SubstanceMisuse
- MHS514 TrialLeave
- MHS517 SMHExceptionalPackOfCare
- MHS601 MedHistPrevDiag
- MHS603 ProvDiag
- MHS604 PrimDiag
- MHS605 SecDiag
- MHS606 CodedScoreAssessmentRefer
- MHS607 CodedScoreAssessmentAct
- MHS608 AnonSelfAssess
- MHS701 CPACareEpisode
- MHS702 CPAReview
- MHS801 ClusterTool
- MHS802 ClusterAssess
- MHS803 CareCluster
- MHS804 FiveForensicPathways
- MHS901 StaffDetails

## How does it work?

There are multiple versions of MHSDS, with version 5 being the most recent one at the time of this work. New versions are released when the collection methodology changes, mistakes need to be corrected or variables are added. It’s not unusual, especially if you are working with patient-level data going back years, to have to work simultaneously with multiple versions of MHSDS. This can cause some issues that we list below. 

- Each version of MHSDS comes with its own bridging file. These are the files that allow you to join-up MHSDS with other datasets using unique patient identifiers. If a patient has different identifiers (one per version) then they may end up looking like different people in the appended version.

- Patient identifiers changed from fiscal year 2021/21 onwards, causing similar double-counting issues. 

- Some older data points are now marked as ‘non-valid'. Up until the end fiscal year 2019/20, some rows from older versions of MHSDS are marked as ‘non-valid’ using a specific submission flag in the data. It could be named *‘IC_USE_Submission_Flag’*, *‘z_SubmissionFlag’* or other depending on how you received this data and how it’s been pre-processed (for example by the DSCRO or a Commissioning Support Unit). 

- Referrals get re-submitted each month as long as they are open, causing more duplicates. This needs to be accounted for in the code, otherwise it may appear like a single patient has dozens or more active referrals. 

- Other referrals are duplicated, on the basis that they are relevant to more than one CCG. Again, there should be a specific flag in your data showing which duplicate referrals need to be removed.

The codes we have published here address those issues by:

- Merging all versions into a single view.
- Picking the latest record (e.g. of referrals) where there is a duplicate.
- Including the pseudo-NHS-number where there is one.

There is one SQL code to process each table. For example, *latest-care-contact.SQL* creates a clean view for table *MHS201 CareContact*.

### Requirements

These codes require that you have an SQL-supported database management software, such as SQL Server Management Studio.

## Useful references

- [MHSDS metadata](https://nhs-prod.global.ssl.fastly.net/binaries/content/assets/website-assets/isce/dcb0011/0011292020datasetspec-v1.1.xlsm)
- [MHSDS change specification between v5 and v4](https://nhs-prod.global.ssl.fastly.net/binaries/content/assets/website-assets/isce/dcb0011/0011292020changespec-v1.1.pdf)
- [MHSDS monthly data (open version)](https://digital.nhs.uk/data-and-information/publications/statistical/mental-health-services-monthly-statistics)

## Authors

- Souheila Fox, Leeds CCG ([e-mail](souheila.fox@nhs.net))
- Roberta Piroddi, Liverpool CCG ([e-mail](roberta.piroddi@liverpoolccg.nhs.uk))
- Karen Jones, Liverpool CCG

## License

This project is licensed under the MIT License.

## Acknowledgments

We would like to aknowledge our colleagues in the Leeds and Liverpool CCGs who helped produce this cleaning and processing pipeline.
