//
//  HitApi.swift
//  Nerd
//
//  Created by SachTech on 08/08/19.
//  Copyright © 2019 SachTech. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import NVActivityIndicatorView

class HitApi
{
    public static let BASE_URL = "http://52.44.62.112/api/v1/"
    public let API_KEY = "AsT@12620_!!!@"

    private static var api:HitApi!
    private static var apiLinker:ApiLinker!
    
    class func share() -> HitApi{
        if api == nil {
            api = HitApi()
            apiLinker = ApiLinker()
        }
        return api
    }
    
    let LOGIN_URL = BASE_URL+"user/login"
    let REGISTER_URL = BASE_URL+"user/register"
    let SEND_CODE = BASE_URL+"user/send_otp"
    let RESET_PWD = BASE_URL+"user/reset_password"
    let ADD_REMINDER = BASE_URL+"user/add_medicine_reminder"
    let TAKE_MED = BASE_URL+"user/medicine_taked"
    let UPDATE_NOTE = BASE_URL+"user/userNotes"
    let UPDATE_PROFILE = BASE_URL+"user/updateProfile"
    let GET_MED_SHAPES = BASE_URL+"medicine/get_medicines_shape"
    let GET_ALL_MEDS = BASE_URL+"medicine/get_all_medicines"
    let UPDATE_FORM = BASE_URL+"user/interview_form"
    let GET_FORM = BASE_URL+"user/get_interview_form_byuser"
    let GET_REMINDERS = BASE_URL+"medicine/get_perticular_medicine_reminder"
    let GET_ADHERENCE = BASE_URL+"medicine/get_medicines_bytime"
    let DELETE_REMINDER = BASE_URL+"medicine/delete_reminder"
    let NOTIFY_CAREGIVER = BASE_URL+"medicine/caregiver_notify"
    let GET_GRAPH_DATA = BASE_URL+"user/get_graph_reward"
    let GET_REWARD_DATA = BASE_URL+"user/get_reward"
    let UPDATE_GOAL = BASE_URL+"user/add_goal"
    let REGISTER_ACTIVITY = BASE_URL+"user/activity"
    let UPDATE_TIMEZONE = BASE_URL+"user/update_timezone"

