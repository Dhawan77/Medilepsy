//
//  MainTabBar.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedIndex = 2
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            AppPreferences.share.commit(data: true as AnyObject, forkey: .isLoggedIn)
        }
        
        if AppPreferences.share.get(forkey: .timeZone) as? String != TimeZone.current.identifier{
            HitApi.share().updateTimeZone(){
                (status,msg) in
                if status{
                    
                }
            }
        }
    }

    

}
