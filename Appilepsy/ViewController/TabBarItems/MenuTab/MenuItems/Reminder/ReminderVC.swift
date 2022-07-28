//
//  ReminderVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit

class ReminderVC: BaseViewController,AddReminderDelegate {
   
    
    @IBOutlet weak var reminderTbl: UITableView!
    @IBOutlet weak var nodataLbl: UILabel!
    @IBOutlet weak var greetText: UILabel!
    var reminders = [ReminderModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
         getReminders()
        greetText.text = "Good \(check())!\n\(AppPreferences.share.get(forkey: .fName) as? String ?? "")\n\nHere's the reminders for the medicines that needs to be taken"
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        greetText.text = "Good \(check())!\n\(AppPreferences.share.get(forkey: .fName) as? String ?? "")\n\nHere's the reminders for the medicines that needs to be taken"
    }
    
    func getReminders()
    {
        self.reminders.removeAll()
        HitApi.share().getReminders(view: self.view)
            {
            (status,msg,data) in
            if status
            {
                self.reminders = data.filter{$0.status == "1"}
                self.reminders = self.reminders.filter{$0.takenTime != "Missed"}
                self.reminders = self.reminders.filter{$0.reminderDate == self.getTodayDate()}

                if self.reminders.count < 1{
                    self.nodataLbl.isHidden = false
                }
                else{
                    self.nodataLbl.isHidden = true
                }
              self.reminderTbl.reloadData()
            }
            else
            {
                self.nodataLbl.isHidden = false
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addReminder(_ sender: Any) {
        if let isParent = AppPreferences.share.get(forkey: .isParent) as? String{
            if isParent == "yes"{
              showAlert("Caregiver can't add reminder !!")
            }
            else{
                let _ : AddMedReminderVC = customPresent()
                {
                    $0.delegateAdd = self
                }
            }
        }
        
    }
    
    func check() -> String {
      // let hour = Calendar.current.component(.hour, from: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let ouptputTime = dateFormatter.string(from: Date())
        let hour = Int(ouptputTime) ?? 0
        switch hour {
        case 0..<12 : return "Morning"
        case 12 : return "Noon"
        case 13..<17 : return "Afternoon"
        case 17..<24 : return "Evening"
        default: return "Morning"
        }
    }
    
    func onAdded() {
        getReminders()
    }
    
    func showPopup() {
        let popupView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.width))
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "great")
        backgroundImage.tintColor = UIColor(named: "textColor")!
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFit
        popupView.insertSubview(backgroundImage, at: 0)
        popupView.center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        popupView.alpha = 1
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)

        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            popupView.transform = .identity
        })
        UIView.animate(withDuration: 0.3, delay: 2.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            popupView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
        }) { (success) in
            popupView.removeFromSuperview()
        }
    }
    
    func getTodayDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }
    func getCurrentTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }
    
    func get24CurrentTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }

    func sdsd(string:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ouptput = dateFormatter.date(from: string) ?? Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "hh:mm a"
        let ouptputTime = dateFormatter2.string(from: ouptput)
        return ouptputTime
    }
    
}

extension ReminderVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTVC") as! ReminderTVC
        let data = reminders[indexPath.row]
        cell.brandNameLbl.text = (data.brandName ?? "")+" "+(data.genericName ?? "")
        cell.doseCountLbl.text = data.doseQuantity
        cell.doseLbl.text = data.unit
        cell.timeLbl.text = sdsd(string: data.reminderTime ?? "") 
        cell.takeBtn.tag = indexPath.row
        if data.takenDate == getTodayDate(){
            cell.checkedImg.isHighlighted = true
            cell.takeBtn .isHidden = true
        }
        else
        {
            cell.takeBtn .isHidden = false
            cell.checkedImg.isHighlighted = false
            cell.takeBtn.addTarget(self, action: #selector(takeMed(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            HitApi.share().deleteReminder(view: self.view, id: reminders[indexPath.row].id ?? ""){
                (status,msg) in
                if status
                {
                    self.reminders.remove(at: indexPath.row)
                    if self.reminders.count < 1{
                        self.reminderTbl.isHidden = true
                    }
                    else{
                        self.reminderTbl.isHidden = false
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else
                {
                    self.showAlert(msg)
                }
            }
     
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

          UIView.animate(
              withDuration: 0.5,
              delay: 0.05 * Double(indexPath.row),
              options: [.transitionFlipFromTop],
              animations: {
                  cell.transform = CGAffineTransform(translationX: 0, y: 0)
          })
      }
    
    func strToDate(str:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: str)
        return date ?? Date()
    }
    
    
    @objc func takeMed(sender:UIButton)
    {
        if let isParent = AppPreferences.share.get(forkey: .isParent) as? String{
            if isParent == "yes"{
              showAlert("Caregiver can't mark medicine taken !!")
            }
            else{
        let remindTime = strToDate(str: reminders[sender.tag].reminderTime ?? "")
        let currentTime = strToDate(str: get24CurrentTime())
       
        let is2HrEarly = currentTime.checkTimeInterval(toDate: remindTime)
        if is2HrEarly
        {
            //addLocalNotification()
                HitApi.share().updateCaregiver(view: self.view, reminderId: reminders[sender.tag].id ?? ""){
                (status,msg) in
                }
            
        }
        else{
            HitApi.share().takeMedicine(view: self.view, medID: reminders[sender.tag].id ?? "", takenDate: getTodayDate(),medName: reminders[sender.tag].brandName ?? "",genricName: reminders[sender.tag].genericName ?? "", time: getCurrentTime()){
            (status,msg) in
            if status{
                self.showPopup()
                self.getReminders()
            }
            else{
                self.showAlert(msg)
                self.getReminders()
            }
        }
        }}}}
    
    
    
    func addLocalNotification()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests()
        {
            (data) in
        let content = UNMutableNotificationContent()
        content.title = "Alert!!"
            content.subtitle = "Hi, it’s a bit too early to take your medicine."
            content.categoryIdentifier = "alarm"
           content.body = "You’ll receive a reminder when it’s due. Thanks!"
            content.sound = .default//UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "shaker.caf"))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
            if !data.contains(request)
            {
                UNUserNotificationCenter.current().add(request)}
        }
    }
    
}
