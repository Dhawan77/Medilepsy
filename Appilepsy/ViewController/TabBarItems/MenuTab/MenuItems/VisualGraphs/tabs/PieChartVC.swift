//
//  PieChartVC.swift
//  Medilepsy
//
//  Created by John on 06/02/21.
//

import UIKit
import Charts

class PieChartVC: DemoBaseViewController {

    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var dateBtn: UIButton!
    var datePicker = UIDatePicker()
    var todayData = [ReminderModel]()
    var totalDosage = 0
    var sortList = [sortGraph]()
    var selctionOtions = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setup(pieChartView: pieChart)
        let color = UIColor(named: "theme")!.withAlphaComponent(0.9)
        datePicker.backgroundColor = color
        pieChart.delegate = self
        
        let l = pieChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0

        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        getAdherannce(date: getDate(date: Date()), dateLbl: getDate2(date: Date()))
    }
    
    @IBAction func dateFilter(_ sender: Any) {
        showDatePicker()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            self.showDatePicker()
        }
    }
    
    func showDatePicker(){
      //Formate Date
       datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let color = UIColor(named: "theme")!.withAlphaComponent(0.9)
        datePicker.backgroundColor = color
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                
            }
        }
        datePicker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: self.view.frame.height-460, width: self.view.frame.width, height: 460)
        self.view.addSubview(datePicker)
      }
    
    
    
   @objc func dueDateChanged(sender:UIDatePicker){
    datePicker.removeFromSuperview()
    getAdherannce(date: getDate(date: sender.date), dateLbl: getDate2(date: sender.date))

    }
    
    fileprivate func sortListWithKey()->[sortGraph] {
          sortList.removeAll()
          for data in selctionOtions
          {
              var sortItem = sortGraph()
              sortItem.key = data
              sortItem.list = self.todayData.filter { (listItem) -> Bool in
                  var itemKey = ""
                  itemKey =  ((listItem.brandName ?? "")+" "+(listItem.genericName ?? ""))
                  return itemKey.elementsEqual(data)
              }
              self.sortList.append(sortItem)
          }
          return sortList
      }
    
    
    func getDate2(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }
    
    func getAdherannce(date:String,dateLbl:String)
    {
        dateBtn.setTitle(dateLbl, for: .normal)
        self.todayData.removeAll()
        self.totalDosage = 0
        HitApi.share().getAdherance(view: self.view, date: date){
            (status,msg,data) in
            for d in data
            {
                self.totalDosage = self.totalDosage+(Int(d.doseQuantity ?? "0") ?? 0)
            }
            self.todayData = data
            self.selctionOtions = self.todayData.map
            {return ($0.brandName ?? "")+" "+($0.genericName ?? "")}.unique()
            let d = self.sortListWithKey()
            if data.count < 1{
                self.pieChart.data = nil
                self.updateChartData()
            }
            else{
                self.updateChartData()
            }
        }
    }
    
    func getDate(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func updateChartData() {
        if self.shouldHideData {
            pieChart.data = nil
            return
        }
        
        self.setDataCount(sortList.count, range: UInt32(sortList.count))
    }

    
 
    
    func setDataCount(_ count: Int, range: UInt32) {
       
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            var a = 0
            for data in sortList[i].list
            {
                a = a+(Int(data.doseQuantity ?? "0") ?? 0)
            }
            let value = Double(a)
            return PieChartDataEntry(value: value,
                                     label: (sortList[i].key ?? ""),
                                     icon: #imageLiteral(resourceName: "eye"))
        }
        
        let set = PieChartDataSet(entries: entries, label: "Medilepsy")
        set.entryLabelColor = .black
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }

}
extension Sequence {
    func groupSort(ascending: Bool = true, byDate dateKey: (Iterator.Element) -> Date) -> [[Iterator.Element]] {
        var categories: [[Iterator.Element]] = []
        for element in self {
            let key = dateKey(element)
            guard let dayIndex = categories.index(where: { $0.contains(where: { Calendar.current.isDate(dateKey($0), inSameDayAs: key) }) }) else {
                guard let nextIndex = categories.index(where: { $0.contains(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) }) else {
                    categories.append([element])
                    continue
                }
                categories.insert([element], at: nextIndex)
                continue
            }

            guard let nextIndex = categories[dayIndex].index(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) else {
                categories[dayIndex].append(element)
                continue
            }
            categories[dayIndex].insert(element, at: nextIndex)
        }
        return categories
    }
}
