//--------------------------------------------------------------------------------------------------------
// First drafts for XRTS. Not consolidated with IHE-RO XRTS yet.
// Contact: martin.vonsiebenthal@varian.com
//--------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------
ValueSet: RadiotherapyRequest 
Id: radiotherapy-request 
Title: "ServiceRequest  Code"
Description: "A code that identifies the detailed kind of service request."
* ^url = http://varian.com/fhir/ValueSet/servicerequest-code
* ^status = #draft
* codes from system RadiotherapyRequest 

CodeSystem: RadiotherapyRequest
Id: radiotherapy-request 
Title: "Radiotherapy Request"
Description: "Specifies which kind of Radiotherpy Request is covered by a Request resource."
* ^url = http://varian.com/fhir/CodeSystem/radiotherapy-request //see http://hl7.org/fhir/us/mcode/CodeSystem/mcode-resource-identifier-cs
* #radiotherapy-course-prescription	"Radiotherapy Course Prescription" 	"Identifies a ServiceRequest resource for a complete Course of Radiotherapy treatment."
* #teleradiotherapy-phase-prescription "Teleradiotherapy Phase Prescription" "Identifies a ServiceRequest resource for a single Phase of external beam radiotherapy treatment."
* #brachytherapy-phase-prescription	"Brachytherapy Phase Prescription" 	"Identifies a ServiceRequest resource for  a single Phase of brachytherapy."
* #teleradiotherapy-treatment-plan	"Teleradiotherapy Treatment Plan" 	"Identifies a ServiceRequest resource for one External Beam Radiotherapy Treatment Plan."
* #teleradiotherapy-QA-plan	"Teleradiotherapy Treatment Plan" 	"Identifies a ServiceRequest resource for one External Beam Radiotherapy QA Plan."
* #brachytherapy-treatment-plan	"Brachytherapy Treatment Plan" 	"Identifies a ServiceRequest resource for one Brachytherapy Treatment Plan."
