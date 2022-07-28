//
//  WebVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import WebKit

class WebVC: BaseViewController,WKNavigationDelegate {
    var tag = ""
    var link = ""
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
       
        titleLbl.text = tag
        loadWebView()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
   
    func loadWebView()
    {
        showProgress()
        registerUserActivity()
        let url = URL(string: link)
        webView.load(URLRequest(url: url!))
        DispatchQueue.main.asyncAfter(deadline: .now()+10){
            self.hideProgress()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgress()
    }
    
    func getUTCTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }
    
    func getUTCDate() -> String
    {
        let dateFormatter = DateFormatter()
      //  dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }
    
    func getActualTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "h:mm a"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }
    
    func registerUserActivity()
    {
        var a = ""
        if tag == "ChatBot"{
            a = link
        }
        HitApi.share().registerUserActivity(view: self.view, activityType: tag.trimmingCharacters(in: .whitespaces), time: getUTCTime(), actual_time: getActualTime(), date: getUTCDate(), linkSting: a) { (status, msg) in
            
        }
    }
    
}
