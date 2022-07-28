//
//  SurveyVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import WebKit
import KYDrawerController

class SurveyVC: BaseViewController,WKNavigationDelegate {

    @IBOutlet weak var surveyWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        surveyWebView.navigationDelegate = self
        showProgress()
        let url = URL(string: Keys.SURVEY_LINK)
        surveyWebView.load(URLRequest(url: url!))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgress()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let ky = self.parent?.parent as? KYDrawerController{
            ky.setDrawerState(.opened, animated: true)
        }
    }

}
