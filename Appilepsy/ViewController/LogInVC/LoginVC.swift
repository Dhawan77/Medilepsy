//
//  LoginVC.swift
//  Medilepsy
//
//  Created by John on 04/02/21.
//

import UIKit
import KYDrawerController

class LoginVC: BaseViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signin(_ sender: Any) {
        view.endEditing(true)
  
        if !emailTF.text!.isValidEmail{
            toast("Enter valid email address..")
        }
        else if pwdTF.text!.count < 6{
            toast("Password length should be more than 6..")
        }
        else{
            HitApi.share().login(view: self.view, email: emailTF.text!, password: pwdTF.text!){
                (status,msg) in
                if status{
                    self.emailTF.text = ""
                    self.pwdTF.text = ""
                    let _ :KYDrawerController = self.open()
                }
                else{
                    self.showAlert(msg)
                }
            }
        }
    }
    
    @IBAction func visibilityBtn(_ sender: UIButton) {
        pwdTF.isSecureTextEntry = !pwdTF.isSecureTextEntry
        sender.isSelected = !sender.isSelected
    }
    @IBAction func forgotPwd(_ sender: Any) {
        emailTF.text = ""
        pwdTF.text = ""
        let _ :ForgotPwdVC = open()
    }
    
    @IBAction func signup(_ sender: Any) {
        emailTF.text = ""
        pwdTF.text = ""
        let _ :SignupVC = open()
    }
    

}
