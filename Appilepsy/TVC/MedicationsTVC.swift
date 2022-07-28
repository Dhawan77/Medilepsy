//
//  MedicationsTVC.swift
//  Appilepsy
//
//  Created by John on 22/03/21.
//

import UIKit
protocol MedicationDelegate{
    func onMedicineAdded(_ name: String, index: Int)
}

class MedicationsTVC: UITableViewCell {
    
    
    @IBOutlet weak var lblMedicine: UILabel!
    @IBOutlet weak var tfMedicineName: UITextFieldX!
    var delegateMed: MedicationDelegate?
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMedData(_ data: MedicineProfileModel){
        lblMedicine.text = "Medicine \(data.id)"
        tfMedicineName.text = data.medName
        self.index = data.id-1
    }

    @IBAction func tfMedicineNameAdded(_ sender: UITextField) {
        self.delegateMed?.onMedicineAdded(sender.text ?? "", index: index)
    }
}
