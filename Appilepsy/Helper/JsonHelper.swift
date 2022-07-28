//
//  JsonHelper.swift
//  Appilepsy
//
//  Created by John on 26/04/21.
//


import Foundation
class JsonHelper
{
    private static var helper:JsonHelper!

    class func share() -> JsonHelper{
           if helper == nil {
               helper = JsonHelper()
           }
           return helper
       }
    
    func jSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
}
