//
//  ShapeModel.swift
//  Medilepsy
//
//  Created by John on 12/02/21.
//

import Foundation

struct ShapeModel {
    var id: String?
    var medicineShape: String?
    var createdOn: String?
    var updatedOn: String?
    
    init(dict:NSDictionary){
        self.id = dict.value(forKey: "id") as? String ?? ""
        self.medicineShape = dict.value(forKey: "medicine_shape") as? String ?? ""
        self.createdOn = dict.value(forKey: "created_on") as? String ?? ""
        self.updatedOn = dict.value(forKey: "updated_on") as? String ?? ""
    }
}


struct RewardModel {
    var id: String
    var user_id: String
    var status: String
    var week1: Int
    var week2: Int
    var week3: Int
    var week4: Int
    var week5: Int
    var totalGoal:String
    var week1Goal: String
    var week2Goal: String
    var week3Goal: String
    var week4Goal: String
    var week5Goal: String
    var week1Point: String
    var week2Point: String
    var week3Point: String
    var week4Point: String
    var week5Point: String
    var week1Reward: String
    var week2Reward: String
    var week3Reward: String
    var week4Reward: String
    var week5Reward: String
    var createdOn: String
    var updatedOn: String
    
    init(dict:NSDictionary){
        self.id = dict.value(forKey: "id") as? String ?? ""
        self.user_id = dict.value(forKey: "user_id") as? String ?? ""
        self.status = dict.value(forKey: "status") as? String ?? ""
        self.week1 = dict.value(forKey: "week_1") as? Int ?? 0
        self.week2 = dict.value(forKey: "week_2") as? Int ?? 0
        self.week3 = dict.value(forKey: "week_3") as? Int ?? 0
        self.week4 = dict.value(forKey: "week_4") as? Int ?? 0
        self.week5 = dict.value(forKey: "week_5") as? Int ?? 0
        self.totalGoal = dict.value(forKey: "total_goal") as? String ?? ""
        self.week1Goal = dict.value(forKey: "week_1_goal") as? String ?? ""
        self.week2Goal = dict.value(forKey: "week_2_goal") as? String ?? ""
        self.week3Goal = dict.value(forKey: "week_3_goal") as? String ?? ""
        self.week4Goal = dict.value(forKey: "week_4_goal") as? String ?? ""
        self.week5Goal = dict.value(forKey: "week_5_goal") as? String ?? ""
        self.week1Point = dict.value(forKey: "week_1_point") as? String ?? ""
        self.week2Point = dict.value(forKey: "week_2_point") as? String ?? ""
        self.week3Point = dict.value(forKey: "week_3_point") as? String ?? ""
        self.week4Point = dict.value(forKey: "week_4_point") as? String ?? ""
        self.week5Point = dict.value(forKey: "week_5_point") as? String ?? ""
        self.week1Reward = dict.value(forKey: "week_1_reward") as? String ?? ""
        self.week2Reward = dict.value(forKey: "week_2_reward") as? String ?? ""
        self.week3Reward = dict.value(forKey: "week_3_reward") as? String ?? ""
        self.week4Reward = dict.value(forKey: "week_4_reward") as? String ?? ""
        self.week5Reward = dict.value(forKey: "week_5_reward") as? String ?? ""
        self.createdOn = dict.value(forKey: "created_on") as? String ?? ""
        self.updatedOn = dict.value(forKey: "updated_on") as? String ?? ""
    }
}
