//
//  StringProcessor.swift
//  Medilepsy
//
//  Created by Devante McFarlane on 9/24/20.
//  Copyright © 2020 Devante McFarlane. All rights reserved.
//

import Foundation
import UIKit

class ChatbotProcessor {
    
    private var waitingForName: Bool = false
    private var waitingForState: Bool = false
    private var waitingForEpilepsy: Bool = false
    private var waitingForSiteVisit: Bool = false
    private var waitingForMedications: Bool = false
    private var waitingForSideEffects: Bool = false
    private var waitingForSiteFda: Bool = false
    private var waitingForSiteEpp: Bool = false
    private var waitingForSiteApp: Bool = false
    private var waitingForYoutube: Bool = false
    private var waitingForEpilepsyFacts: Bool = false
    private var waitingForAudio: Bool = false
    private var waitingForExit: Bool = false
    private var waitingForNemours: Bool = false
    private var waitingForDoctor: Bool = false
    private var waitingForManaging: Bool = false
    private var waitingForWellness: Bool = false
    private var waitingForInsurance: Bool = false
    var delegate : LinkOpen?
    public var username: String = ""

    var genericResponses: [String] = [
        "i understand.",
        "i see.",
        "alright."]
    
    var greetings: [String] = [
        "hi",
        "hey",
        "hello",
        "greetings",
        "sup",
        "s up"
    ]
    
    var accept: [String] = [
        "yes",
        "yep",
        "yea",
        "ye",
        "ya",
        "y"]
    
    var initialGreetings: [String] = [
        "Hi, I’m a friendly bot. My name is Sam. What’s your name?"]
    
    public func acceptString(input: String) {
        analyzeString(input: input)
    }
    
    public func analyzeString(input: String) -> String {
        
        let response: String = "I'm sorry, I can't answer your question right now. I'm still learning to better communicate."
        
        if (waitingForName) {
            let words = input.byWords
            waitingForName = false
            waitingForState = true
            username = "\(words.last ?? "")"
            return "Hi \(words.last ?? ""), how are you feeling today?"
        }
        
        if (waitingForState) {
            waitingForState = false
            waitingForEpilepsy = true
            return "Thanks for sharing. Hey, what do you know about epilepsy?"
        }
        
        if (waitingForEpilepsy) {
            waitingForEpilepsy = false
            waitingForSiteVisit = true
            return "Thanks. Learning some information about epilepsy is a good way to take control over your condition. Check out this website @ https://www.epilepsy.com/learn/about-epilepsy-basics.  Would you like to check it out now?"
        }
        
        if (waitingForSiteVisit) {
            waitingForSiteVisit = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                
                if let url = URL(string: "https://www.epilepsy.com/learn/about-epilepsy-basics") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForMedications = true
                return "I’m curious. Can you tell me what medications you take?"
            } else {
                waitingForMedications = true
                return "I’m curious. Can you tell me what medications you take?"
            }
        }
        
        if (waitingForMedications) {
            waitingForMedications = false
            waitingForSideEffects = true
            return "Oh, Ok. Do you know the side effects of your medications?"
        }
        
        if (waitingForSideEffects) {
            waitingForSideEffects = false
            waitingForSiteFda = true
            return "Here’s a website you can check out to learn more about your meds and their side effects https://www.fda.gov/drugs/drug-information-consumers/find-information-about-drug.  Would you like to check it out?"
        }
        
