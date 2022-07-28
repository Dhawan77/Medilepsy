//
//  SettingsVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import KYDrawerController

class SettingsVC: BaseViewController {

    @IBOutlet weak var careGiverView: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var fnameTF: UITextField!
    @IBOutlet weak var lnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var parentTF: UITextField!
    @IBOutlet weak var parentSwitch: UISwitch!
    var isImage = false
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isImage{isImage = false}
        else{
        fnameTF.text = AppPreferences.share.get(forkey: .fName) as? String ?? ""
        lnameTF.text = AppPreferences.share.get(forkey: .lName) as? String ?? ""
        emailTF.text = AppPreferences.share.get(forkey: .userEmail) as? String ?? ""
            phoneTF.text = AppPreferences.share.get(forkey: .phone) as? String ?? ""
        nickNameTF.text = AppPreferences.share.get(forkey: .nickName) as? String ?? ""
        parentTF.text = AppPreferences.share.get(forkey: .parentEmail) as? String ?? ""
        let imgrUrl = AppPreferences.share.get(forkey: .userImg) as? String ?? ""
        imgrUrl.isEmpty ? userImg.image = UIImage(named: "bot") : userImg.sd_setImage(with: URL(string: Keys.IMG_BASE_URL+"\(AppPreferences.share.get(forkey: .userImg) as? String ?? "")"), placeholderImage: #imageLiteral(resourceName: "load"), options: [], context: nil)
        if (AppPreferences.share.get(forkey: .isParent) as? String ?? "") == "yes"
        {
            parentSwitch.isOn = true
            careGiverView.isHidden = true
        }
        else
        {
            parentSwitch.isOn = false
            careGiverView.isHidden = false
        }}
    }
    
  
    
    @IBAction func openPicker(_ sender: Any) {
        presentPickerSelector()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let ky = self.parent?.parent as? KYDrawerController{
            ky.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        view.endEditing(true)
        if fnameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            toast("Enter first name")
        }
        else if lnameTF.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            toast("Enter last name")
        }
        else if !emailTF.text!.isValidEmail{
            toast("Enter valid email address..")
        }
//        else if careGiverView.isHidden == false && !parentTF.text!.isValidEmail{
//            toast("Enter valid email address for parent..")
//        }
        else{
        var isParent = "no"
        if careGiverView.isHidden
        {
            isParent = "yes"
        }
            showProgress()
            HitApi.share().updateProfile(firstName: fnameTF.text!, lastName: lnameTF.text!, isParent: isParent, parentEmail: parentTF.text!, nickName: nickNameTF.text!, mobile: phoneTF.text!, imageData: userImg.image!)
            {
            (msg,status) in
            if status{
            
            }
            self.showAlert(msg)
            self.hideProgress()
        }}
    }
    
    @IBAction func careGiverSwitch(_ sender: UISwitch) {
        careGiverView.isHidden = sender.isOn
    }
}


extension SettingsVC{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originalImage
        }
        userImg.image = selectedImage
        isImage = true
        if selectedImage != nil{
            let data = selectedImage?.jpegData(compressionQuality: 0.5) ?? Data()
            if data.count > 20 * (1000 * 1000){
                self.toast("This file is too large to upload. The maximum supported file size is: 20 MB")
            }else{
                
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

