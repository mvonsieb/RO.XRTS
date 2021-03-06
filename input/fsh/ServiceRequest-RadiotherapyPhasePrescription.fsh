//--------------------------------------------------------------------------------------------------------
// First drafts for XRTS/RTTD discussions. Not reviewed with IHE-RO XRTS yet.
// Contact: martin.vonsiebenthal@varian.com
//--------------------------------------------------------------------------------------------------------

// Common for all RT Requests including Course Summary
RuleSet: RadiotherapyRequestCommon
// * meta MS
// * meta.versionId MS
// * meta.lastUpdated MS
* extension MS 
* extension contains
    http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality named mcode-radiotherapy-modality 0..* MS and
    http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique named mcode-radiotherapy-technique 0..* and    
    radiotherapy-dose-prescribed-to-volume named radiotherapy-dose-prescribed-to-volume 0..* MS
* extension[mcode-radiotherapy-modality].value[x] from http://hl7.org/fhir/us/mcode/ValueSet/mcode-radiotherapy-modality-vs (required) //Probably required in mCODE prescription.
* extension[mcode-radiotherapy-technique].value[x] from http://hl7.org/fhir/us/mcode/ValueSet/mcode-radiotherapy-technique-vs (required) //Probably  required in mCODE prescription.
* identifier MS
* identifier.system MS
* identifier.value 1..1 MS
* replaces MS
* replaces ^short = "Previous retired request that is replaced by this request" //Defined a short so the element is shown even if it is not MS 
* status MS
* intent MS
* intent = ReqIntent#order "order"
* category 1..* MS
* category = SCT#108290001 "Radiation oncology AND/OR radiotherapy" 
* code 1..1 MS
* doNotPerform 0..0
* quantity[x] 0..0 // In RT dose to multiple targets has to be covered. Therefore, we have a dedicated extension radiotherapyPrescribedDose
* subject 1..1 MS
* subject only Reference(Patient)
* asNeeded[x] 0..0
* requester MS //Approval user
* requester only Reference(Practitioner or PractitionerRole or Organization)
* reasonCode MS
* reasonReference MS 
* reasonReference only Reference(Condition)
* specimen 0..0
//TBD mCODE TODO requires * bodySite from RadiotherapyTreatmentLocationVS (required). 
* bodySite MS
* bodySite ^short = "Body site that is treated with Radiotherapy"
* note MS

// Common for External Beam and Brachy Phase Prescription
RuleSet: RadiotherapyPhasePrescriptionCommon
* extension contains
    radiotherapy-fractions-prescribed named radiotherapy-fractions-prescribed 1..1 MS and
    radiotherapy-energy named radiotherapy-energy 0..* and
    radiotherapyTreatmentDeviceType named radiotherapyTreatmentDeviceType 0..*
* extension[mcode-radiotherapy-technique] MS
* extension[radiotherapy-dose-prescribed-to-volume] 0..* MS
* extension[radiotherapy-dose-prescribed-to-volume].extension[fractionsPrescribed] 0..0
* extension[radiotherapy-dose-prescribed-to-volume].extension[fractionsPrescribed] ^short = "Not used in this profile. In a Phase, all volumes are involved in all Fractions."
* extension[radiotherapy-dose-prescribed-to-volume].extension[fractionsPrescribed] ^definition = "Not used in this profile. In a Phase, all volumes are involved in all Fractions and the number of Fractions is defined in extension radiotherapy-fractions-prescribed. To achieve different numbers of Fractions for different volumes, multiple Phases have to be defined."
* occurrenceTiming only Timing
* occurrenceTiming MS
* occurrenceTiming.repeat.boundsPeriod 0..1
* occurrenceTiming.repeat.boundsPeriod only Period
* occurrenceTiming.repeat.frequency 0..1
* occurrenceTiming.repeat.period 0..1
* occurrenceTiming.repeat.periodUnit 0..1 

