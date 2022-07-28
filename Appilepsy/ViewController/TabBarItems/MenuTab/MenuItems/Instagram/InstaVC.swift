//
//  InstaVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit

class InstaVC: BaseViewController {
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    @IBOutlet weak var cloudsImageViewLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateClouds()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func animateClouds() {
        cloudsImageViewLeadingConstraint.constant = 0
        cloudsImageView.layer.removeAllAnimations()
        view.layoutIfNeeded()
        let distance = view.bounds.width - cloudsImageView.bounds.width
        self.cloudsImageViewLeadingConstraint.constant = distance
        UIView.animate(withDuration: 15, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    @IBAction func instagramPressed(_ sender: Any) {
        let _ : WebVC = open(){
            $0.tag = Keys.INSTAGRAM
            $0.link = Keys.INSTA_LINK
        }
    }

}
