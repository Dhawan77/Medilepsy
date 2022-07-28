//
//  AppDelegate.swift
//  Medilepsy
//
//  Created by John on 04/02/21.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?

    class func share() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        registerForNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycleo

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func changeTheme()
    {
        window?.overrideUserInterfaceStyle = .light
    }
    
    func application(_ application: UIApplication,
                        didReceiveRemoteNotification notification: [AnyHashable : Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//           if Auth.auth().canHandleNotification(notification) {
//               completionHandler(.noData)
//               
//               return
//           }
           
       }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      //  Messaging.messaging().apnsToken = deviceToken
        print("------------\(deviceToken)")
    }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
//    {
//        AppPreferences.share.commit(data: fcmToken as AnyObject, forkey: .fcmToken)
//        print("fcm ---------\(fcmToken)")
//    }
    
    func registerForNotifications(){
        if #available(iOS 10.0, *)
        {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            Messaging.messaging().delegate = self
        }
        else
        {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       // let userInfo = response.notification.request.content.userInfo as NSDictionary
       // let targetValue = userInfo.value(forKey: "catID")
     //   coordinateToSomeVC(id: "\(targetValue ?? "")")
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
        {
            AppPreferences.share.commit(data: fcmToken as AnyObject, forkey: .fcmToken)
            print("fcm ---------\(fcmToken)")
        }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
//            let dict = notification.request.content.userInfo["aps"] as! NSDictionary
//            let messageBody:String?
//            var messageTitle:String = "Alert"
//            if let alertDict = dict["alert"] as? Dictionary<String, String> {
//                messageBody = alertDict["body"]!
//                if alertDict["title"] != nil { messageTitle  = alertDict["title"]! }
//            } else {
//                messageBody = dict["alert"] as? String
//            }
       
        completionHandler([.alert, .badge, .sound])
    }
}
