//
//  ResetPwdVC.swift
//  Stylee
//
//  Created by John on 02/02/21.
//

import UIKit

class ResetPwdVC: BaseViewController {

    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueBtn(_ sender: Any) {
        view.endEditing(true)
        if otpTF.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            toast("OTP can't be empty...")
        }
        else if pwdTF.text!.trimmingCharacters(in: .whitespaces).count < 6{
            toast("Password length should be more than 6..")
        }
        else{
            HitApi.share().resetPwd(view: self.view, email: email, password: pwdTF.text!, otp: otpTF.text!)
                {
                (status,msg) in
                if status{
                    self.toast(msg)
                    DispatchQueue.main.asyncAfter(deadline: .now()){
                        let _: LoginVC = self.open()
                    }
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
    
}