    func login(view:UIView,email:String,password:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: LOGIN_URL, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["email"] = email as AnyObject
            param["password"] = password as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["fcm_token"] = (AppPreferences.share.get(forkey: .fcmToken) as? String ?? "dummyfcmtoken") as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSDictionary ?? [:]
                self.saveData(userData: UserModel(dict: data))
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func updateTimeZone(completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: false).requestMethod(method: .post).execute(view:nil,url: UPDATE_TIMEZONE, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func register(view:UIView,firstName:String,lastName:String,isParent:String,parentEmail:String,email:String,password:String,mobile:String, completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: REGISTER_URL, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["first_name"] = firstName as AnyObject
            param["last_name"] = lastName as AnyObject
            param["email"] = email as AnyObject
            param["password"] = password as AnyObject
            param["is_parent"] = isParent as AnyObject
            param["fcm_token"] = (AppPreferences.share.get(forkey: .fcmToken) as? String ?? "dummyfcmtoken") as AnyObject
            param["parent_email"] = parentEmail as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["mobile"] = mobile as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func updateProfile(firstName:String,lastName:String,isParent:String,parentEmail:String,nickName:String,mobile:String,imageData:UIImage,completion:@escaping (String,Bool)->Void){
        var param = [String:AnyObject]()
        param["API_KEY"] = API_KEY as AnyObject
        param["user_id"] = AppPreferences.share.get(forkey: .userID)
        param["first_name"] = firstName as AnyObject
        param["last_name"] = lastName as AnyObject
        param["user_timezone"] = TimeZone.current.identifier as AnyObject
        param["mobile"] = mobile as AnyObject
        param["is_parent"] = isParent as AnyObject
        param["nick_name"] = nickName as AnyObject
        param["parent_email"] = parentEmail as AnyObject
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData.jpegData(compressionQuality: 0.5)!, withName: "profile_image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: UPDATE_PROFILE,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let value = response.value as? NSDictionary
                    let status = value?["Status"] as? Bool ?? false
                    let message = value?["Message"] as? String ?? ""
                    let data = value?["data"] as? NSDictionary ?? [:]
                    let d = data["data"] as? NSDictionary ?? [:]
                    if status{
                        self.saveData(userData: UserModel(dict: d))}
                    completion(message,status)
                }
            case .failure(let error):
                completion("\(error.localizedDescription)",false)
                
            }
        })
    }
    
    func setRewardGoal(view:UIView,week1Goal:String,week2Goal:String,week3Goal:String,week4Goal:String,week5Goal:String,week1Reward:String,week2Reward:String,week3Reward:String,week4Reward:String,week5Reward:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: UPDATE_GOAL, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["week_1_goal"] = week1Goal as AnyObject
            param["week_2_goal"] = week2Goal as AnyObject
            param["week_3_goal"] = week3Goal as AnyObject
            param["week_4_goal"] = week4Goal as AnyObject
            param["week_5_goal"] = week5Goal as AnyObject
            param["week_1_reward"] = week1Reward as AnyObject
            param["week_2_reward"] = week2Reward as AnyObject
            param["week_3_reward"] = week3Reward as AnyObject
            param["week_4_reward"] = week4Reward as AnyObject
            param["week_5_reward"] = week5Reward as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
            
    
    func forgotPwd(view:UIView,email:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: SEND_CODE, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["email"] = email as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func resetPwd(view:UIView,email:String,password:String,otp:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: RESET_PWD, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["email"] = email as AnyObject
            param["otp"] = otp as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["password"] = password as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func getMedShapes(view:UIView,completion:@escaping (Bool,String,[ShapeModel])->Void){
        var shapes = [ShapeModel]()
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_MED_SHAPES, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSArray ?? []
                for d in data
                {
                    shapes.append(ShapeModel(dict: d as? NSDictionary ?? [:]))
                }
                completion(status,msg,shapes)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error",shapes)
        }}
    
    func getAllMeds(view:UIView,completion:@escaping (Bool,String,[MedicineModel])->Void){
        var meds = [MedicineModel]()
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_ALL_MEDS, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSArray ?? []
                for d in data
                {
                    meds.append(MedicineModel(dict: d as? NSDictionary ?? [:]))
                }
                completion(status,msg,meds)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error",meds)
        }}
    
    func getRewardData(view:UIView,completion:@escaping (Bool,String,RewardModel)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_REWARD_DATA, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSDictionary ?? [:]
                completion(status,msg,RewardModel(dict: data))
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error",RewardModel(dict: [:]))
        }}
    
    
    func registerUserActivity(view:UIView,activityType:String,time:String,actual_time:String,date:String,linkSting:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: REGISTER_ACTIVITY, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["activity_type"] = activityType as AnyObject
            param["link"] = linkSting as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["date"] = date as AnyObject
            param["time"] = time as AnyObject
            param["actual_time"] = actual_time as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)

            }})
        {
            (error) in
            completion(false,error?.description ?? "")
        }}
    
    
    func getReminders(view:UIView,completion:@escaping (Bool,String,[ReminderModel])->Void){
        var meds = [ReminderModel]()
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_REMINDERS, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSArray ?? []
                for d in data
                {
                    meds.append(ReminderModel(dict: d as? NSDictionary ?? [:]))
                }
                completion(status,msg,meds)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error",meds)
        }}
    
    func deleteReminder(view:UIView,id:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: DELETE_REMINDER, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["id"] = id as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    
    func getAdherance(view:UIView,date:String,completion:@escaping (Bool,String,[ReminderModel])->Void){
        var meds = [ReminderModel]()
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_ADHERENCE, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["taken_date"] = date as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSArray ?? []
                for d in data
                {
                    meds.append(ReminderModel(dict: d as? NSDictionary ?? [:]))
                }
                completion(status,msg,meds)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error",meds)
        }}
    
    
    func getGraphData(view:UIView,startDate:String,endDate:String,completion:@escaping (Bool,String,[ReminderModel])->Void){
        var meds = [ReminderModel]()
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_GRAPH_DATA, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["start_date"] = startDate as AnyObject
            param["end_date"] = endDate as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSArray ?? []
                for d in data
                {
                    meds.append(ReminderModel(dict: d as? NSDictionary ?? [:]))
                }
                completion(status,msg,meds)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error",meds)
        }}
    
    func updateNote(view:UIView,note:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: UPDATE_NOTE, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["notes"] = note as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func getForm(view:UIView,completion:@escaping (Bool,String,InterviewModel)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: GET_FORM, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                print(response)
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                let data = response["data"] as? NSDictionary ?? [:]
                
                completion(status,msg,InterviewModel(dict: data))
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error", InterviewModel(dict: [:]))
        }}
    
    func updateInterviewForm(view:UIView,data:InterviewModel,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: UPDATE_FORM, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["name"] = data.name as AnyObject
            param["age"] = data.age as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["gender"] = data.gender as AnyObject
            param["race"] = data.race as AnyObject
            param["grade_school"] = data.gradeSchool as AnyObject
            param["phone_number"] = data.phoneNumber as AnyObject
            param["email"] = data.email as AnyObject
            param["does_subject_live"] = data.doesSubjectLive as AnyObject
            param["zip_code"] = data.zipCode as AnyObject
            param["caregivers_name"] = data.caregiversName as AnyObject
            param["caregivers_phone_number"] = data.caregiversPhoneNumber as AnyObject
            param["caregivers_email"] = data.caregiversEmail as AnyObject
            param["healthcare_provider_name"] = data.healthcareProviderName as AnyObject
            param["type_of_epilepsy"] = data.typeOfEpilepsy as AnyObject
            param["last_seizure_event"] = data.lastSeizureEvent as AnyObject
            param["frequencies_of_seizure"] = data.frequenciesOfSeizure as AnyObject
            param["number_of_prescribed_medications"] = data.numberOfPrescribedMedications as AnyObject

            let meds = MedicineProfileModel.toDictionary(arrMeds: data.arrMedicines)

            let medString = MedicineProfileModel.JSONStringify(value: meds as AnyObject)
            param["medicines"] = medString as AnyObject
            param["allergies_medications"] = data.allergiesMedications as AnyObject
            param["healthcare_provider_phone_number"] = data.healthcareProviderPhoneNumber as AnyObject
            param["healthcare_provider_email"] = data.healthcareProviderEmail as AnyObject
            param["pharmacy_name"] = data.pharmacyName as AnyObject
            param["pharmacy_phone_number"] = data.pharmacyPhoneNumber as AnyObject
            param["name_emergency_contact"] = data.nameEmergencyContact as AnyObject
            param["emergency_contact_number"] = data.emergencyContactNumber as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    
    func addReminder(view:UIView,brandName:String,genericName:String,doseQuantity:String,reminderTime:AnyObject,endDate:AnyObject,reminderDate:String,note:String,unit:String,shapeId:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: ADD_REMINDER, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["brand_name"] = brandName as AnyObject
            param["generic_name"] = genericName as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["dose_quantity"] = doseQuantity as AnyObject
            param["reminder_time"] = reminderTime as AnyObject
            param["reminder_date"] = reminderDate as AnyObject
            param["end_date"] = endDate as AnyObject
            param["unit"] = unit as AnyObject
            param["caregiver_email"] = AppPreferences.share.get(forkey: .parentEmail)
            param["shape_id"] = shapeId as AnyObject
            param["notes"] = note as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    
    
    func takeMedicine(view:UIView,medID:String,takenDate:String,medName:String,genricName:String,time:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: TAKE_MED, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["taken_date"] = takenDate as AnyObject
            param["taken_time"] = time as AnyObject
            param["medicine_name"] = medName as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            param["generic_name"] = genricName as AnyObject
            param["id"] = medID as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
    
    func updateCaregiver(view:UIView,reminderId:String,completion:@escaping (Bool,String)->Void){
        HitApi.apiLinker.setProgress(isProgress: true).requestMethod(method: .post).execute(view:view,url: NOTIFY_CAREGIVER, parameters: { () -> [String : AnyObject] in
            var param = [String:AnyObject]()
            param["API_KEY"] = API_KEY as AnyObject
            param["user_id"] = AppPreferences.share.get(forkey: .userID)
            param["reminder_id"] = reminderId as AnyObject
            param["user_timezone"] = TimeZone.current.identifier as AnyObject
            return param
        },onResponse: { (response) in
            if let response = response{
                let status = response["Status"] as? Bool ?? false
                let msg = response["Message"] as? String ?? ""
                completion(status,msg)
            }})
        {
            (error) in
            completion(false,error?.description ?? "Error")
        }}
 
    
    
    func saveData(userData:UserModel)
    {
        AppPreferences.share.commit(data: userData.userId as AnyObject, forkey: .userID)
        AppPreferences.share.commit(data: userData.email as AnyObject, forkey: .userEmail)
        AppPreferences.share.commit(data: userData.user_timezone as AnyObject, forkey: .timeZone)
        AppPreferences.share.commit(data: userData.firstName as AnyObject, forkey: .fName)
        AppPreferences.share.commit(data: userData.lastName as AnyObject, forkey: .lName)
        AppPreferences.share.commit(data: userData.phone as AnyObject, forkey: .phone)
        AppPreferences.share.commit(data: userData.nick_name as AnyObject, forkey: .nickName)
        AppPreferences.share.commit(data: userData.profile_image as AnyObject, forkey: .userImg)
        AppPreferences.share.commit(data: userData.parentEmail as AnyObject, forkey: .parentEmail)
        AppPreferences.share.commit(data: userData.isParent as AnyObject, forkey: .isParent)
        AppPreferences.share.commit(data: userData.status as AnyObject, forkey: .status)
        AppPreferences.share.commit(data: userData.notes as AnyObject, forkey: .note)
    }

    
}
