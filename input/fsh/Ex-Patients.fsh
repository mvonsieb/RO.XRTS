Instance:   Patient-6
InstanceOf: Patient
Title: "Example Patient"
Description: "An example patient to relate Radiotherapy resources to."
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
* identifier[0].use = #usual
* identifier[0].type = http://terminology.hl7.org/CodeSystem/v2-0203#MR "Medical Record Number"
* identifier[0].system = "http://hospital.smarthealthit.org"
* identifier[0].value = "1032702"
* name[0].use = #usual
* name[0].family = "Venkman"
* name[0].given = "Peter"
* telecom.system = #phone
* telecom.value = "555-555-5555"
* telecom.use = #home
* gender = #other
* birthDate = "1923-07-25"
* address.state = "WI"
* address.country = "USA"
* address.line = "49 Meadow St"
* address.city = "Mounds"
* address.state = "OK"
* address.postalCode = "74047"
* address.country = "US"
