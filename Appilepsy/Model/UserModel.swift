//
//  UserModel.swift
//  POSE SP
//
//  Created by SachTech on 26/03/20.
//  Copyright © 2020 SachTech. All rights reserved.
//

import Foundation

struct InterviewModel {

    var name: String!
    var age: String!
    var gender: String!
    var race: String!
    var gradeSchool: String!
    var phoneNumber: String!
    var email: String!
    var doesSubjectLive: String!
    var zipCode: String!
    var caregiversName: String!
    var caregiversPhoneNumber: String!
    var caregiversEmail: String!
    var healthcareProviderName: String!
    var typeOfEpilepsy: String!
    var lastSeizureEvent: String!
    var frequenciesOfSeizure: String!
    var numberOfPrescribedMedications: String!
    var medicine1: String!
    var medicine2: String!
    var medicine3: String!
    var medicine4: String!
    var allergiesMedications: String!
    var healthcareProviderPhoneNumber: String!
    var healthcareProviderEmail: String!
    var pharmacyName: String!
    var pharmacyPhoneNumber: String!
    var nameEmergencyContact: String!
    var emergencyContactNumber: String!
    var arrMedicines: [MedicineProfileModel] = []
    
    init(dict:NSDictionary){
        self.name = dict.value(forKey: "name") as? String ?? ""
        self.age = dict.value(forKey: "age") as? String ?? ""
        self.gender = dict.value(forKey: "gender") as? String ?? ""
        self.race = dict.value(forKey: "race") as? String ?? ""
        self.gradeSchool = dict.value(forKey: "grade_school") as? String ?? ""
        self.phoneNumber = dict.value(forKey: "phone_number") as? String ?? ""
        self.email = dict.value(forKey: "email") as? String ?? ""
        self.doesSubjectLive = dict.value(forKey: "oes_subject_live") as? String ?? ""
        self.zipCode = dict.value(forKey: "zip_code") as? String ?? ""
        self.caregiversName = dict.value(forKey: "caregivers_name") as? String ?? ""
        self.caregiversPhoneNumber = dict.value(forKey: "caregivers_phone_number") as? String ?? ""
        self.caregiversEmail = dict.value(forKey: "caregivers_email") as? String ?? ""
        self.healthcareProviderName = dict.value(forKey: "healthcare_provider_name") as? String ?? ""
        self.typeOfEpilepsy = dict.value(forKey: "type_of_epilepsy") as? String ?? ""
        self.lastSeizureEvent = dict.value(forKey: "last_seizure_event") as? String ?? ""
        self.frequenciesOfSeizure = dict.value(forKey: "frequencies_of_seizure") as? String ?? ""
        self.numberOfPrescribedMedications = dict.value(forKey: "number_of_prescribed_medications") as? String ?? ""
        self.medicine1 = dict.value(forKey: "medicine_1") as? String ?? ""
        self.medicine2 = dict.value(forKey: "medicine_2") as? String ?? ""
        self.medicine3 = dict.value(forKey: "medicine_3") as? String ?? ""
        self.medicine4 = dict.value(forKey: "medicine_4") as? String ?? ""
        self.allergiesMedications = dict.value(forKey: "allergies_medications") as? String ?? ""
        self.healthcareProviderPhoneNumber = dict.value(forKey: "healthcare_provider_phone_number") as? String ?? ""
        self.healthcareProviderEmail = dict.value(forKey: "healthcare_provider_email") as? String ?? ""
        self.pharmacyName = dict.value(forKey: "pharmacy_name") as? String ?? ""
        self.pharmacyPhoneNumber = dict.value(forKey: "pharmacy_phone_number") as? String ?? ""
        self.nameEmergencyContact = dict.value(forKey: "name_emergency_contact") as? String ?? ""
        self.emergencyContactNumber = dict.value(forKey: "emergency_contact_number") as? String ?? ""
        
        if let medicines = dict.value(forKey: "medicines") as? [[String:Any]]{
            for med in medicines{
                let data = MedicineProfileModel(med)
                self.arrMedicines.append(data)
            }
        }
    }
    
}

struct UserModel {
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var isParent: String?
    var parentEmail: String?
    var notes: String?
    var phone: String?
    var profile_image: String?
    var nick_name: String?
    var status: String?
    var otp: String?
    var fcmToken: String?
    var createdOn: String?
    var updatedOn: String?
    var user_timezone: String?

    init(dict:NSDictionary){
        self.userId = dict.value(forKey: "user_id") as? String ?? ""
        self.firstName = dict.value(forKey: "first_name") as? String ?? ""
        self.lastName = dict.value(forKey: "last_name") as? String ?? ""
        self.email = dict.value(forKey: "email") as? String ?? ""
        self.phone = dict.value(forKey: "mobile") as? String ?? ""
        self.password = dict.value(forKey: "password") as? String ?? ""
        self.isParent = dict.value(forKey: "is_parent") as? String ?? ""
        self.parentEmail = dict.value(forKey: "parent_email") as? String ?? ""
        self.profile_image = dict.value(forKey: "profile_image") as? String ?? ""
        self.nick_name = dict.value(forKey: "nick_name") as? String ?? ""
        self.notes = dict.value(forKey: "notes") as? String ?? ""
        self.status = dict.value(forKey: "status") as? String ?? ""
        self.user_timezone = dict.value(forKey: "user_timezone") as? String ?? ""
        self.otp = dict.value(forKey: "otp") as? String ?? ""
        self.fcmToken = dict.value(forKey: "fcm_token") as? String ?? ""
        self.createdOn = dict.value(forKey: "created_on") as? String ?? ""
        self.updatedOn = dict.value(forKey: "updated_on") as? String ?? ""
    }
}


