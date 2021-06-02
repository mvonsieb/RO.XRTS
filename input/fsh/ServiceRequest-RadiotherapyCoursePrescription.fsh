//--------------------------------------------------------------------------------------------------------
// First drafts for XRTS. Not consolidated with IHE-RO XRTS yet.
// Contact: martin.vonsiebenthal@varian.com
//--------------------------------------------------------------------------------------------------------

Profile: RadiotherapyCoursePrescription
Parent: ServiceRequest
Id: RadiotherapyCoursePrescription
Title: "Radiotherapy Course Prescription"
Description: "Radiotherapy Course Prescription is the high-level request for Radiotherapy that may be fulfilled by one or multiple Phases. 
Usually, the Course addresses one disease and anatomical treatment site and covers the whole treatment of that site."
* ^status = #draft
* insert RadiotherapyRequestCommon // See service-Request-RadiotherapyPhasePrescripion.fsh
* extension contains
    http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent named mcode-treatment-intent 0..1 MS and
    http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-sessions named mcode-radiotherapy-sessions 0..1 MS
* extension[radiotherapy-dose-prescribed-to-volume].extension[fractionDosePrescribed] 0..0
* extension[radiotherapy-dose-prescribed-to-volume].extension[fractionDosePrescribed] ^short = "Not used in this profile. See Phase Prescriptions for detailed Fractionation."
* extension[radiotherapy-dose-prescribed-to-volume].extension[fractionDosePrescribed] ^definition = "Fraction dose is only defined in Phases, where all fractions are equivalent. On Course the number of fractions is summarized over all Phase Prescriptions, which may prescribe different dose per Fraction."
* code = RadiotherapyRequest#radiotherapy-course-prescription "Radiotherapy Course Prescription" 	
* occurrencePeriod only Period
* occurrencePeriod MS

// -------- Example Instances ---------------------------------------------------------

Instance: RadiotherapyCoursePrescription-04-XRTS-Prostate
InstanceOf: RadiotherapyCoursePrescription
Description: "Radiotherapy CoursePrescription with elements of IHE-RO XRTS profile for a prostate example."
Usage: #example
* id = "RadiotherapyCoursePrescription-04-XRTS-Prostate" //id of the FHIR Resource
* meta.versionId = "219952" //Version of the resource on the server
* meta.lastUpdated = "2020-07-03T10:07:41.050+02:00" //Update of the resource on the server. Added modification date of clinical contents as extension.
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/RadiotherapyCoursePrescription"
// * extension[concurrentTherapy].valueCodeableConcept = SCT#367336001 "Chemotherapy"
// * extension[concurrentTherapy].valueCodeableConcept.text = "Chemotherapy"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept = SCT#373808002 "Curative - procedure intent"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept.text = "Curative"   
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#1156506007 "External beam radiation therapy using photons (procedure)"
// * extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
// * extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[1] = http://varian.com/fhir/CodeSystem/aria-radiotherapyPrescriptionTechnique#ARC "Arc"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-sessions].valueUnsignedInt = 44

// Prescription Target Site "Prostate"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-03-Prostate" 
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 8300 //unit cGy is automatically added because fixed in the profile 
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionsPrescribed].valuePositiveInt = 44 
// Prescription Target Site "Pelv Ns"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-04-PelvNs"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[totalDosePrescribed].valueQuantity.value = 4500 
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[fractionsPrescribed].valuePositiveInt = 25 
// Prescription Target Site "Sem Vs"
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-05-SemVs"
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[totalDosePrescribed].valueQuantity.value = 7920 
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[fractionsPrescribed].valuePositiveInt = 44 

* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyCourseId"
* identifier[0].value = "Prostate-2Phases"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456.2" 
//* replaces.reference = "ServiceRequest/RadiotherapyTreatmentSummary-0x-XRTS-PredecessorCoursePrescription" //XRTSIntent."Predecessor" In FHIR, this can reference another resource instead of only identifier.
* status = #active
* code = RadiotherapyRequest#radiotherapy-course-prescription	"Radiotherapy Course Prescription" 	
* subject.reference = "Patient/Patient-6"
* subject.display = "Pater Venkman"
* occurrencePeriod.start = "2020-07-03T00:00:00+02:00"
* occurrencePeriod.end = "2020-07-07T00:00:00+02:00" //only expected if completed
* authoredOn =  "2020-07-02T00:00:00+02:00" // "Date and time the IntentPrescription was signed" 
* requester.reference = "Practitioner/Practitioner-1005"
* requester.display = "aria\\user1" 
* reasonCode = ICD10#C61.0 "Malignant neoplasm of prostate" //Try to use Condition resource for diagnosis in XRTS
* reasonCode.text = "Malignant neoplasm of prostate" //Try to use Condition resource for diagnosis in XRTS 
* reasonReference.reference = "Condition/Diagnosis-2-Prostate" //In ARIA, diagnoses related to Course
* bodySite = SCT#181422007 "Entire Prostate" // "Body site that is treated with Radiotherapy"
* bodySite.text = "Prostate"
* note.text = "Free text note in Radiotherapy CoursePrescription"

// ------------------------------------------------------------------------------------

