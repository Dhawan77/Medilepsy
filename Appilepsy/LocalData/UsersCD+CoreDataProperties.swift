//
//  UsersCD+CoreDataProperties.swift
//  
//
//  Created by SachTech on 11/05/20.
//
//

import Foundation
import CoreData


extension UsersCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersCD> {
        return NSFetchRequest<UsersCD>(entityName: CoreDataKeys.user)
    }

    
    @NSManaged public var userId: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var isParent: String
    @NSManaged public var parentEmail: String
    @NSManaged public var age: String
    @NSManaged public var gender: String
    @NSManaged public var race: String
    @NSManaged public var gradeLevel: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var zipCode: String
    @NSManaged public var allergiesToMeds: String
    @NSManaged public var healthCareProvider: String
    @NSManaged public var healthcareProviderNumber: String
    @NSManaged public var healthcareProviderEmail: String
    @NSManaged public var pharmacy: String
    @NSManaged public var pharmacyNumber: String
    @NSManaged public var emergencyContact: String
    @NSManaged public var emergencyContractNumber: String
    @NSManaged public var caregiverName: String
    @NSManaged public var caregiverPhone: String
    @NSManaged public var caregiverEmail: String
    @NSManaged public var caregiverLive: String
    @NSManaged public var epilepsySyndrome: String
    @NSManaged public var lastSeizureEvent: String
    @NSManaged public var seizureFrequency: String
    @NSManaged public var numberOfPrescribed: String
    @NSManaged public var listOfMedications: String
    @NSManaged public var notes: String
    @NSManaged public var status: String
    @NSManaged public var otp: String
    @NSManaged public var fcmToken: String
    @NSManaged public var createdOn: String
    @NSManaged public var updatedOn: String
   
    
}
