//
//  AddMedReminderVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import UserNotifications
import SDWebImage

class AddMedReminderVC: BaseViewController, UITextFieldXDelegate,UITextFieldDelegate {
    func onBackPressed(_ textField: UITextFieldX) {
        filteredData = medsData.filter{($0.brandName?.contains(textField.text!) ?? false)}
        DispatchQueue.main.async {
            self.medTbl.reloadData()
        }
    }
    

    @IBOutlet weak var brandTextField: UITextFieldX!
    @IBOutlet weak var endDateTf: UITextFieldX!
    @IBOutlet weak var genericTextField: UITextField!
    @IBOutlet weak var medTblHeight: NSLayoutConstraint!
    @IBOutlet weak var doseTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var freqTF: UITextFieldX!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var medTbl: UITableView!
    @IBOutlet weak var timeTbl: DynamicSizeTableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var medImg: UIImageView!
    @IBOutlet weak var reminderDateTf: UITextFieldX!
    
    var notificationView: ReminderVC!
    var medsData = [MedicineModel]()
    var filteredData = [MedicineModel]()
    var selectedIndex = ""
    let notificationCenter = UNUserNotificationCenter.current()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegateAdd: AddReminderDelegate?
    var picker: UIPickerView!
    let datePicker = UIDatePicker()
    let enddatePicker = UIDatePicker()