Instance: RadiotherapyCoursePrescription-11-RTTD-BilateralBreast
InstanceOf: RadiotherapyCoursePrescription
Description: "Radiotherapy Course Prescription example from Codex RTTD collection."
Usage: #example
* id = "RadiotherapyCoursePrescription-11-RTTD-BilateralBreast" //id of the FHIR Resource
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/RadiotherapyCoursePrescription"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept = SCT#373808002 "Curative - procedure intent"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept.text = "Curative"   
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#1156506007 "External beam radiation therapy using photons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][1].valueCodeableConcept = SCT#45643008 "Teleradiotherapy using electrons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-sessions].valueUnsignedInt = 30
// Prescription Target Site "Left Breast"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-11-LeftBreast"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 5000 
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionsPrescribed].valuePositiveInt = 25  
// Prescription Target Site "Left Breast Boost"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-12-LeftBreastBoost"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[totalDosePrescribed].valueQuantity.value = 6000 
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[fractionsPrescribed].valuePositiveInt = 30 
// Prescription Target Site "Right Breast"
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-13-RightBreast"
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[totalDosePrescribed].valueQuantity.value = 5000 
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[fractionsPrescribed].valuePositiveInt = 25 
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyCourseId"
* identifier[0].value = "Bilateral Breast"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456.2" 
* status = #active
* subject.reference = "Patient/Patient-5"
* reasonCode = SCT#353431000119107 "Primary malignant neoplasm of female left breast (disorder)"
* reasonReference.reference = "Condition/Diagnosis-1-Breast" 
* bodySite = SCT#76752008 "	Breast structure (body structure)" 
* note.text = "Free text note in Radiotherapy Course Prescription"

Instance: RadiotherapyVolume-11-LeftBreast
InstanceOf: RadiotherapyVolume
Description: "Target Volume."
Usage: #example
* id = "RadiotherapyVolume-11-LeftBreast" //id of the FHIR Resource
* meta.versionId = "123" //Version of the resource on the server
* meta.lastUpdated = "2020-07-03T10:07:41.050+02:00" //Update of the resource on the server. Not necessarily when the clinical contents was modified
* meta.profile[0] = "http://varian.com/fhir/v1/StructureDefinition/RadiotherapyVolume"
* meta.profile[1] = "http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-volume"
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyDoseReferenceId"
* identifier[0].value = "Left Breast" // display id
* identifier[1].use = #official
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "1.2.246.352.71.10.842421386418.21321.20150602151.11" // DICOM UID
* morphology = SCT#228793007 "Planning target volume (observable entity)" // type of volume
* location = SCT#76752008 "Breast structure (body structure)" 
* locationQualifier[0] = SCT#7771000 "Left (qualifier value)" 
* locationQualifier[1] = SCT#255503000 "Entire (qualifier value)" 
* patient.reference = "Patient/Patient-5"

Instance: RadiotherapyVolume-12-LeftBreastBoost
InstanceOf: RadiotherapyVolume
Description: "Target Volume."
Usage: #example
* id = "RadiotherapyVolume-12-LeftBreastBoost" //id of the FHIR Resource
* meta.versionId = "123" //Version of the resource on the server
* meta.lastUpdated = "2020-07-03T10:07:41.050+02:00" //Update of the resource on the server. Not necessarily when the clinical contents was modified
* meta.profile[0] = "http://varian.com/fhir/v1/StructureDefinition/RadiotherapyVolume"
* meta.profile[1] = "http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-volume"
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyDoseReferenceId"
* identifier[0].value = "Left Breast Boost" // display id
* identifier[1].use = #official
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "1.2.246.352.71.10.842421386418.21321.20150602151.12" // DICOM UID
* morphology = SCT#228793007 "Planning target volume (observable entity)" // type of volume
* location = SCT#76752008 "Breast structure (body structure)" 
* locationQualifier[0] = SCT#7771000 "Left (qualifier value)" 
* locationQualifier[1] = SCT#255609007 "Partial (qualifier value)"
* patient.reference = "Patient/Patient-5"

Instance: RadiotherapyVolume-13-RightBreast
InstanceOf: RadiotherapyVolume
Description: "Target Volume."
Usage: #example
* id = "RadiotherapyVolume-13-RightBreast" //id of the FHIR Resource
* meta.versionId = "123" //Version of the resource on the server
* meta.lastUpdated = "2020-07-03T10:07:41.050+02:00" //Update of the resource on the server. Not necessarily when the clinical contents was modified
* meta.profile[0] = "http://varian.com/fhir/v1/StructureDefinition/RadiotherapyVolume"
* meta.profile[1] = "http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-volume"
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyDoseReferenceId"
* identifier[0].value = "Right Breast" // display id
* identifier[1].use = #official
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "1.2.246.352.71.10.842421386418.21321.20150602151.13" // DICOM UID
* morphology = SCT#228793007 "Planning target volume (observable entity)" // type of volume
* location = SCT#76752008 "Breast structure (body structure)" 
* locationQualifier[0] = SCT#24028007 "Right (qualifier value)" 
* locationQualifier[1] = SCT#255503000 "Entire (qualifier value)" 
* patient.reference = "Patient/Patient-5"