        if (waitingForSiteFda) {
            waitingForSiteFda = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://www.fda.gov/drugs/drug-information-consumers/find-information-about-drug") {
                    delegate?.openLink(link: url.absoluteString)
                    
                }
                waitingForSiteEpp = true
                return "Sometimes, dealing with epilepsy can be frustrating.  Here’s a resource I came across that’s available 24/7. https://www.epilepsy.com/living-epilepsy/247-helpline.  Would you like to go here now?"
            } else {
                waitingForSiteEpp = true
                return "Sometimes, dealing with epilepsy can be frustrating.  Here’s a resource I came across that’s available 24/7. https://www.epilepsy.com/living-epilepsy/247-helpline.  Would you like to go here now?"
            }
        }
        
        if (waitingForSiteEpp) {
            waitingForSiteEpp = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://www.epilepsy.com/learn/about-epilepsy-basics") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForSiteApp = true
                return "Thanks for chatting with me. If you want to listen to sound cloud and access other resources, check out https://medilepsy.com/.  Should I take you there now?"
            } else {
                waitingForSiteApp = true
                return "Thanks for chatting with me. If you want to listen to sound cloud and access other resources, check out https://medilepsy.com/.  Should I take you there now?"
            }
        }
        
        if (waitingForSiteApp) {
            waitingForSiteApp = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://medilepsy.com/") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForYoutube = true
                return "I’m not sure about your experience, but I don’t know much about the topic of transitioning? Do you? Check out this you tube video https://www.youtube.com/watch?v=iNLCtA_fD1w&t=82s"
            } else {
                waitingForYoutube = true
                return "I’m not sure about your experience, but I don’t know much about the topic of transitioning? Do you? Check out this you tube video https://www.youtube.com/watch?v=iNLCtA_fD1w&t=82s"
            }
        }
        
        if (waitingForYoutube) {
            waitingForYoutube = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://www.youtube.com/watch?v=iNLCtA_fD1w&t=82s") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForEpilepsyFacts = true
                return "Someone shared with me a 13-minute video. Honestly, I wasn’t going to watch it, but I’m glad I did. I learned some real facts about epilepsy. Check out this YouTube video https://www.youtube.com/watch?v=bl0A-0XljrI"
            } else {
                waitingForEpilepsyFacts = true
                return "Someone shared with me a 13-minute video. Honestly, I wasn’t going to watch it, but I’m glad I did. I learned some real facts about epilepsy. Check out this YouTube video https://www.youtube.com/watch?v=bl0A-0XljrI"
            }
        }
        
        if (waitingForEpilepsyFacts) {
            waitingForEpilepsyFacts = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://www.youtube.com/watch?v=bl0A-0XljrI") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForAudio = true
                return "I wanted to share with you an audio about transition. I preferred listening to the article rather than reading it. Here’s the link to listen to it. https://kidshealth.org/en/teens/medical-care.html"
            } else {
                waitingForAudio = true
                return "I wanted to share with you an audio about transition. I preferred listening to the article rather than reading it. Here’s the link to listen to it. https://kidshealth.org/en/teens/medical-care.html"
            }
        }
        
        if (waitingForAudio) {
            waitingForAudio = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://kidshealth.org/en/teens/medical-care.html") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForNemours = true
                return "Asking your doctor questions can about your health may be hard. Check out Nemours website about questions to ask your doctor. Would you like to visit now? https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg"
            } else {
                waitingForNemours = true
                return "Asking your doctor questions can about your health may be hard. Check out Nemours website about questions to ask your doctor. Would you like to visit now? https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg"
            }
        }
        
        if (waitingForNemours) {
            waitingForNemours = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForDoctor = true
                return "Talking to your doctor about uncomfortable topics is something that a lot of us struggle with. Check out this website to learn about tips to discuss topics with your doctor. https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg"
            } else {
                waitingForDoctor = true
                return "Talking to your doctor about uncomfortable topics is something that a lot of us struggle with. Check out this website to learn about tips to discuss topics with your doctor. https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg"
            }
        }
        
        if (waitingForDoctor) {
            waitingForDoctor = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForManaging = true
                return "Managing day to day living can be overwhelming. But, hey, we’re getting older and learning how to become independent comes with young adulthood responsibilities. Check out the Epilepsy Foundation website and select topics to learn more about driving, dating, health insurance and healthy living https://www.epilepsy.com/living-epilepsy/epilepsy-and/young-people/tips-day-day-living."
            } else {
                waitingForManaging = true
                return "Managing day to day living can be overwhelming. But, hey, we’re getting older and learning how to become independent comes with young adulthood responsibilities. Check out the Epilepsy Foundation website and select topics to learn more about driving, dating, health insurance and healthy living https://www.epilepsy.com/living-epilepsy/epilepsy-and/young-people/tips-day-day-living."
            }
        }
        
        if (waitingForManaging) {
            waitingForManaging = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://www.epilepsy.com/living-epilepsy/epilepsy-and/young-people/tips-day-day-living") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForWellness = true
                return "Staying healthy, happy, and managing your epilepsy is important to live your best life. I wanted to share with you the Epilepsy Foundation wellness support tools. https://www.epilepsy.com/about-us/our-programs/wellness-institute"
            } else {
                waitingForWellness = true
                return "Staying healthy, happy, and managing your epilepsy is important to live your best life. I wanted to share with you the Epilepsy Foundation wellness support tools. https://www.epilepsy.com/about-us/our-programs/wellness-institute"
            }
        }
        
        if (waitingForWellness) {
            waitingForWellness = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                
                if let url = URL(string: "https://www.epilepsy.com/about-us/our-programs/wellness-institute") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForInsurance = true
                return "I’m pretty sure you’ve heard someone ask you or your caregiver about health insurance when you’ve had to seek medical attention. Do you know about health coverage? What it covers? The types of plans? Check out Nemours website to learn health insurance basics. https://kidshealth.org/en/teens/insurance.html"
            } else {
                waitingForInsurance = true
                return "I’m pretty sure you’ve heard someone ask you or your caregiver about health insurance when you’ve had to seek medical attention. Do you know about health coverage? What it covers? The types of plans? Check out Nemours website to learn health insurance basics. https://kidshealth.org/en/teens/insurance.html"
            }
        }
        
        if (waitingForInsurance) {
            waitingForInsurance = false
            if (accept.contains(where: input.lowercased().contains)) {
                // Open browser to site
                if let url = URL(string: "https://kidshealth.org/en/teens/insurance.html") {
                    delegate?.openLink(link: url.absoluteString)
                }
                waitingForExit = true
                return "I hope I was able to help you learn some things about epilepsy, medications, and transition. Wishing you well–Sam. ✌️"
            } else {
                waitingForExit = true
                return "I hope I was able to help you learn some things about epilepsy, medications, and transition. Wishing you well–Sam. ✌️"
            }
        }
        
        if (waitingForExit) {
            waitingForExit = false
            return "Our resources were provided from the list below. Please always check for updates! \n\nMedilepsy (n.d.). \nRetrieved from https://medilepsy.com/ \n\nEpilepsy Association of Western and Central PA. (n.d.).Transition with Ease: Advice for Teens \nRetrieved from https://www.youtube.com/watch?v=iNLCtA_fD1w&t=82s \n\nEpilepsy Foundation. (n.d.). About epilepsy: The basics \nRetrieved from https://www.epilepsy.com/learn/about-epilepsy-basics \n\nEpilepsy Foundation. (n.d.). 24/7 Helpline. \nRetrieved from https://www.epilepsy.com/living-epilepsy/247-helpline \n\nEpilepsy Foundation. (n.d.). Seizures and You: Take Charge of the Facts. \nRetrieved from https://www.youtube.com/watch?v=bl0A-0XljrI \n\nU.S. Food & Drug Administration. (n.d.). Find information about a drug. \nRetrieved from https://www.fda.gov/drugs/drug-information-consumers/find-information-about-drug \n\nTeensHealth from Nemours. (n.d.). Taking Charge of Your Medical Care. \nRetrieved from https://kidshealth.org/en/teens/medical-care.html \n\nHealth Insurance Basics: Teens Health from Nemours. (n.d.). \nRetrieved from https://kidshealth.org/en/teens/insurance.html \n\n Talking to Your Doctor & Doctor Visits: Teens Health from Nemours. (n.d.). \nRetrieved from https://kidshealth.org/en/teens/talk-doctor.html?WT.ac=ctg \n\n Tips for Day to Day Living: Epilepsy Foundation. (n.d.). \nRetrieved from https://www.epilepsy.com/living-epilepsy/epilepsy-and/young-people/tips-day-day-living \n\n Questions to Ask Your Doctor: Teens Health from Nemours. (n.d.). \nRetrieved from https://kidshealth.org/en/teens/questions-doctor.html?WT.ac=ctg\n\nWellness Institute: Epilepsy Foundation. (n.d.).\nRetrieved from https://www.epilepsy.com/about-us/our-programs/wellness-institute"
        }
        
        if (greetings.contains(where: input.lowercased().contains)) {
            return "Hello!"
        }
        
        if (input.lowercased().contains("name is") && !input.contains("?")) {
            let words = input.byWords
            return "Hi \(words.last ?? "")"
        }
        
        if (input.lowercased().contains("suicide")) {
            return "Please contact 800-273-8255."
        }
        
        return response
    }
    
    func greetUser() -> String {
        return initialGreetings[0]
    }
    
    func waitForName() {
        waitingForName = true
    }
}

extension StringProtocol {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}


protocol LinkOpen {
    func openLink(link:String)
}
