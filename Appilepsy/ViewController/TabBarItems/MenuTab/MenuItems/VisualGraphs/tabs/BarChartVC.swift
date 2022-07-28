//
//  BarChartVC.swift
//  Medilepsy
//
//  Created by John on 06/02/21.
//

import UIKit
import SwiftCharts

class BarChartVC: DemoBaseViewController {
    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var dateBtn: UIButton!
    var todayData = [ReminderModel]()
    var datePicker = UIDatePicker()
    fileprivate var chart: Chart?
    var sortList = [sortGraph]()
    var selctionOtions = [String]()
    var selctionOtions2 = [String]()
    var percentage = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0...24{
            if index == 0{
                percentage.append("")
            }
            else{
            if index > 12
            {
                percentage.append("\(index-12) pm")
            }
            else
            {
                percentage.append("\(index) am")
            }}
        }
    
        setData(date: Date())
     
    }
    
    func setData(date:Date)
    {
        let startWeek = date.startOfWeek
        let endWeek = date.endOfWeek
        let dateFormat1 = DateFormatter()
        dateFormat1.dateFormat = "dd-MM-yyyy"
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "MM-dd-yyyy"
        let startLbl = dateFormat2.string(from: startWeek!)
        let startWeek2 = dateFormat1.string(from: startWeek!)
        let dateFormat12 = DateFormatter()
        dateFormat12.dateFormat = "dd-MM-yyyy"
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM-dd-yyyy"
        let endWeek2 = dateFormat12.string(from: endWeek!)
        let endLbl = dateFormater.string(from: endWeek!)
        getAdherannce(start:startWeek2,end:endWeek2,startLbl: startLbl,endLbl: endLbl)
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
    setData(date: sender.date)

    }
    
    func getAdherannce(start:String,end:String,startLbl:String,endLbl:String)
    {
        dateBtn.setTitle("\(startLbl) - \(endLbl)", for: .normal)
        self.todayData.removeAll()
        HitApi.share().getGraphData(view: self.view,startDate: start,endDate: end){
            (status,msg,data) in
            self.todayData = data
            self.selctionOtions = self.todayData.map
            {
                let a = self.getDated(date: self.strToDate(str: $0.takenDate ?? ""))
                return self.getDay(date: self.strToDate(str: $0.takenDate ?? ""))+"\n"+a}.unique()
            _ = self.sortListWithKey()
       
            self.showChart(horizontal: false)
        }
    }
    
    fileprivate func sortListWithKey()->[sortGraph] {
          sortList.removeAll()
          for data in selctionOtions
          {
              var sortItem = sortGraph()
              sortItem.key = data
              sortItem.list = self.todayData.filter { (listItem) -> Bool in
                  var itemKey = ""
                let a = self.getDated(date: self.strToDate(str: listItem.takenDate ?? ""))
                  itemKey =  self.getDay(date: self.strToDate(str: listItem.takenDate ?? ""))+"\n"+a
                  return itemKey.elementsEqual(data)
              }
              self.sortList.append(sortItem)
          }
          return sortList
      }

    func getDay(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }
    
    func getDated(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }
    
    func strToDate(str:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: str)
        return date ?? Date()
    }
    
    func getDate(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let ouptputTime = dateFormatter.string(from: date)
        return ouptputTime
    }
    
    func getTime(str:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: str)
        return date ?? Date()
    }
    func get24Time(date:Date) -> Double
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "mm"
        let ouptputTime = dateFormatter.string(from: date)
        let ouptputTime2 = dateFormatter2.string(from: date)
        let a = (Double(ouptputTime2) ?? 0.0)/100
        let output = Double(ouptputTime) ?? 0.0
        return output+a
    }
    
    fileprivate func barsChart(horizontal: Bool) -> Chart {
        let labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 12.0),fontColor: UIColor(named: "textColor")!)
        let label2Settings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 0.0),fontColor: UIColor(named: "textColor")!)
        var groupList: [(title: String, [(min: Double, max: Double)])] = []
        self.sortList.forEach { (item) in
            var valuesArr = [(min: Double, max: Double)]()
            item.list.forEach { (listItem) in
                valuesArr.append((0.0,(get24Time(date: getTime(str: listItem.takenTime ?? "")))))
            }
            groupList.append((item.key ?? "",valuesArr))
        }
        
        
        let groups: [ChartPointsBarGroup] = groupList.enumerated().map {index, entry in
        let constant = ChartAxisValueDouble(index)
        let bars = entry.1.enumerated().map {index, tuple in
            ChartBarModel(constant: constant, axisValue1: ChartAxisValueDouble(tuple.min), axisValue2: ChartAxisValueDouble(tuple.max), bgColor: UIColor.random())
        }
        return ChartPointsBarGroup(constant: constant, bars: bars)
        }
        let (axisValues1, axisValues2): ([ChartAxisValue], [ChartAxisValue]) = (
        percentage.enumerated().map {index, tuple in ChartAxisValueString(tuple, order: index, labelSettings: labelSettings)},
        [ChartAxisValueString(order: -1)] +
            groupList.enumerated().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} +
        [ChartAxisValueString(order: groupList.count)]
        )
        let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "", settings: label2Settings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "", settings: label2Settings))
        let frame = barChartView.bounds
        let chartFrame = chart?.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        
        let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5, selectionViewUpdater: ChartViewSelectorBrightness(selectedFactor: 0.5))
        
        let groupsLayer = ChartGroupedPlainBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, groups: groups, horizontal: horizontal, barSpacing: 2, groupSpacing: 5, settings: barViewSettings, tapHandler: { tappedGroupBar /*ChartTappedGroupBar*/ in
            
            let barPoint = horizontal ? CGPoint(x: tappedGroupBar.tappedBar.view.frame.maxX, y: tappedGroupBar.tappedBar.view.frame.midY) : CGPoint(x: tappedGroupBar.tappedBar.view.frame.midX, y: tappedGroupBar.tappedBar.view.frame.minY)
            
            guard let chart = self.chart, let chartViewPoint = tappedGroupBar.layer.contentToGlobalCoordinates(barPoint) else {return}
        
            let viewPoint = CGPoint(x: chartViewPoint.x, y: chartViewPoint.y)
            let a = self.todayData.filter{"\(self.get24Time(date: self.getTime(str: $0.takenTime ?? "")))" == tappedGroupBar.tappedBar.model.axisValue2.description}
            let med = a.randomElement()
            let infoBubble = InfoBubble(point: viewPoint, preferredSize: CGSize(width: 50, height: 40), superview: self.chart!.view, text: "\(med?.medicineName ?? "")"+" "+"\(med?.genericName ?? "")", font: ExamplesDefaults.labelFont, textColor: UIColor.white, bgColor: UIColor.black, horizontal: horizontal)
            
            let anchor: CGPoint = {
                switch (horizontal, infoBubble.inverted(chart.view)) {
                case (true, true): return CGPoint(x: 1, y: 0.5)
                case (true, false): return CGPoint(x: 0, y: 0.5)
                case (false, true): return CGPoint(x: 0.5, y: 0)
                case (false, false): return CGPoint(x: 0.5, y: 1)
                }
            }()
            
            let animatorsSettings = ChartViewAnimatorsSettings(animInitSpringVelocity: 5)
            let animators = ChartViewAnimators(view: infoBubble, animators: ChartViewGrowAnimator(anchor: anchor), settings: animatorsSettings, invertSettings: animatorsSettings.withoutDamping(), onFinishInverts: {
                infoBubble.removeFromSuperview()
            })
            
            chart.view.addSubview(infoBubble)
            
            infoBubble.tapHandler = {
                animators.invert()
            }
            
            animators.animate()
        })
        
        let guidelinesSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.clear, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: horizontal ? .x : .y, settings: guidelinesSettings)
        
        return Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                groupsLayer
            ]
        )
    }
    
    
    fileprivate func showChart(horizontal: Bool) {
        self.chart?.clearView()
        let chart = barsChart(horizontal: horizontal)
        barChartView.addSubview(chart.view)
        self.chart = chart
    }
    
   
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
}
