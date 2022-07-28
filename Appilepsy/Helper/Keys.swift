//
//  Keys.swift
//  Tgroops
//
//  Created by SachTech on 5/29/19.
//  Copyright © 2019 SachTech. All rights reserved.
//

import Foundation
import UIKit

class Keys {
    
    public static let MEDILEPSY = "Medilepsy Web"
    public static let INSTAGRAM = "Instagram"
    public static let USERDATA = UserModel(dict: [:])

    
    public static let SURVEY_LINK = "http://ucf.qualtrics.com/jfe/form/SV_78ap6xKcSWMv4DH"
    public static let INSTA_LINK = "https://instagram.com/medilepsy"
    public static let MEDILEPSY_LINK = "https://medilepsy.com"
    public static let IMG_BASE_URL = "https://medi-lepsy.org/"
    
    
    public static let MY_PROFILE = "My Profile"
    public static let REMINDERS = "Reminders"
    public static let REWARDS = "Rewards"
    public static let DAILY_ADHE = "Daily Adherence"
    public static let GRAPH = "Visual Graph Tracker"
    public static let CHATBOT = "Chatbot"
    public static let INSTA = "Instagram"
    public static let MEDI_WEB = "Medilepsy Web"


    public static let MENU_ITEMS  = [TutorialModel(msg: MY_PROFILE, img: UIImage(named: "menu1")!),
                                        TutorialModel(msg: REMINDERS, img: UIImage(named: "menu2")!),
                                        TutorialModel(msg: REWARDS, img: UIImage(named: "menu3")!),
                                        TutorialModel(msg: DAILY_ADHE, img: UIImage(named: "menu4")!),
                                        TutorialModel(msg: GRAPH, img: UIImage(named: "menu5")!),
                                        TutorialModel(msg: CHATBOT, img: UIImage(named: "bot")!),
                                        TutorialModel(msg: INSTA, img: UIImage(named: "menu7")!),
                                        TutorialModel(msg: MEDI_WEB, img: UIImage(named: "menu8")!)]
                                        
    public static let PARENT_MENU_ITEMS  = [TutorialModel(msg: MY_PROFILE, img: UIImage(named: "menu1")!),
                                        TutorialModel(msg: CHATBOT, img: UIImage(named: "bot")!),
                                        TutorialModel(msg: INSTA, img: UIImage(named: "menu7")!),
                                        TutorialModel(msg: MEDI_WEB, img: UIImage(named: "menu8")!)
    ]
    
    
    public static let TUTORIAL_DATA  = [TutorialModel(msg: "Welcome to the app", img: UIImage(named: "1")!),
                                        TutorialModel(msg: "To login, type your email address and a password in the corresponding fields. Then press the \"Sign in\" button.",img: UIImage(named: "2")!),
                                        TutorialModel(msg: "To register, type your email address and a password & other details in the corresponding fields. Then press the \"Sign Up\" button.", img: UIImage(named: "3")!),
                                        TutorialModel(msg: "Type your email address in the corresponding field. Then press the \"Continue\" button.", img: UIImage(named: "4")!),
                                        TutorialModel(msg: "Now a code has been sent to the email address for setting new password.",img: UIImage(named: "5")!),
                                        TutorialModel(msg: "Set up your new password by filling OTP Code & new password. Then press the \"Continue\" button.", img: UIImage(named: "6")!),
                                        TutorialModel(msg: "After sucessful login, Welcome to MENU page", img: UIImage(named: "7")!),
                                        TutorialModel(msg: "By tapping on left drawer button open drawer",img: UIImage(named: "8")!),
                                        TutorialModel(msg: "Change the app's theme by clicking on change theme from drawer", img: UIImage(named: "9")!),
                                        TutorialModel(msg: "Add medication reminders so you don't miss your next dose.", img: UIImage(named: "10")!),
                                        TutorialModel(msg: "See all the reminders for medicine",img: UIImage(named: "11")!),
                                        TutorialModel(msg: "Mark tick when medicine taken",img: UIImage(named: "12")!),
                                        TutorialModel(msg: "Manage the profile form", img: UIImage(named: "13")!),
                                        TutorialModel(msg: "Challenge yourself! Earn one point for every medication you take on time. And while you’re at it, ask someone to invest in your success!", img: UIImage(named: "14")!),
                                        TutorialModel(msg: "Daily adherance lists your taken medications on the selected day.",img: UIImage(named: "15")!),
                                        TutorialModel(msg: "Visual Graph Tracker \nKeep your eyes on your progress!", img: UIImage(named: "16")!),
                                        TutorialModel(msg: "Hi. Sam is unable to answer any of your questions right now. He’s learning how to become a better communicator. Check out the websites he’s selected for you—maybe you can learn too!", img: UIImage(named: "17")!),
                                        TutorialModel(msg: "Check out our Private Instagram page. Only people enrolled in the study will have access.",img: UIImage(named: "18")!),
                                        TutorialModel(msg: "Check out the website. Listen to some music, check out some videos, blog, share stories, and play some games.", img: UIImage(named: "19")!),
                                        TutorialModel(msg: "My Notes is your private place to journal, write questions, and jot notes.", img: UIImage(named: "20")!),
                                        TutorialModel(msg: "Survey",img: UIImage(named: "21")!),
                                        TutorialModel(msg: "Update profile image & details in setting page..",img: UIImage(named: "22")!)]
}


