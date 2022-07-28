//
//  AppPrefrence.swift
//  Nerd
//
//  Created by Sachtech on 03/04/18.
//  Copyright © 2018 Sachtech solution pvt. ltd. All rights reserved.
//

import Foundation
import UIKit

class AppPreferences{
    
    enum keys : String{
        
        case isLoggedIn
        case theme
        case fcmToken
        case userID
        case userEmail
        case timeZone
        case fName
        case phone
        case lName
        case nickName
        case userImg
        case parentEmail
        case isParent
        case status
        case note
        
        case rewardSign
        case rewardCaregiver

    }
    
    static let share = AppPreferences()
  
    func commit(data:AnyObject,forkey:keys){
        do {
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
           UserDefaults.standard.set(archiveData, forKey:  forkey.rawValue)
                  UserDefaults.standard.synchronize()
        } catch {
            print("Failed to Save..",error.localizedDescription)
        }
    }
    
    func get(forkey:keys)->AnyObject?{
        let archiveData = UserDefaults.standard.object(forKey: ( forkey.rawValue))
        if archiveData != nil{
            do {
                if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archiveData as! Data) {
                    return unarchivedData as AnyObject
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        
        return nil
    }
    
    func clear(){
        
        for key in UserDefaults.standard.dictionaryRepresentation().keys{
            
            UserDefaults.standard.removeObject(forKey: key.description)
        }
        UserDefaults.standard.synchronize()
        
    }
    
    func remove(_ key: keys)
    {
        UserDefaults.standard.removeObject(forKey: ( key.rawValue))
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExist(_ key: keys) -> Bool
    {
        if(UserDefaults.standard.object(forKey: ( key.rawValue)) == nil)
        {
            return false
        }
        
        return true
    }
}
