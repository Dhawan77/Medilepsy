//
//  MedicineModel.swift
//  Medilepsy
//
//  Created by John on 12/02/21.
//

import Foundation

struct MedicineModel {
    var id: String?
    var shapeId: String?
    var brandName: String?
    var genericName: String?
    var medicineImage: String?
    var unit: String?
    var img:String?
    var frequency: String?
    var status: String?
    var createdOn: String?
    var updatedOn: String?
    
    init(dict:NSDictionary){
        self.id = dict.value(forKey: "id") as? String ?? ""
        self.shapeId = dict.value(forKey: "shape_id") as? String ?? ""
        self.brandName = dict.value(forKey: "brand_name") as? String ?? ""
        self.genericName = dict.value(forKey: "generic_name") as? String ?? ""
        self.medicineImage = dict.value(forKey: "shape_url") as? String ?? ""
        self.img = dict.value(forKey: "img") as? String ?? ""
        self.unit = dict.value(forKey: "unit") as? String ?? ""
        self.frequency = dict.value(forKey: "frequency") as? String ?? ""
        self.status = dict.value(forKey: "status") as? String ?? ""
        self.createdOn = dict.value(forKey: "created_on") as? String ?? ""
        self.updatedOn = dict.value(forKey: "updated_on") as? String ?? ""
    }
}



struct ReminderModel {
    var id: String?
    var userId: String?
    var shapeId: String?
    var medicineId :String?
    var brandName: String?
    var medicineName:String?
    var genericName: String?
    var takenDate: String?
    var takenTime : String?
    var reminderDate: String?
    var reminderTime: String?
    var doseQuantity: String?
    var status: String?
    var unit: String?
    var notes: String?
    var createdOn: String?
    var updatedOn: String?
    
    init(dict:NSDictionary){
        self.id = dict.value(forKey: "id") as? String ?? ""
        self.userId = dict.value(forKey: "user_id") as? String ?? ""
        self.medicineId = dict.value(forKey: "medicine_id") as? String ?? ""
        self.shapeId = dict.value(forKey: "shape_id") as? String ?? ""
        self.brandName = dict.value(forKey: "brand_name") as? String ?? ""
        self.genericName = dict.value(forKey: "generic_name") as? String ?? ""
        self.medicineName = dict.value(forKey: "medicine_name") as? String ?? ""
        self.takenDate = dict.value(forKey: "taken_date") as? String ?? ""
        self.takenTime = dict.value(forKey: "taken_time") as? String ?? ""
        self.reminderTime = dict.value(forKey: "reminder_time") as? String ?? ""
        self.reminderDate = dict.value(forKey: "reminder_date") as? String ?? ""
        self.doseQuantity = dict.value(forKey: "dose_quantity") as? String ?? ""
        self.notes = dict.value(forKey: "notes") as? String ?? ""
        self.unit = dict.value(forKey: "unit") as? String ?? ""
        self.status = dict.value(forKey: "status") as? String ?? ""
        self.createdOn = dict.value(forKey: "created_on") as? String ?? ""
        self.updatedOn = dict.value(forKey: "updated_on") as? String ?? ""
    }
}



struct sortGraph {
    var key:String?
    var list:[ReminderModel] = []
    
}

struct MedicineProfileModel {
    var id: Int = 0
    var medName: String = ""

    
    init(_ dict: [String:Any]){
        self.id = dict["id"] as? Int ?? 0
        self.medName = dict["medicine_name"] as? String ?? ""
    }
    
    static func toDictionary(arrMeds: [MedicineProfileModel]) -> [[String:Any]]{
        
        var arrMedModel: [[String:Any]] = []
        for med in arrMeds{
            var param: [String:Any] = [:]
            param["id"] = med.id
            param["medicine_name"] = med.medName
            arrMedModel.append(param)
            
        }
        return arrMedModel
    }
    
    static func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = (prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : nil)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options ?? [])//dataWithJSONObject(value, options: options, error: nil) {
                if let string = String(data: data, encoding: String.Encoding.utf8) {
                    return string
                }
            }catch{
                return ""
            }
        }
        return ""
    }
}
