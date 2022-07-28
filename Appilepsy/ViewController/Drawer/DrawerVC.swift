//
//  DrawerVC.swift
//  Medilepsy
//
//  Created by John on 08/02/21.
//

import UIKit
import KYDrawerController
import MessageUI
class DrawerVC:  BaseViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var reminderBtn: UIButton!
    @IBOutlet weak var dailyAdheranceBtn: UIButton!
    @IBOutlet weak var rewardBtn: UIButton!
    @IBOutlet weak var graphBtn: UIButton!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageViewX!
    override func viewDidLoad() {
        super.viewDidLoad()

       

    }
    
    func sendEmail() {
           let composeVC = MFMailComposeViewController()
           composeVC.mailComposeDelegate = self
           composeVC.setToRecipients(["support@medilepsy.com"])
           composeVC.setSubject("Feedback/Suggestion!")
           composeVC.setMessageBody("", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.parent?.parent?.present(composeVC, animated: true, completion: nil)}
    else{
    toast("Can't send email")
    
    }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        usernameLbl.text = AppPreferences.share.get(forkey: .fName) as? String ?? "User"
        let imgrUrl = AppPreferences.share.get(forkey: .userImg) as? String ?? ""
        imgrUrl.isEmpty ? userImg.image = UIImage(named: "bot") : userImg.sd_setImage(with: URL(string: Keys.IMG_BASE_URL+"\(AppPreferences.share.get(forkey: .userImg) as? String ?? "")"), placeholderImage: #imageLiteral(resourceName: "load"), options: [], context: nil)    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if AppPreferences.share.get(forkey: .theme) as? String == "light"{
            overrideUserInterfaceStyle = .light
            UIApplication.shared.statusBarStyle = .darkContent
        }
        else{
            overrideUserInterfaceStyle = .dark
            UIApplication.shared.statusBarStyle = .lightContent
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
            if AppPreferences.share.get(forkey: .isParent) as? String == "yes"{
                self.reminderBtn.isHidden = true
                self.dailyAdheranceBtn.isHidden = true
                self.rewardBtn.isHidden = true
                self.graphBtn.isHidden = true
            }
            else{
                self.reminderBtn.isHidden = false
                self.dailyAdheranceBtn.isHidden = false
                self.rewardBtn.isHidden = false
                self.graphBtn.isHidden = false
            }
        
    }
    
    
    @IBAction func changeTheme(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
             changeTheme()
            parent.setDrawerState(.closed, animated: true)
            
        }
    }
    
    @IBAction func openMedilepsy(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
                sendEmail()
                parent.setDrawerState(.closed, animated: true)
        }
    }
    @IBAction func profileBtn(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 2
                let _ : MyProfileVC = open()
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
   
    @IBAction func reminders(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 2
                let _ : ReminderVC = open()
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @IBAction func dailyAdherance(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 2
                let _ : DailyAdheranceVC = open()
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }

    @IBAction func rewards(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 2
                let _ : RewardsVC = open()
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @IBAction func chatBot(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 2
                let _ : ChatbotVC = open()
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    @IBAction func visualGraphs(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 2
                let _ : GraphTabVC = open()
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @IBAction func settings(_ sender: Any) {
        if let parent = self.parent as? KYDrawerController
        {
            if let child = parent.mainViewController as?  MainTabBar
            {
                child.selectedIndex = 4
                parent.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @IBAction func share(_ sender: Any) {
    }
    
    @IBAction func signout(_ sender: Any) {
        let theme = AppPreferences.share.get(forkey: .theme)
        let fcm = AppPreferences.share.get(forkey: .fcmToken)
        AppPreferences.share.clear()
        AppPreferences.share.commit(data: theme as AnyObject, forkey: .theme)
        AppPreferences.share.commit(data: fcm as AnyObject, forkey: .fcmToken)

        let _ : LoginVC = open()
    }
    
}