// Modelled in alignment with mCODE Teleradiotherapy Treatment Phase.
Profile: TeleradiotherapyPhasePrescription
Parent: ServiceRequest 
Id: TeleradiotherapyPhasePrescription
Title: "Teleradiotherapy Phase Prescription"
Description: "A Teleradioherapy Phase Prescription is a request for one series of fractionated treatments using External Beam Radiotherapy. It can define treatment parameters such as modality or technique,
and prescribe dose to multiple targets."
* insert RadiotherapyRequestCommon
* code = RadiotherapyRequest#teleradiotherapy-phase-prescription "Teleradiotherapy Phase Prescription" 	

// Modelled in alignment with mCODE Teleradiotherapy Treatment Phase.
Profile: BrachytherapyPhasePrescription
Parent: ServiceRequest 
Id: BrachytherapyPhasePrescription
Title: "Brachytherapy Phase Prescription"
Description: "A Brachytherapy Phase Prescription is a request for one series of fractionated treatments using Brachytherapy. It can define treatment parameters such as modality or technique,
and prescribe dose to multiple targets."
* insert RadiotherapyRequestCommon
* code = RadiotherapyRequest#brachytherapy-phase-prescription "Brachytherapy Phase Prescription" 	


// -------- Example Instances ---------------------------------------------------------

Instance: TeleradiotherapyPhasePrescription-04-XRTS-Prostate-Phase1
InstanceOf: TeleradiotherapyPhasePrescription
Description: "Radiotherapy PhasePrescription to cover IHE-RO XRTS profile for a Prostate example, phase 1."
Usage: #example
* id = "TeleradiotherapyPhasePrescription-04-XRTS-Prostate-Phase1" //id of the FHIR Resource
* meta.versionId = "219952" //Version of the resource on the server
* meta.lastUpdated = "2020-07-03T10:07:41.050+02:00" //Update of the resource on the server. See separate extentsion for modification date of clinical contents.
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/TeleradiotherapyPhasePrescription"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept = SCT#373808002 "Curative - procedure intent"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept.text = "Curative"   
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#1156506007 "External beam radiation therapy using photons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[1] = http://varian.com/fhir/CodeSystem/aria-radiotherapyPrescriptionTechnique#ARC "Arc"
* extension[radiotherapy-energy].valueQuantity.value = 18 //unit is fixed in profile
* extension[radiotherapy-fractions-prescribed].valuePositiveInt = 25
// Prescription Target Site "Prostate"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-03-Prostate"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionDosePrescribed].valueQuantity.value = 180 //unit cGy is automatically added because fixed in the profile 
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 4500 
// Prescription Target Site "Pelv Ns"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-04-PelvNs"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[fractionDosePrescribed].valueQuantity.value = 180 
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[totalDosePrescribed].valueQuantity.value = 4500 
// Prescription Target Site "Sem Vs"
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-05-SemVs"
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[fractionDosePrescribed].valueQuantity.value = 180 
* extension[radiotherapy-dose-prescribed-to-volume][2].extension[totalDosePrescribed].valueQuantity.value = 4500 
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyPhasePrescriptionId"
* identifier[0].value = "Prostate-Phase1"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456" 
* basedOn.reference = "ServiceRequest/RadiotherapyCoursePrescription-04-XRTS-Prostate" //Intent that this prescription bases on
//* replaces.reference = "ServiceRequest/RadiotherapyPhasePrescription-0" //Previous retired PhasePrescription that is replaced by this PhasePrescription
* status = #active
* subject.reference = "Patient/Patient-6"
* subject.display = "Peter Venkman"
* occurrenceTiming.repeat.boundsPeriod.start = "2020-07-03T00:00:00+02:00" //Expected start date
//* occurrenceTiming.code = http://varian.com/fhir/CodeSystem/aria-radiotherapyPrescriptionFrequency#"5 TIMES A WEEK" "5 Times a week" //Probaly not coded in XRTS
* occurrenceTiming.code.text = "5 Times a week"
* authoredOn =  "2020-07-02T00:00:00+02:00" // "Date and time the Intent was signed" 
* requester.reference = "Practitioner/Practitioner-1005"
* requester.display = "aria\\user1"
* reasonCode = ICD10#C61.0 "Malignant neoplasm of prostate" //Try to use Condition resource for diagnosis in XRTS
* reasonCode.text = "Malignant neoplasm of prostate" //Try to use Condition resource for diagnosis in XRTS 
* reasonReference.reference = "Condition/Diagnosis-2-Prostate" 
* bodySite = SCT#181422007 "Entire Prostate" // "Body site that is treated with Radiotherapy"
* bodySite.text = "Prostate" 
* note.text = "Free text note in Radiotherapy Prescription"

