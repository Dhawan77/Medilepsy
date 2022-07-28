//
//  ForgotPwdVC.swift
//  Stylee
//
//  Created by John on 24/12/20.
//

import UIKit

class ForgotPwdVC: BaseViewController {

    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func continueBtn(_ sender: Any) {
        view.endEditing(true)
         if !emailTF.text!.isValidEmail{
            toast("Enter valid email address..")
        }
         else{
            HitApi.share().forgotPwd(view: self.view, email: emailTF.text!){
                (status,msg) in
                if status{
                    let _: ConfirmationDialogVC = self.customPresent()
                    {
                        $0.msgString = "Code has been\nsent to reset a new\npassword"
                        $0.delegateDone = self
                        $0.modalPresentationStyle = .overFullScreen
                    }
                }
                else{
                    self.showAlert(msg)
                }
            }
         }
    }
    
   
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ForgotPwdVC:DoneDelegate
{
    func onDonePress() {
        let _: ResetPwdVC = self.open(){
            $0.email = emailTF.text!
        }
    }
    
}
    
