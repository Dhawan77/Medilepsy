//
//  RewardsVC.swift
//  Medilepsy
//
//  Created by John on 06/02/21.
//

import UIKit

class RewardsVC: BaseViewController {

    @IBOutlet weak var parentView: UIViewX!
    @IBOutlet weak var week1GoalTF: UITextFieldX!
    @IBOutlet weak var week2GoalTF: UITextFieldX!
    @IBOutlet weak var week3GoalTF: UITextFieldX!
    @IBOutlet weak var week4GoalTF: UITextFieldX!
    @IBOutlet weak var week5GoalTF: UITextFieldX!
    @IBOutlet weak var week1Lbl: UILabel!
    @IBOutlet weak var week2Lbl: UILabel!
    @IBOutlet weak var week3Lbl: UILabel!
    @IBOutlet weak var week4Lbl: UILabel!
    @IBOutlet weak var week5Lbl: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var signTF: UITextFieldX!
    @IBOutlet weak var rewardCaregiverTF: UITextFieldX!
    @IBOutlet weak var reward1TF: UITextField!
    @IBOutlet weak var reward2TF: UITextField!
    @IBOutlet weak var reward3TF: UITextField!
    @IBOutlet weak var reward4TF: UITextField!
    @IBOutlet weak var reward5TF: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        week1GoalTF.delegate = self
        week2GoalTF.delegate = self
        week3GoalTF.delegate = self
        week4GoalTF.delegate = self
        week5GoalTF.delegate = self

        rewardCaregiverTF.text = AppPreferences.share.get(forkey: .rewardCaregiver) as? String ?? ""
        signTF.text = AppPreferences.share.get(forkey: .rewardSign) as? String ?? ""
        setData()
    }
    
    
    func setData()
    {
        HitApi.share().getRewardData(view: self.view){
            (status,msg,data) in
            if status{
                data.week1Goal.isEmpty ? (self.week1GoalTF.text = "") : (self.week1GoalTF.text = "\(data.week1Goal)")
                data.week2Goal.isEmpty ? (self.week2GoalTF.text = "") : (self.week2GoalTF.text = "\(data.week2Goal)")
                data.week3Goal.isEmpty ? (self.week3GoalTF.text = "") : (self.week3GoalTF.text = "\(data.week3Goal)")
                data.week4Goal.isEmpty ? (self.week4GoalTF.text = "") : (self.week4GoalTF.text = "\(data.week4Goal)")
                data.week5Goal.isEmpty ? (self.week5GoalTF.text = "") : (self.week5GoalTF.text = "\(data.week5Goal)")
                self.reward1TF.text = data.week1Reward
                self.reward2TF.text = data.week2Reward
                self.reward3TF.text = data.week3Reward
                self.reward4TF.text = data.week4Reward
                self.reward5TF.text = data.week5Reward
                ((Int(data.week1Point)) ?? 0) == 0 ? (self.week1Lbl.text = "") : (self.week1Lbl.text = "\((Int(data.week1Point)) ?? 0)")
                ((Int(data.week2Point)) ?? 0) == 0 ? (self.week2Lbl.text = "") : (self.week2Lbl.text = "\((Int(data.week2Point)) ?? 0)")
                ((Int(data.week3Point)) ?? 0) == 0 ? (self.week3Lbl.text = "") : (self.week3Lbl.text = "\((Int(data.week3Point)) ?? 0)")
                ((Int(data.week4Point)) ?? 0) == 0 ? (self.week4Lbl.text = "") : (self.week4Lbl.text = "\((Int(data.week4Point)) ?? 0)")
                ((Int(data.week5Point)) ?? 0) == 0 ? (self.week5Lbl.text = "") : (self.week5Lbl.text = "\((Int(data.week5Point)) ?? 0)")

                switch self.checkDate() {
                case 1:
                    self.totalPoints.text = "\((Int(data.week1Point)) ?? 0)"
                case 2:
                    self.totalPoints.text = "\((Int(data.week2Point)) ?? 0)"
                case 3:
                    self.totalPoints.text = "\((Int(data.week3Point)) ?? 0)"
                case 4:
                    self.totalPoints.text = "\((Int(data.week4Point)) ?? 0)"
                case 5:
                    self.totalPoints.text = "\((Int(data.week5Point)) ?? 0)"
                case 6:
                    self.totalPoints.text = "\((Int(data.week5Point)) ?? 0)"
                default:
                    self.totalPoints.text = "\(0)"
                }
            }
        }
    }
    
    func checkDate() -> Int {
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let date = Int(dateFormatter.string(from: Date())) ?? 0
        
        switch date {
        case 0...7 : return 1
        case 7...14 : return 2
        case 15...21 : return 3
        case 22...28 : return 4
        default: return 5
        }
    }
    

    @IBAction func goBack(_ sender: Any) {
        HitApi.share().setRewardGoal(view: self.view, week1Goal: week1GoalTF.text!.replacingOccurrences(of: "%", with: ""), week2Goal: week2GoalTF.text!.replacingOccurrences(of: "%", with: ""), week3Goal: week3GoalTF.text!.replacingOccurrences(of: "%", with: ""), week4Goal: week4GoalTF.text!.replacingOccurrences(of: "%", with: ""),week5Goal: week5GoalTF.text!.replacingOccurrences(of: "%", with: ""),week1Reward: reward1TF.text!,week2Reward: reward2TF.text!,week3Reward: reward3TF.text!,week4Reward: reward4TF.text!,week5Reward: reward5TF.text!){
            (status,msg) in
        }
        
        AppPreferences.share.commit(data: signTF.text! as AnyObject, forkey: .rewardSign)
        AppPreferences.share.commit(data: rewardCaregiverTF.text! as AnyObject, forkey: .rewardCaregiver)
        navigationController?.popViewController(animated: true)
    }
    
}


extension RewardsVC:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        HitApi.share().setRewardGoal(view: self.view, week1Goal: week1GoalTF.text!.replacingOccurrences(of: "%", with: ""), week2Goal: week2GoalTF.text!.replacingOccurrences(of: "%", with: ""), week3Goal: week3GoalTF.text!.replacingOccurrences(of: "%", with: ""), week4Goal: week4GoalTF.text!.replacingOccurrences(of: "%", with: ""),week5Goal: week5GoalTF.text!.replacingOccurrences(of: "%", with: ""),week1Reward: reward1TF.text!,week2Reward: reward2TF.text!,week3Reward: reward3TF.text!,week4Reward: reward4TF.text!,week5Reward: reward5TF.text!){
            (status,msg) in
            if status{
                self.setData()
            }
        }
    }
    
}
