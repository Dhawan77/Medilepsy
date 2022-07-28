//
//  ChatbotVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit

class ChatbotVC: BaseViewController,LinkOpen {
    func openLink(link: String) {
        let _ : WebVC = open(){
            $0.tag = "ChatBot"
            $0.link = link
        }
    }
    
    
    @IBOutlet weak var botTextView: UITextView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textLabel1: UILabel!
    
    var chatbot: ChatbotProcessor = ChatbotProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        botTextView.text = chatbot.greetUser()
        botTextView.delegate = self
        chatbot.waitForName()
        registerUserActivity()
        chatbot.delegate = self
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
    
    func registerUserActivity()
    {
        HitApi.share().registerUserActivity(view: self.view, activityType: "ChatBot", time: getUTCTime(), actual_time: getActualTime(), date: getUTCDate(), linkSting: "") { (status, msg) in
            //ffds
        }
    }
    
    func getActualTime() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "h:mm a"
        let ouptputTime = dateFormatter.string(from: Date())
        return ouptputTime
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        textLabel1.text = inputTextField.text
        inputTextField.text = ""
        botTextView.text = chatbot.analyzeString(input: textLabel1.text ?? "")
    }
    

    
 

}
extension ChatbotVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let _ : WebVC = open(){
            $0.tag = "ChatBot"
            $0.link = URL.absoluteString
        }
        return false
    }
}
