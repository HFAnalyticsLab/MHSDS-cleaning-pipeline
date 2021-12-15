# Mental Health Services Dataset (MHSDS) cleaning pipeline

#### Project Status: Completed

## Project Description

- background
- aim of the project
- what does the code in this repo do?
- main methods
- links to any outputs, blogs. 

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

Describe data sources, inlcluding links to public data or references to data sharing agreements. 

## How does it work?

What you need to do to reproduce the analysis or re-use the code on your local machine.  

### Requirements

Software or packages that needs to be installed and and how to install them.

For example:
These scripts were written in R version (to be added) and RStudio Version 1.1.383. 
The following R packages (available on CRAN) are needed: 
* [**tidyverse**](https://www.tidyverse.org/)

### Getting started

Describe the way in which the code can be used. 

## Useful references

- [MHSDS metadata](https://nhs-prod.global.ssl.fastly.net/binaries/content/assets/website-assets/isce/dcb0011/0011292020datasetspec-v1.1.xlsm)
- [MHSDS change specification between v5 and v4](https://nhs-prod.global.ssl.fastly.net/binaries/content/assets/website-assets/isce/dcb0011/0011292020changespec-v1.1.pdf)
- [MHSDS monthly data (open version)](https://digital.nhs.uk/data-and-information/publications/statistical/mental-health-services-monthly-statistics)

## Authors

- Souheila Fox, Leeds CCG ([e-mail](souheila.fox@nhs.net))
- Roberta Piroddi, Liverpool CCG ([e-mail](roberta.piroddi@liverpoolccg.nhs.uk))

## License

This project is licensed under the [MIT License](link to license file).

## Acknowledgments

* Credit anyone whose code was used
* Inspiration
* etc
