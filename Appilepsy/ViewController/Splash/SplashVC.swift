//
//  ViewController.swift
//  Medilepsy
//
//  Created by John on 04/02/21.
//

import UIKit
import KYDrawerController
class SplashVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
        if (AppPreferences.share.get(forkey: .isLoggedIn) as? Bool ?? false)
        {
            let _: KYDrawerController = self.open()
        }
        else{
            let _: LoginVC = self.open()
        }

        }
    }
}

