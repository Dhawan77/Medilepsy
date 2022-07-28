//
//  Header.swift
//  Anamel
//
//  Created by Ashish Bhardwaj  on 27/04/18.
//

import UIKit

class Alert: NSObject {
    static func showAlertMessage(vc: BaseViewController, messageStr:String) -> Void {
        let alert = UIAlertController(title: "Medilepsy", message: messageStr, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}


extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
       }
    func getMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
       }
    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInPreviousMonth(as date: Date) -> Bool { isEqual(to: date.getPreviousMonth(), toGranularity: .month) }
    func isInPreviousYear(as date: Date) -> Bool { isEqual(to: date.getPreviousYear(), toGranularity: .year) }

    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInPreviousMonth: Bool { isInPreviousMonth(as: Date().getPreviousMonth()) }
    var isInPreviousYear: Bool { isInPreviousYear(as: Date().getPreviousYear()) }

    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }
    func years(from date: Date) -> Int {
            return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
        }
    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}
extension Date{
    
    func getFormattedDate(_ format:String = "MM/dd/yyyy") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func getFormattedDate(date:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: date) ?? Date()
    }
    
    func getYearDiffrence(dateString:String) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: getFormattedDate(date: dateString))
        let date2 = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.year], from: date1, to: date2)
        return components.value(for: .year) ?? 0

        }
    
    func getPreviousDate() -> Date {
            var components = DateComponents()
            components.day = -1
            return Calendar.current.date(byAdding: components, to:Date())!
        }
    func getPreviousMonth() -> Date {
            var components = DateComponents()
            components.month = -1
            return Calendar.current.date(byAdding: components, to:Date())!
        }
    func getPreviousYear() -> Date {
            var components = DateComponents()
            components.year = -1
            return Calendar.current.date(byAdding: components, to:Date())!
        }
    
    func getTime(_ format:String = "HH mm") -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    func getTodayDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
    func getFormationDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: self)
    }
    func getFormationMonth() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        return formatter.string(from: self)
    }
    
    func getFormationYear() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    
}