    var pickerData: [[String]] = [[String]]()
    var times = [NSDictionary]()
    var index : Int?
    var reminderDate = Date()
    var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        times.append(["date":Date()])
        brandTextField.delegate = self
        timePicker.locale = NSLocale.current
        timePicker.minimumDate = Date()
        cofigureViews()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            enddatePicker.preferredDatePickerStyle = .wheels
        }
        showFreqPicker()
        getAllMeds()
        showDatePicker()
        showEndPicker()
        reminderDateTf.text = getDate(date: reminderDate)
        endDateTf.text = getDate(date: reminderDate.addingTimeInterval(86400))

    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        toolBar = UIToolbar(frame: CGRect(x: timePicker.frame.origin.x, y: timePicker.frame.origin.y, width: timePicker.frame.width, height: 40))
        timePicker.backgroundColor = UIColor(named: "theme")
        datePicker.backgroundColor = UIColor(named: "theme")
        enddatePicker.backgroundColor = UIColor(named: "theme")
    }
    
    func showTimePicker(){
        timePicker.isHidden = false
        toolBar.sizeToFit()
        toolBar.tintColor = .systemBlue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.view.addSubview(toolBar)
        toolBar.isHidden = false
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = UIColor(named: "theme")
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .systemBlue
        reminderDateTf.inputAccessoryView = toolbar
        reminderDateTf.inputView = datePicker
        
    
}
    
    func showEndPicker(){
        enddatePicker.datePickerMode = .date
        enddatePicker.minimumDate = Date().addingTimeInterval(86400)
        enddatePicker.backgroundColor = UIColor(named: "theme")
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDateDone));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .systemBlue
        endDateTf.inputAccessoryView = toolbar
        endDateTf.inputView = enddatePicker
        
    
}
    
    func getAllMeds()
    {
        HitApi.share().getAllMeds(view: self.view)
            {
            (status,msg,data) in
            self.medsData = data
        }
    }
    
    func showFreqPicker()
    {
        picker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 250))
        var list = [String]()
        var list2 = [String]()
        for data in 1...24
        {
            list.append("\(data)")
        }
        list2.append("times a day")
        pickerData = [list,list2]
        picker.delegate = self
        picker.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFreqPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .systemBlue
        freqTF.inputAccessoryView = toolbar
        freqTF.inputView = picker
        picker.reloadAllComponents()
    }
    
    @objc func cancelDatePicker(){
           self.view.endEditing(true)
        timePicker.isHidden = true
        self.view.willRemoveSubview(toolBar)
        toolBar.isHidden = true
       }
    
    @objc func doneTimePicker(){
        times[index ?? 0] = ["date":timePicker.date]
        timePicker.isHidden = true
        self.view.willRemoveSubview(toolBar)
        toolBar.isHidden = true
        timeTbl.reloadData()
    }
    
    @objc func donedatePicker(){
        if enddatePicker.date > datePicker.date{
        }
        else{
            endDateTf.text = getDate(date: datePicker.date.addingTimeInterval(86400))
        }
        reminderDate = datePicker.date
        enddatePicker.minimumDate = reminderDate.addingTimeInterval(86400)
        reminderDateTf.text = getDate(date: reminderDate)
        if datePicker.date.isInToday{
            timePicker.minimumDate = datePicker.date
            times.removeAll()
            times.append(["date":Date()])
            timeTbl.reloadData()
        }
        else{
        timePicker.minimumDate = nil
        }
        self.view.endEditing(true)
       }
    
    @objc func endDateDone(){
        endDateTf.text = getDate(date: enddatePicker.date)
        view.endEditing(true)
    }
    
    func converFormat(str:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from: str)
        let strDate =  date ?? Date()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd-MM-yyyy"
        let ouptputTime = dateFormatter2.string(from: strDate)
        return ouptputTime
    }
    
       
    @objc func doneFreqPicker(){
        times.removeAll()
        let count = picker.selectedRow(inComponent: 0)+1
        for index in 1...count{
            times.append(["date":Date().addingTimeInterval(TimeInterval(index*200))])
            timeTbl.reloadData()
        }
        if picker.selectedRow(inComponent: 0) == 0{
            freqTF.text = "Once a day"
        }
        else{
            freqTF.text = "\(picker.selectedRow(inComponent: 0)+1) times a day"}
           self.view.endEditing(true)
       }
       
  
    
    @IBAction func minusBtn(_ sender: UIButton) {
        if (Int(countLbl.text!) ?? 0) == 1
        {
            
        }
        else{
            countLbl.text = "\((Int(countLbl.text!) ?? 0)-1)"}
    }
    
    @IBAction func addBtn(_ sender: UIButton) {
        countLbl.text = "\((Int(countLbl.text!) ?? 0)+1)"
    }
    
    func textFieldCheck() -> Bool {
        return brandTextField.text != "" || doseTextField.text != ""
    }
    
    func checkName() {
        let text = brandTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func checkDate() {
        if NSDate().earlierDate(timePicker.date) == timePicker.date {
            saveButton.isEnabled = false
        }
    }
    
    private func cofigureViews() {
        saveButton.layer.cornerRadius = 8.0
        cancelButton.layer.cornerRadius = 8.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        if (genericTextField.text == "") {
            showErrorMsg(msg: "Please ensure your medicine name is correct.")
        }
        
        if (doseTextField.text == "") {
            showErrorMsg(msg: "Please ensure your dosage strength is correct.")
        }
        var time = ""
        for data in self.times
        {
            if let date = data.value(forKey: "date") as? Date{
                if time.isEmpty{
                    time = getTime(date: date)
                }
                else{
                    time = time+","+getTime(date: date)
                }
            }
        }
        let alert = UIAlertController(title: "Are you sure?", message: "A reminder for taking \(countLbl.text!) \(brandTextField.text!) \(genericTextField.text!) (\(doseTextField.text!)) at \(time) will be set.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { [self] action in
            var itemArr:[Any] = []
            for data in self.times
            {
                if let date = data.value(forKey: "date") as? Date{
                    let itemDict:[String:Any] = ["time":date.currentTimeEST()]
                    itemArr.append(itemDict)}
            }
            let a = JsonHelper.share().jSONStringify(value: itemArr as AnyObject, prettyPrinted: false)

            HitApi.share().addReminder(view: self.view, brandName: self.brandTextField.text!, genericName: self.genericTextField.text!, doseQuantity: self.countLbl.text!, reminderTime: a as AnyObject, endDate: converFormat(str: endDateTf.text!) as AnyObject, reminderDate: converFormat(str: reminderDateTf.text!), note: self.notesTextField.text!, unit: self.doseTextField.text!, shapeId: self.selectedIndex)
                {
                (status,msg) in
                if status{
                 
                    self.delegateAdd?.onAdded()
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    self.showAlert(msg)
                }
            }
            
            
        })

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        if ( UIDevice.current.userInterfaceIdiom == .pad )
        {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = saveButton
                currentPopoverpresentioncontroller.sourceRect = saveButton.bounds
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getDate(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }
  
    override func viewWillLayoutSubviews() {
        if (self.medTbl.contentSize.height - 80) > self.view.frame.height{
            medTblHeight.constant = self.view.frame.height-80
        }
        else{
        medTblHeight.constant = self.medTbl.contentSize.height+40
        }}
    
    func showErrorMsg(msg:String)
    {
        let errorAlert = UIAlertController(title: "Error", message: msg, preferredStyle: .actionSheet)
        errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        if ( UIDevice.current.userInterfaceIdiom == .pad ){
            if let currentPopoverpresentioncontroller = errorAlert.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = saveButton
                currentPopoverpresentioncontroller.sourceRect = saveButton.bounds
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(errorAlert, animated: true, completion: nil)
            }
        }else{
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    func getTime(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }

    func getTime2(sender:UIDatePicker) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ouptputTime = dateFormatter.string(from: sender.date)
        return ouptputTime
    }
    func getUTCTime(sender:UIDatePicker) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ouptputTime = dateFormatter.string(from: sender.date)
        return ouptputTime
    }
   
    @IBAction func brandNameEditing(_ sender: UITextField) {
        filteredData = medsData.filter{($0.brandName?.contains(sender.text!) ?? false)}
        DispatchQueue.main.async {
            self.medTbl.reloadData()
        }
    }
    
  

    
}

