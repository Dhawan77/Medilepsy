//
//  ReminderTVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit

class ReminderTVC: UITableViewCell {

    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var doseCountLbl: UILabel!
    @IBOutlet weak var doseLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var checkedImg: UIImageView!
    @IBOutlet weak var takeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
