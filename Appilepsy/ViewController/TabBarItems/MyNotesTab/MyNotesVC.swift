//
//  MyNotesVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import KYDrawerController

class MyNotesVC: BaseViewController {

    @IBOutlet weak var noteTV :UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTV.text = AppPreferences.share.get(forkey: .note) as? String ?? ""
    }
    

    @IBAction func openMenu(_ sender: Any) {
        if let ky = self.parent?.parent as? KYDrawerController{
            ky.setDrawerState(.opened, animated: true)
        }
    }
}


extension MyNotesVC:UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView) {
        HitApi.share().updateNote(view: self.view, note: noteTV.text!){
            (status,msg) in
            if status
            {
                AppPreferences.share.commit(data: self.noteTV.text! as AnyObject, forkey: .note)
            }
        }
    }
}
