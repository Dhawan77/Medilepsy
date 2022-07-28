//
//  TutorialVC.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import UIKit
import KYDrawerController
class TutorialVC: BaseViewController {

    @IBOutlet weak var tutorialCollection: UICollectionView!
    var tutorails = Keys.TUTORIAL_DATA
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.view.addGestureRecognizer(tapGesture)
//        timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true)
//            {
//            (block) in
//            self.scrollToNextCell()
//        }
        
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        let loc = sender.location(in: self.view).x
        if loc < self.view.frame.width/2{
            scrollToPreviousCell()
        }
        else{
            scrollToNextCell()
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if let ky = self.parent?.parent as? KYDrawerController{
            ky.setDrawerState(.opened, animated: true)
        }
    }
    
    func scrollToNextCell(){

           
          
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)

         
           let contentOffset = tutorialCollection.contentOffset

         
        tutorialCollection.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)


       }
    
    func scrollToPreviousCell(){

           
          
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)

         
           let contentOffset = tutorialCollection.contentOffset

         
        tutorialCollection.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)


       }

}

extension TutorialVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tutorialCollection.dequeueReusableCell(withReuseIdentifier: "TutorialCVC", for: indexPath) as! TutorialCVC
        cell.tutorialImg.image = tutorails[indexPath.row].img
        cell.tutorialMsg.text = tutorails[indexPath.row].msg
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
