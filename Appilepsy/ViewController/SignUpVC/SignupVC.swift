//
//  SignupVC.swift
//  Medilepsy
//
//  Created by John on 04/02/21.
//

import UIKit

class SignupVC: BaseViewController {

    @IBOutlet weak var fNameTF: UITextField!
    @IBOutlet weak var lNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var parentEmailTF: UITextField!
    @IBOutlet weak var parentEmailView: UIView!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var mobileTF: UITextField!
    var picker: UIPickerView!
    var pickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

//        showFreqPicker()
//        timeZoneTF.text = "EDT (UTC -4)"
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func parentSwitch(_ sender: UISwitch) {
        parentEmailView.isHidden = sender.isOn
    }
    
    @IBAction func visiBilityBtn(_ sender: UIButton) {
        pwdTF.isSecureTextEntry = !pwdTF.isSecureTextEntry
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func termsCondition(_ sender: Any) {
        termsLbl.isHidden = !termsLbl.isHidden
    }
    
//    func showFreqPicker()
//    {
//        picker = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 250))
//        let list = ["HST (UTC -10)","AKDT (UTC -8)","PDT, MST (UTC -7)","MDT (UTC -6)","CDT (UTC -5)","EDT (UTC -4)"]
//        pickerData = list
//        picker.delegate = self
//        picker.dataSource = self
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFreqPicker))
//        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
//        toolbar.tintColor = .systemBlue
//        timeZoneTF.inputAccessoryView = toolbar
//        timeZoneTF.inputView = picker
//        picker.reloadAllComponents()
//    }
    
//
//    @objc func cancelDatePicker(){
//           self.view.endEditing(true)
//       }
//
//    @objc func doneFreqPicker(){
//        timeZoneTF.text = pickerData[picker.selectedRow(inComponent: 0)]
//        self.view.endEditing(true)
//    }
//
    
    @IBAction func signUp(_ sender: Any) {
        view.endEditing(true)
        if fNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            toast("Enter first name")
        }
        else if lNameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            toast("Enter last name")
        }
        else if !emailTF.text!.isValidEmail{
            toast("Enter valid email address..")
        }
        else if mobileTF.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            toast("Enter mobile number")
        }
        else if pwdTF.text!.count < 6{
            toast("Password length should be more than 6..")
        }
//        else if parentEmailView.isHidden == false && !parentEmailTF.text!.isValidEmail{
//            toast("Enter valid email address for parent..")
//        }
        else{
            var isParent = "no"
            if parentEmailView.isHidden
            {
                isParent = "yes"
            }
            HitApi.share().register(view: self.view, firstName: fNameTF.text!, lastName: lNameTF.text!, isParent: isParent, parentEmail: parentEmailTF.text!, email: emailTF.text!, password: pwdTF.text!,mobile: mobileTF.text ?? ""){
                (status,msg) in
                if status{
                    self.showAlert(msg)
                    DispatchQueue.main.asyncAfter(deadline: .now()+2)
                        {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else{
                    self.showAlert(msg)
                }
            }
        }
        
    }
}
extension SignupVC : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
      }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
             return pickerData.count
         
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return pickerData[row]
          
      }
}
