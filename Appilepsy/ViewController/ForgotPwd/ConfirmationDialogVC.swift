//
//  ConfirmationDialogVC.swift
//  Stylee
//
//  Created by John on 24/12/20.
//

import UIKit

class ConfirmationDialogVC: BaseViewController {

    @IBOutlet weak var msgText: UILabel!
    var msgString = ""
    var delegateDone: DoneDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        msgText.text = msgString
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegateDone?.onDonePress()
    }
   

}
protocol DoneDelegate {
    func onDonePress()

}
