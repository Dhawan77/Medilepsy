

import Foundation
import UIKit
import AVFoundation
import RxSwift
import NVActivityIndicatorView
import KYDrawerController
class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK: Userdefined Variables
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    fileprivate var maskView : UIView!
    fileprivate var indicatorView : NVActivityIndicatorView!
    
//    internal  var disposeBag = DisposeBag()
    let adView = UIView()
    
    var backView = UIView()
    var navView = UIView()

    //MARK: Lifecycles
    override func viewDidLoad() {
        setNavBar()
        showNavBar()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.delegate = self
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
    }
    
    func changeTheme(){
        if AppPreferences.share.get(forkey: .theme) as? String == "light"{
            AppPreferences.share.commit(data: "dark" as AnyObject, forkey: .theme)
            viewWillAppear(true)
        }
        else{
            AppPreferences.share.commit(data: "light" as AnyObject, forkey: .theme)
            viewWillAppear(true)
         }
    }
    

    override func viewDidDisappear(_ animated: Bool) {
      //  self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.navigationController?.children.count)! > 1
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func hideNavBar(){
        navigationController?.navigationBar.isHidden = true
    }
    
    func openDrawer()
    {
        
    }

    func showProgress(){
           if self.maskView == nil{
               maskView = UIView()
               maskView.frame = view.bounds
               maskView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
           }
           indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                 indicatorView.center = view.center
                 indicatorView.type = .ballSpinFadeLoader
           self.maskView.addSubview(indicatorView)
           view.addSubview(maskView)
        if AppPreferences.share.get(forkey: .theme) as? String == "light"{
            indicatorView.color = UIColor.black}
        else{
            indicatorView.color = UIColor.white
        }
           indicatorView.startAnimating()
       }
       
        func hideProgress(){
          if self.indicatorView != nil{
               self.indicatorView.removeFromSuperview()
               indicatorView.stopAnimating()
           }
           if maskView != nil{
               self.maskView.removeFromSuperview()
           }
       }
    
    
    func showNavBar(){
        navigationItem.title = nil
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }

    func setNavBar(){
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 8

        let btnBack = UIButton()
        let barButton = UIBarButtonItem(customView: btnBack)
        btnBack.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        btnBack.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        btnBack.contentMode = .scaleAspectFit
        
        btnBack.contentHorizontalAlignment = .leading
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action: #selector(popVC(_:)), for: .touchUpInside)

        let lblText = UILabel()
        let lblBarItem = UIBarButtonItem(customView: lblText)
        lblText.text =   self.title
        lblText.font = UIFont(name: "ProximaNova-Bold", size: 25.0)
        lblText.textColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.leftBarButtonItems = [barButton,space,lblBarItem]
    }

    @objc func popVC(_ barButton: UIBarButtonItem){
        
        navigationController?.popViewController(animated: true)
    
            self.dismiss(animated: true, completion: nil)
    }
    
    

   

    func toast(_ message:String){
        ToastView.shared.short(self.view, txt_msg: message)
    }

    func getJoinedString(arr: [String])-> String{
        if arr.count == 1{
            return arr[0]
        }else if arr.count == 2{
            return arr.joined(separator: "and")
        }else if arr.count > 2{
            let lastElement = arr.last ?? ""
            var arrStr = arr
            arrStr.removeLast()
            let str = arrStr.joined(separator: ", ")
            let arr = [str, lastElement]
            return arr.joined(separator: " and ")
        }else{
            return ""
        }
    }

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func showAlertWithOkAction(message: String, completion:@escaping()->()){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        present(alertController, animated: true, completion: nil)
    }

    func  getAttributedString(string1: String,string2: String) -> NSMutableAttributedString{
        let attrs1 = [NSAttributedString.Key.font: UIFont(name: "System-Regular", size: 15), NSAttributedString.Key.foregroundColor: UIColor.black]
        let attrs2 = [NSAttributedString.Key.font: UIFont(name: "System-Regular", size: 15), NSAttributedString.Key.foregroundColor: UIColor(named: "appBlack")]

        let str1 = NSAttributedString(string: string1, attributes: attrs1 as [NSAttributedString.Key : Any])

        let str2 = NSAttributedString(string: " \(string2)", attributes: attrs2 as [NSAttributedString.Key : Any])

        let getText = NSMutableAttributedString()

        getText.append(str1)
        getText.append(str2)
        return getText
    }
    
    //MARK:- Transparent Back View
    func showBackView(){
      

            DispatchQueue.main.async {
//                let view = self.delegate.window?.rootViewController?.view ?? self.view
//                self.backView = UIView(frame: view!.frame)
//                    self.backView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
//                view!.addSubview(self.backView)
                    
                    let navVw = self.navigationController?.view
                    self.navView = UIView(frame: navVw!.frame)
                    self.navView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
                    navVw?.addSubview(self.navView)
                }

            }

    func hideBackView(){
        DispatchQueue.main.async {
            self.backView.removeFromSuperview()
            self.navView.removeFromSuperview()
        }
    }
    
    func close() {
      let transition = CATransition()
      transition.duration = 0.5
      transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
      transition.type = CATransitionType.fade
      transition.subtype = CATransitionSubtype.fromBottom
      navigationController?.view.layer.add(transition, forKey:kCATransition)
      let _ = navigationController?.popViewController(animated: false)
    }
}

extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }

    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)

        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)

        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)

        default:
            return viewController
        }
    }
}
extension BaseViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    func presentPickerSelector(){

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        let alert = UIAlertController(title: "Select image from", message: nil, preferredStyle:    UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (handler) in
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            self.present(picker, animated: true, completion: nil)
        }

        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (handler) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (handler) in

        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    func getColorsList() -> [UIColor]{
        let colors: [UIColor] = [UIColor.black, UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.darkGray, UIColor.gray, UIColor.green, UIColor.lightGray,UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.red, UIColor.white, UIColor.yellow, UIColor.systemTeal, UIColor.systemPink, UIColor.systemPink]
        return colors
    }
}



