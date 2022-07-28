//
//  MyProfileVC.swift
//  Medilepsy
//
//  Created by John on 06/02/21.
//

import UIKit

class MyProfileVC: BaseViewController {

    @IBOutlet weak var nameTF: UITextFieldX!
    @IBOutlet weak var ageTF: UITextFieldX!
    @IBOutlet weak var genderTF: UITextFieldX!
    @IBOutlet weak var raceTF: UITextFieldX!
    @IBOutlet weak var gradeTF: UITextFieldX!
    @IBOutlet weak var phoneTF: UITextFieldX!
    @IBOutlet weak var zipTF: UITextFieldX!
    @IBOutlet weak var emailTF: UITextFieldX!
    @IBOutlet weak var careGiverTF: UITextFieldX!
    @IBOutlet weak var careGiverPhoneTF: UITextFieldX!
    @IBOutlet weak var careGiverEmailTF: UITextFieldX!
    @IBOutlet weak var liveTF: UITextFieldX!
    @IBOutlet weak var epilepsySyndromeTF: UITextFieldX!
    @IBOutlet weak var lastSeizureTF: UITextFieldX!
    @IBOutlet weak var seizureFreqTF: UITextFieldX!
    @IBOutlet weak var prescribedMedTF: UITextFieldX!
    @IBOutlet weak var med1TF: UITextFieldX!
    @IBOutlet weak var med2F: UITextFieldX!
    @IBOutlet weak var med3F: UITextFieldX!
    @IBOutlet weak var med4F: UITextFieldX!
    @IBOutlet weak var alleryTF: UITextFieldX!
    @IBOutlet weak var healthCareTF: UITextFieldX!
    @IBOutlet weak var healthCareNumberTF: UITextFieldX!
    @IBOutlet weak var healthCareEmailTF: UITextFieldX!
    @IBOutlet weak var pharmacyTF: UITextFieldX!
    @IBOutlet weak var pharmacNumberTF: UITextFieldX!
    @IBOutlet weak var emergencyTF: UITextFieldX!
    @IBOutlet weak var emergencyNumberTF: UITextFieldX!
    @IBOutlet weak var tblMedicines: DynamicSizeTableView!
    //@IBOutlet weak var lytTableheight: NSLayoutConstraint!
    
    var arrMedicines: [MedicineProfileModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMedicines.delegate = self
        self.tblMedicines.dataSource = self

        HitApi.share().getForm(view: self.view){
            (status,msg,data)in
            if status{
                self.setData(data: data)
                
            }
            else{
                let dict = ["id": 1, "medicine_name": ""] as [String : Any]
                self.arrMedicines.append(MedicineProfileModel(dict))
                //self.lytTableheight.constant = CGFloat((self.arrMedicines.count * 98) + 50)
                self.tblMedicines.reloadData()
            }
        }
    }
    @IBAction func saveData(_ sender: Any) {
        save()
    }
    

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func save(){
        var data = InterviewModel(dict: [:])
        data.name = nameTF.text!
        data.age = ageTF.text!
        data.allergiesMedications = alleryTF.text!
        data.caregiversEmail = careGiverEmailTF.text!
        data.caregiversName = careGiverTF.text!
        data.caregiversPhoneNumber = careGiverPhoneTF.text!
        data.doesSubjectLive = liveTF.text!
        data.email = emailTF.text!
        data.emergencyContactNumber = emergencyNumberTF.text!
        data.frequenciesOfSeizure = seizureFreqTF.text!
        data.gender = genderTF.text!
        data.gradeSchool = gradeTF.text!
        data.healthcareProviderEmail = healthCareEmailTF.text!
        data.healthcareProviderName = healthCareTF.text!
        data.healthcareProviderPhoneNumber = healthCareNumberTF.text!
        data.lastSeizureEvent = lastSeizureTF.text!
        data.medicine1 = med1TF.text!
        data.medicine2 = med2F.text!
        data.medicine3 = med3F.text!
        data.medicine4 = med4F.text!
        data.nameEmergencyContact = emergencyTF.text!
        data.numberOfPrescribedMedications = prescribedMedTF.text!
        data.pharmacyName = pharmacyTF.text!
        data.pharmacyPhoneNumber = pharmacNumberTF.text!
        data.phoneNumber = phoneTF.text!
        data.race = raceTF.text!
        data.typeOfEpilepsy = epilepsySyndromeTF.text!
        data.zipCode = zipTF.text!
        data.arrMedicines = self.arrMedicines
        
        
        HitApi.share().updateInterviewForm(view: self.view, data: data){
            (status,msg) in
            if status{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showAlert(msg)
            }
        }
    }
    
    func setData(data:InterviewModel)
    {
        nameTF.text =  data.name
        ageTF.text = data.age
        alleryTF.text = data.allergiesMedications
        careGiverEmailTF.text = data.caregiversEmail
        careGiverTF.text = data.caregiversName
        careGiverPhoneTF.text = data.caregiversPhoneNumber
        liveTF.text = data.doesSubjectLive
        emailTF.text = data.email
        emergencyNumberTF.text = data.emergencyContactNumber
        seizureFreqTF.text =  data.frequenciesOfSeizure
        genderTF.text = data.gender
        gradeTF.text = data.gradeSchool
        healthCareEmailTF.text = data.healthcareProviderEmail
        healthCareTF.text = data.healthcareProviderName
        healthCareNumberTF.text = data.healthcareProviderPhoneNumber
        lastSeizureTF.text = data.lastSeizureEvent
        med1TF.text = data.medicine1
        med2F.text = data.medicine2
        med3F.text = data.medicine3
        med4F.text = data.medicine4
        emergencyTF.text = data.nameEmergencyContact
        prescribedMedTF.text = data.numberOfPrescribedMedications
        pharmacyTF.text =  data.pharmacyName
        pharmacNumberTF.text =  data.pharmacyPhoneNumber
        phoneTF.text =  data.phoneNumber
        raceTF.text = data.race
        epilepsySyndromeTF.text = data.typeOfEpilepsy
        zipTF.text = data.zipCode
        let dict = ["id": 1, "medicine_name": ""] as [String : Any]
        if data.arrMedicines.isEmpty{
            arrMedicines.append(MedicineProfileModel(dict))
        }else{
            arrMedicines = data.arrMedicines
            
        }
        //lytTableheight.constant = CGFloat((arrMedicines.count * 98) + 50)
        tblMedicines.reloadData()
    }
    

    @IBAction func btnAddMore(_ sender: UIButton) {
        let dict = ["id": arrMedicines.count+1, "medicine_name": ""] as [String : Any]
        arrMedicines.append(MedicineProfileModel(dict))
        //lytTableheight.constant = CGFloat((arrMedicines.count * 98) + 50)
        tblMedicines.reloadData()
    }
}

extension MyProfileVC: UITableViewDelegate, UITableViewDataSource, MedicationDelegate{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMedicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblMedicines.dequeueReusableCell(withIdentifier: "medicineCell", for: indexPath) as! MedicationsTVC
        cell.setMedData(self.arrMedicines[indexPath.row])
        cell.delegateMed = self
        return cell
    }
    
    func onMedicineAdded(_ name: String, index: Int) {
        self.arrMedicines[index].medName = name
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrMedicines.count-1 && arrMedicines.count != 1{
            if editingStyle == .delete
            {
                arrMedicines.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
    }

}
