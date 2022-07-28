//
//  UsersCD+CoreDataClass.swift
//  
//
//  Created by SachTech on 11/05/20.
//
//

import Foundation
import CoreData

@objc(UsersCD)
public class UsersCD: NSManagedObject {
    
    static let share = UsersCD()
      
      @nonobjc public class func insertRequest(context:NSManagedObjectContext) -> UsersCD {
          return NSEntityDescription.insertNewObject(forEntityName: CoreDataKeys.user, into:context ) as! UsersCD
    }
    
    func setUserInDb(user: InterviewModel) {
//        self.userId = user.userId!
//        self.firstName = user.firstName!
//        self.lastName = user.lastName!
//        self.age = user.age!
//        self.allergiesToMeds = user.allergiesToMeds!
//        self.caregiverEmail = user.caregiverEmail!
//        self.caregiverLive = user.caregiverLive!
//        self.caregiverName = user.caregiverName!
//        self.caregiverPhone = user.caregiverPhone!
//        self.createdOn = user.createdOn!
//        self.email = user.email!
//        self.emergencyContact = user.emergencyContact!
//        self.emergencyContractNumber = user.emergencyContractNumber!
//        self.epilepsySyndrome = user.epilepsySyndrome!
//        self.fcmToken = user.fcmToken!
//        self.gender = user.gender!
//        self.gradeLevel = user.gradeLevel!
//        self.healthCareProvider = user.healthCareProvider!
//        self.healthcareProviderEmail = user.healthcareProviderEmail!
//        self.healthcareProviderNumber = user.healthcareProviderNumber!
//        self.isParent = user.isParent!
//        self.lastSeizureEvent = user.lastSeizureEvent!
//        self.listOfMedications = user.listOfMedications!
//        self.notes = user.notes!
//        self.numberOfPrescribed = user.numberOfPrescribed!
//        self.otp = user.otp!
//        self.parentEmail = user.parentEmail!
//        self.password = user.password!
//        self.pharmacy = user.pharmacy!
//        self.pharmacyNumber = user.pharmacy!
//        self.phoneNumber = user.phoneNumber!
//        self.race = user.race!
//        self.seizureFrequency = user.seizureFrequency!
//        self.status = user.status!
//        self.updatedOn = user.updatedOn!
//        self.zipCode = user.zipCode!
    }
    
    func getAllUsers() -> [UsersCD] {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataKeys.user)
        fetchReq.resultType = .managedObjectResultType;
        
        var result = [UsersCD]()
        do {
            result =  try CoreDataStack.sharedInstance.getContext().fetch(fetchReq) as! [UsersCD]
        } catch {
        }
        return result
    }
    
   
    
   
}