Instance: TeleradiotherapyPhasePrescription-05-XRTS-Prostate-Phase2
InstanceOf: TeleradiotherapyPhasePrescription
Description: "Radiotherapy PhasePrescription to cover IHE-RO XRTS profile for a Prostate example, phase 2."
Usage: #example
* id = "TeleradiotherapyPhasePrescription-05-XRTS-Prostate-Phase2" //id of the FHIR Resource
* meta.versionId = "219952" //Version of the resource on the server
* meta.lastUpdated = "2020-07-03T10:07:41.050+02:00" //Update of the resource on the server. See separate extentsion for modification date of clinical contents.
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/TeleradiotherapyPhasePrescription"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept = SCT#373808002 "Curative - procedure intent"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-treatment-intent].valueCodeableConcept.text = "Curative"   
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#1156506007 "External beam radiation therapy using photons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[1] = http://varian.com/fhir/CodeSystem/aria-radiotherapyPrescriptionTechnique#ARC "Arc"
* extension[radiotherapy-energy].valueQuantity.value = 18 //unit is fixed in profile
* extension[radiotherapy-fractions-prescribed].valuePositiveInt = 19
// Prescription Target Site "Prostate"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-03-Prostate" 
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionDosePrescribed].valueQuantity.value = 200 //unit cGy is automatically added because fixed in the profile
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 3800 
// Prescription Target Site "Sem Vs"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-05-SemVs"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[fractionDosePrescribed].valueQuantity.value = 180 
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[totalDosePrescribed].valueQuantity.value = 3420 
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyPhasePrescriptionId"
* identifier[0].value = "Prostate-Phase2"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456" 
* basedOn.reference = "ServiceRequest/RadiotherapyCoursePrescription-04-XRTS-Prostate" //Intent that this prescription bases on
* basedOn.display =  "Prostate-2Phases"
//* replaces.reference = "ServiceRequest/RadiotherapyPhasePrescription-0" //Previous retired PhasePrescription that is replaced by this PhasePrescription
* status = #active
* subject.reference = "Patient/Patient-6"
* subject.display = "Peter Venkman"
* occurrenceTiming.repeat.boundsPeriod.start = "2020-07-03T00:00:00+02:00" //Expected start date
//* occurrenceTiming.code = http://varian.com/fhir/CodeSystem/aria-radiotherapyPrescriptionFrequency#"5 TIMES A WEEK" "5 Times a week"
* occurrenceTiming.code.text = "5 Times a week"
* authoredOn =  "2020-07-02T00:00:00+02:00" // "Date and time the Intent was signed" 
* requester.reference = "Practitioner/Practitioner-1005"
* requester.display = "aria\\user1"
* reasonCode = ICD10#C61.0 "Malignant neoplasm of prostate" //Try to use Condition resource for diagnosis in XRTS
* reasonCode.text = "Malignant neoplasm of prostate" //Try to use Condition resource for diagnosis in XRTS 
* reasonReference.reference = "Condition/Diagnosis-2-Prostate" 
* bodySite = SCT#181422007 "Entire Prostate" // "Body site that is treated with Radiotherapy"
* bodySite.text = "Prostate"
* note.text = "Free text note in Radiotherapy PhasePrescription"