extension AddMedReminderVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
             return pickerData[component].count
         
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return pickerData[component][row]
          
      }
}


extension AddMedReminderVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timeTbl{
            return times.count
        }
        else{
        if filteredData.count > 0{
            tableView.isHidden = false
        }
        else{
            tableView.isHidden = true
        }
            return filteredData.count}
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == medTbl{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedTVC") as! MedTVC
        cell.nameLabel.text = "\(filteredData[indexPath.row].brandName ?? "")/\(filteredData[indexPath.row].genericName ?? "")(\(filteredData[indexPath.row].unit ?? ""))"
        cell.medImg.sd_setImage(with: URL(string: Keys.IMG_BASE_URL+(filteredData[indexPath.row].img ?? "")), completed: nil)
            return cell}
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerTVC") as! TimePickerTVC
            let date = times[indexPath.row] as NSDictionary
            if let time = date.value(forKey: "date") as? Date{
                cell.timeLbl.text = time.currentTime()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == medTbl{
        brandTextField.text = filteredData[indexPath.row].brandName ?? ""
        genericTextField.text = filteredData[indexPath.row].genericName ?? ""
        doseTextField.text = filteredData[indexPath.row].unit ?? ""
        selectedIndex = filteredData[indexPath.row].img!
            if let img = URL(string: Keys.IMG_BASE_URL+(filteredData[indexPath.row].img ?? "")){
                medImg.sd_setImage(with: img, completed: nil)
                medImg.isHidden = false
            }
        tableView.isHidden = true
            view.endEditing(true)}
        else{
            index = indexPath.row
            showTimePicker()
        }
    }
    
    
    

    
    
}


protocol AddReminderDelegate {
    func onAdded()

}


extension Date{
    func checkTimeInterval(toDate:Date) -> Bool {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = toDate
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 1 {
            return true
        }
        
        return false
    }
    
    func currentTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let ouptputTime = dateFormatter.string(from: self)
        return ouptputTime
    }
    
    
    func currentTimeEST() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ouptputTime = dateFormatter.string(from: self)
        return ouptputTime
    }
   
}
