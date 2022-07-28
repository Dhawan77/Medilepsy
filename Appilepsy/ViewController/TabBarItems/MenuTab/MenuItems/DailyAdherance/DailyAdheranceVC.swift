//
//  DailyAdheranceVC.swift
//  Medilepsy
//
//  Created by John on 06/02/21.
//

import UIKit

class DailyAdheranceVC: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var adherenceTbl: UITableView!
    @IBOutlet weak var nodataLbl: UILabel!

    var adherenceData = [ReminderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        getAdherannce(date: Date())
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)

    }
    
    func getDate(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }
    
    
    func getAdherannce(date:Date)
    {
        self.adherenceData.removeAll()
        HitApi.share().getAdherance(view: self.view, date: getDate(date: date)){
            (status,msg,data) in
            self.adherenceData = data
            if data.count < 1{
                self.nodataLbl.isHidden = false
            }
            else{
                self.nodataLbl.isHidden = true
            }
            self.adherenceTbl.reloadData()
            
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        getAdherannce(date: picker.date)
    }
    
    @IBAction func goback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
   
    

  
    
}
extension DailyAdheranceVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adherenceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakenMedTVC") as! TakenMedTVC
        let data = adherenceData[indexPath.row]
        cell.nameLabel.text = (data.brandName ?? "")+" "+(data.genericName ?? "")
        cell.doseLbl.text = "\(data.unit ?? "") (\(data.doseQuantity ?? ""))"
        cell.timeLabel.text = data.takenTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

          UIView.animate(
              withDuration: 0.5,
              delay: 0.05 * Double(indexPath.row),
              options: [.transitionFlipFromTop],
              animations: {
                  cell.transform = CGAffineTransform(translationX: 0, y: 0)
          })
      }
    
    
}