Instance: TeleradiotherapyPhasePrescription-11-RTTD-LeftBreastTangents
InstanceOf: TeleradiotherapyPhasePrescription
Description: "Radiotherapy Phase Prescription example from Codex RTTD collection."
Usage: #example
* id = "TeleradiotherapyPhasePrescription-11-RTTD-LeftBreastTangents" //id of the FHIR Resource
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/TeleradiotherapyPhasePrescription"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#1156506007 "External beam radiation therapy using photons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
* extension[radiotherapy-fractions-prescribed].valuePositiveInt = 25
// Prescription Target Site "Left Breast"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-11-LeftBreast"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionDosePrescribed].valueQuantity.value = 200  
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 5000 
// Prescription Target Site "Left Breast Boost"
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-12-LeftBreastBoost"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionDosePrescribed].valueQuantity.value = 200  
* extension[radiotherapy-dose-prescribed-to-volume][1].extension[totalDosePrescribed].valueQuantity.value = 5000 
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyPhaseId"
* identifier[0].value = "Left Breast Tangents"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456.2.1" 
* status = #active
* subject.reference = "Patient/Patient-5"
* bodySite = SCT#76752008 "Breast structure (body structure)" 
* note.text = "Free text note in Radiotherapy Phase Prescription"


Instance: TeleradiotherapyPhasePrescription-12-RTTD-LeftBreastBoost
InstanceOf: TeleradiotherapyPhasePrescription
Description: "Radiotherapy Phase Prescription example from Codex RTTD collection."
Usage: #example
* id = "TeleradiotherapyPhasePrescription-12-RTTD-LeftBreastBoost" //id of the FHIR Resource
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/TeleradiotherapyPhasePrescription"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#45643008 "Teleradiotherapy using electrons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
* extension[radiotherapy-fractions-prescribed].valuePositiveInt = 5
// Prescription Target Site "Left Breast Boost"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-12-LeftBreastBoost"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionDosePrescribed].valueQuantity.value = 200  
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 1000 
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyPhaseId"
* identifier[0].value = "Left Breast Boost"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456.2.1" 
* status = #active
* subject.reference = "Patient/Patient-5"
* bodySite = SCT#76752008 "Breast structure (body structure)" 
* note.text = "Free text note in Radiotherapy Phase Prescription"


Instance: TeleradiotherapyPhasePrescription-13-RTTD-RightBreastTangents
InstanceOf: TeleradiotherapyPhasePrescription
Description: "Radiotherapy Phase Prescription example from Codex RTTD collection."
Usage: #example
* id = "TeleradiotherapyPhasePrescription-13-RTTD-RightBreastTangents" //id of the FHIR Resource
* meta.profile = "https://profiles.ihe.net/RO.XRTS/StructureDefinition/TeleradiotherapyPhasePrescription"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-modality][0].valueCodeableConcept = SCT#1156506007 "External beam radiation therapy using photons (procedure)"
* extension[http://hl7.org/fhir/us/mcode/StructureDefinition/mcode-radiotherapy-technique][0].valueCodeableConcept.coding[0] = SCT#1156526006 "Three dimensional external beam radiation therapy (procedure)"
* extension[radiotherapy-fractions-prescribed].valuePositiveInt = 25
// Prescription Target Site "Right Breast"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[volume].valueReference.reference = "BodyStructure/RadiotherapyVolume-13-RightBreast"
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[fractionDosePrescribed].valueQuantity.value = 200  
* extension[radiotherapy-dose-prescribed-to-volume][0].extension[totalDosePrescribed].valueQuantity.value = 5000 
* identifier[0].use = #usual
* identifier[0].system = "http://varian.com/fhir/identifier/radiotherapyPhaseId"
* identifier[0].value = "Right Breast Tangents"
* identifier[1].system = "urn:dicom:uid"
* identifier[1].value = "urn:oid:2.16.124.113543.1154777499.30246.19789.3503430456.2.1" 
* status = #active
* subject.reference = "Patient/Patient-5"
* bodySite = SCT#76752008 "Breast structure (body structure)" 
* note.text = "Free text note in Radiotherapy Phase Prescription"