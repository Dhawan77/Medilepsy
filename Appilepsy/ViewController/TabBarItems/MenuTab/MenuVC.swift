//
//  MenuVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import KYDrawerController

class MenuVC: BaseViewController {

    @IBOutlet weak var menuCollection: UICollectionView!
    var menuItems = [TutorialModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
   }
    
    
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
            self.menuItems = Keys.PARENT_MENU_ITEMS
        }
        else{
            self.menuItems = Keys.MENU_ITEMS
        }
        self.menuCollection.reloadData()
    }
    
    
    @IBAction func openMenu(_ sender: Any) {
        if let ky = self.parent?.parent as? KYDrawerController{
            ky.setDrawerState(.opened, animated: true)
        }
    }
}


extension MenuVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCVC", for: indexPath) as! TutorialCVC
        cell.tutorialMsg.text = menuItems[indexPath.row].msg
        cell.tutorialImg.image = menuItems[indexPath.row].img
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y:0)
         
         UIView.animate(
             withDuration: 0.5,
             delay: 0.05 * Double(indexPath.row),
             options: [.curveEaseInOut],
             animations: {
                 cell.transform = CGAffineTransform(translationX: 0, y: 0)
         })
     }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch  menuItems[indexPath.row].msg {
        case Keys.MY_PROFILE:
            let _ :MyProfileVC = open()
        case Keys.REMINDERS:
            let _ :ReminderVC = open()
        case Keys.REWARDS:
            let _ :RewardsVC = open()
        case Keys.DAILY_ADHE:
            let _ :DailyAdheranceVC = open()
        case Keys.GRAPH:
            let _ :GraphTabVC = open()
        case Keys.CHATBOT:
            let _ :ChatbotVC = open()
        case Keys.INSTA:
            let _ :InstaVC = open()
        case Keys.MEDI_WEB:
            let _ : WebVC = open(){
                $0.tag = Keys.MEDILEPSY
                $0.link = Keys.MEDILEPSY_LINK
            }
        default:
            //default
            break
        }
    }
    
}
