//
//  ChartsViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import Charts
import FlagKit

class ChartsViewController : BaseMainViewController {
    var saveCompared : CompareData = CompareData(base: "USD", symbols: "CAD") {
        didSet{
            print("DATA LOCAL COMPARED")
            let regionCode2 = self.saveCompared.base.getRegionCode()
            let flag2 = Flag(countryCode: regionCode2 ?? "")!
            let originalImage2 = flag2.originalImage
            self.btn1.imageView.image = originalImage2
            self.btn1.label.text =  self.saveCompared.base
            
            let regionCode = self.saveCompared.symbols.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.btn2.imageView.image = originalImage
            self.btn2.label.text =  self.saveCompared.symbols
            
            
            self.textView.label.text = "1 \(self.saveCompared.base.countryCode()) equals"
            self.textView.labelView.text = "0.0000 \(self.saveCompared.symbols.countryCode())"
            
            UserDefaults.standard.setStruct(saveCompared, forKey: localArray.comparedData)
        }
    }
    
    lazy var btnView : UIView = {
        let scroll = UIView()
        return scroll
    }()
    
    lazy var btn1 : CustomImageViewButton = {
        let btn = CustomImageViewButton()
        btn.label.text = "USD"
        btn.backgroundColor = Config().colors.whiteBackground
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = Config().colors.blueBgColor.cgColor
        btn.layer.borderWidth = 1
        btn.tag = 1
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var arrow : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = Config().colors.blueBgColor
        return v
    }()
    
    lazy var btn2 : CustomImageViewButton = {
        let btn = CustomImageViewButton()
        btn.label.text = "CAD"
        btn.backgroundColor = Config().colors.whiteBackground
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = Config().colors.blueBgColor.cgColor
        btn.layer.borderWidth = 1
        btn.tag = 2
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var textView : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.text = ""
        txt.labelView.tag = 1
        txt.labelView.text = ""
        txt.labelView.isUserInteractionEnabled = true
        txt.line.backgroundColor = Config().colors.borderColor
        return txt
    }()
    
    lazy var buttons : CustomButtonPicker = {
        let btn = CustomButtonPicker()
        btn.btn1.setTitle("1W", for: .normal)
        btn.btn2.setTitle("1M", for: .normal)
        btn.btn3.setTitle("3M", for: .normal)
        btn.btn4.setTitle("1Y", for: .normal)
        btn.btn5.setTitle("5Y", for: .normal)
        btn.btn6.setTitle("10Y", for: .normal)
        btn.btn1.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        btn.btn2.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        btn.btn3.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        btn.btn4.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        btn.btn5.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        btn.btn6.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var chartView : LineChartView = {
        let t = LineChartView()
        t.dragYEnabled = false
        t.leftAxis.removeAllLimitLines()
        t.leftAxis.labelPosition = .insideChart
        t.leftAxis.gridLineDashLengths = [10, 10]
//        t.leftAxis.drawLimitLinesBehindDataEnabled = true
        t.xAxis.drawGridLinesEnabled = false
        t.legend.enabled = false
        t.rightAxis.drawLabelsEnabled = false
        t.xAxis.drawLabelsEnabled = false
        t.doubleTapToZoomEnabled = false
        t.leftAxis.gridColor = .white
//        t.leftAxis.line
        t.leftAxis.drawGridLinesEnabled = true
//        t.highlightPerTapEnabled = false
        t.alpha = 0
        return t
    }()
    
    lazy var markerView : UILabel = {
        let lbl = UILabel()
        lbl.text = "MARKER"
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 15
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.backgroundColor = Config().colors.blueBgColor
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.4
        return lbl
    }()
    
    lazy var loadingView : UIActivityIndicatorView = {
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = .gray
        return loadingIndicator
    }()

    var buttonActive : Int = 1
    
    var numbers : [Double] = []  {
        didSet{
            self.hideShowChart(alpha: 1)
        }
    } //This is where we are going to store all the numbers. This can be a set of numbers that come from a Realm database, Core data, External API's or where ever else
    var rateDates : [Int] = []
    
    var viewModel : ConverterViewModel?
    
    var alertData : [RatesData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.buttonActive = 1
                self.buttons.onClickAction(tag: 1)
                self.sortArrayOnGraph(timeInterval: 0)
                
                self.textView.label.text = "1 \(self.saveCompared.base.countryCode()) equals"
                self.textView.labelView.text = "\(String(format: "%.4f", (self.alertData.last?.rate ?? 0.0))) \(self.saveCompared.symbols.countryCode())"
                
                let dateNow = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd MMMM, h:mm a"
               self.chartView.chartDescription?.text = "\(dateFormat.string(from: dateNow)) UTC" // Here we set the description for the graph
                
                UserDefaults.standard.setStruct(self.alertData, forKey: localArray.chartsData)
            }
        }
    }
    
    override func setUpNavigationBar() {
        self.setUpTitleView(text: "Charts")
//
        self.tabBarController?.navigationItem.rightBarButtonItems = nil
        
        
//        defaultBarButton = UIBarButtonItem(image: UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(bellAction))
//        defaultBarButton.tintColor = Config().colors.whiteBackground
//        //        currencyBarButton.image: UIImage(named: "currency")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(currencyAction)
//        self.tabBarController?.navigationItem.rightBarButtonItems = [defaultBarButton]
    }
    
    override func setUpOnViewDidLoad() {
        if let data = self.viewModel?.getComparedDataFromLocal() {
            saveCompared = data
        }
        
        updateGraph()
        setUpListener()
        chartView.delegate = self
    }
    
    override func setUpView() {
        
        view.addSubview(btnView)
        btnView.backgroundColor = Config().colors.lightGraybackground
        btnView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-40) // - 10
            }else {
                make.top.equalTo(view).offset(10)
            }
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(80)
        }
        
        
        btnView.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(btnView).offset(20)
            make.leading.equalTo(btnView).offset(40)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        btnView.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.top.equalTo(btnView).offset(30)
            make.centerX.equalTo(btnView)
            make.height.equalTo(20)
        }
        
        btnView.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(btnView).offset(20)
            make.trailing.equalTo(btnView).offset(-40)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(40)
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(btnView.snp.bottom).offset(10)
            make.trailing.equalTo(view).offset(-20)
            make.leading.equalTo(view).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(buttons)
        buttons.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo((40 * 6) + 50)
            make.height.equalTo(40)
        }
        
        view.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.top.equalTo(buttons.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        chartView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(chartView)
            make.height.width.equalTo(100)
        }
        
        chartView.addSubview(markerView)
//        markerView.snp.makeConstraints { (make) in
//            make.top.equalTo(chartView.snp.top)
//            make.
        //        }
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        btn1.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        btn2.addGestureRecognizer(tap4)
        
    }
    
    
    @objc func buttonsAction (_ sender : UIButton) {
        if sender.tag != self.buttonActive {
            
            self.loadingView.startAnimating()
            self.hideShowChart(alpha: 0)
            self.chartView.highlightValue(nil)
            buttons.onClickAction(tag: sender.tag)
            
            let dateNow = Date()
            var dateToSort : TimeInterval = 0
            
            switch sender.tag {
            case 2:
                let fromDate = Calendar.current.date(byAdding: .month, value: -1, to: dateNow)
                dateToSort = fromDate?.timeIntervalSince1970 ?? 0
            case 3:
                let fromDate = Calendar.current.date(byAdding: .month, value: -3, to: dateNow)
                dateToSort = fromDate?.timeIntervalSince1970 ?? 0
            case 4:
                let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: dateNow)
                dateToSort = fromDate?.timeIntervalSince1970 ?? 0
            case 5:
                let fromDate = Calendar.current.date(byAdding: .year, value: -5, to: dateNow)
                dateToSort = fromDate?.timeIntervalSince1970 ?? 0
            case 6:
                let fromDate = Calendar.current.date(byAdding: .year, value: -10, to: dateNow)
                dateToSort = fromDate?.timeIntervalSince1970 ?? 0
            default:
                print("HAHAHHA DEFAULT")
            }
            
            self.buttonActive = sender.tag
            
            sortArrayOnGraph(timeInterval: Int(dateToSort))
        }

        
    }
    
    func sortArrayOnGraph(timeInterval : Int) {
        self.hideShowChart(alpha: 0)
        let checkDate = Calendar.current.component(.weekday, from: Date())
        print("CHECK : \(checkDate)")
        let fromDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let interval = timeInterval == 0 ? Int(fromDate?.timeIntervalSince1970 ?? 0) : timeInterval
        self.numbers = []
        self.rateDates = []
        print("CHECK : \(checkDate) : \(interval)")
        for x in self.alertData {
            if x.date >= interval {
                self.numbers.append(x.rate) // Double(String(format: "%.4f", x.rate)) ?? 0
                self.rateDates.append(x.date)
            }
        }
        print("NUMBER COUNT : \(numbers.count)")
        self.updateGraph()
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessGettingRatesHistory = { [weak self] data in
            self?.alertData = data?.sorted(by: { $0.date < $1.date }) ?? []
        }
        
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                print("ERRORRRRRRRRRRR")
                self?.alert(btn: "OK", title: "", msg: error?.message ?? "Something went wrong")
            }
        }
        
        self.requestData()
    }
    
    func requestData() {
        self.loadingView.startAnimating()
        self.hideShowChart(alpha: 0)
        let dateNow = Date()
        let fromDate = Calendar.current.date(byAdding: .year, value: -10, to: dateNow)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-M-dd"
        let base = self.saveCompared.base
        let symbols = self.saveCompared.symbols
        let param : [String:Any] = ["base": base, "symbols" : symbols, "start_at" : dateFormater.string(from: fromDate ?? dateNow),"end_at" :  dateFormater.string(from: dateNow)]
        self.viewModel?.getRatesHistory(param: param)
    }
    
    func alert(btn: String,title: String,msg: String) {
        if self.viewIfLoaded?.window != nil {
            let alert = self.alert(btn, title, msg) { (action) in
                
            }
            //        self.present(alert, animated: true, completion: nil)
            self.navigationController?.present(alert, animated: true, completion: nil)
            
        }
        
    }
   
  
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]()
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        

        let line1 = LineChartDataSet(values: lineChartEntry, label: "")
        line1.colors = [Config().colors.blueBgColor]
        line1.drawFilledEnabled = true
        line1.drawCirclesEnabled = false
        line1.drawValuesEnabled = false
        line1.drawHorizontalHighlightIndicatorEnabled = false
        line1.highlightColor = Config().colors.blueBgColor
        line1.highlightLineWidth = 2
        
        let gradientColors = [Config().colors.whiteBackground.cgColor,Config().colors.lightBlueBgColor.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        line1.fillAlpha = 1
        line1.fill = Fill(linearGradient: gradient, angle: 90)
        line1.drawFilledEnabled = true
        
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        chartView.data = data
        
        chartView.leftAxis.drawLabelsEnabled = true
//        let marker = BalloonMarker(color: Config().colors.blueBgColor,font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
//        marker.chartView = chartView
//        marker.minimumSize = CGSize(width: 80, height: 40)
//        chartView.marker = marker
        
        
        chartView.animate(xAxisDuration: 1)
        self.loadingView.stopAnimating()
    }
    
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            hideMarker()
        }
    }
    
    func hideShowChart(alpha : CGFloat) {
        UIView.animate(withDuration: 1.0) {
            self.chartView.alpha = alpha
            self.chartView.layoutIfNeeded()
        }
    }
    
    @objc func selectCurrency(_ sender : UIGestureRecognizer) {
        let tag = sender.view?.tag
        print("CLICKING AT : \(tag)")
        var data : [CountryListArray] = [CountryListArray(country_name : self.saveCompared.base ,currency: self.saveCompared.base , rate: 0, amount:0),CountryListArray(country_name :  self.saveCompared.symbols ,currency: self.saveCompared.symbols , rate: 0, amount:0)]
        
        let controller = SelectingCurrencyViewController(data: data, vc: self)
        controller.tag = tag
        controller.navTitle = " Select Currency"
        controller.viewModel = ConverterViewModel()
        controller.viewModel?.model = ConverterModel()
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
}


extension ChartsViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let index = self.numbers.index(where: { (result) -> Bool in
            return result == highlight.y
        })
        
        if index != nil {
            chartView.chartDescription?.text = "\(self.rateDates[index!].timeIntervalToFormatedDate(format: "MMMM dd, yyyy")) UTC"
        }
        
        self.markerView.text = "\(Double(String(format: "%.4f", highlight.y)) ?? 0)"
        self.showMarker(xPos: highlight.xPx, yPos: highlight.yPx)
    
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
//        print("CHAT DRAG ENDED")
        self.chartView.highlightValue(nil)
        self.hideMarker()
    }
    
    func showMarker(xPos : CGFloat,yPos: CGFloat) {
        let checkedXPos = xPos > (self.view.frame.maxX / 2) ? xPos - 80 : xPos
        let width : CGFloat = 80
        let height : CGFloat = 30

        UIView.animate(withDuration: 0.1) {
            self.markerView.alpha = 1
            self.markerView.frame = CGRect(x: checkedXPos, y: yPos - 20, width: width, height: height)
            self.markerView.layoutIfNeeded()
        }

    }
    
    func hideMarker() {
        UIView.animate(withDuration: 0.5) {
            self.markerView.alpha = 0
        }
    }
    
}


class CustomButtonPicker : UIView {
    lazy var btn1 : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = Config().colors.blueBgColor
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.layer.cornerRadius = 20
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.tag = 1
        return btn
    }()
    
    lazy var btn2 : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.layer.cornerRadius = 20
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.tag = 2
        return btn
    }()
    
    lazy var btn3 : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.layer.cornerRadius = 20
        btn.tag = 3
        return btn
    }()
    
    lazy var btn4: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.layer.cornerRadius = 20
        btn.tag = 4
        return btn
    }()
    
    lazy var btn5 : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.layer.cornerRadius = 20
        btn.tag = 5
        return btn
    }()
    
    lazy var btn6 : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitleColor(Config().colors.blackBgColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: Fonts.bold, size: 16)
        btn.layer.cornerRadius = 20
        btn.tag = 6
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(self)
            
        }
        addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(btn1.snp.trailing).offset(10)
            
        }
        addSubview(btn3)
        btn3.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(btn2.snp.trailing).offset(10)
            
        }
        addSubview(btn4)
        btn4.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(btn3.snp.trailing).offset(10)
            
        }
        addSubview(btn5)
        btn5.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(btn4.snp.trailing).offset(10)
            
        }
        addSubview(btn6)
        btn6.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(40)
            make.leading.equalTo(btn5.snp.trailing).offset(10)
            
        }
    }
    
    func onClickAction(tag : Int) {
        self.btn1.setTitleColor(tag == 1 ? Config().colors.whiteBackground : Config().colors.blackBgColor, for: .normal)
        self.btn2.setTitleColor(tag == 2 ? Config().colors.whiteBackground : Config().colors.blackBgColor, for: .normal)
        self.btn3.setTitleColor(tag == 3 ? Config().colors.whiteBackground : Config().colors.blackBgColor, for: .normal)
        self.btn4.setTitleColor(tag == 4 ? Config().colors.whiteBackground : Config().colors.blackBgColor, for: .normal)
        self.btn5.setTitleColor(tag == 5 ? Config().colors.whiteBackground : Config().colors.blackBgColor, for: .normal)
        self.btn6.setTitleColor(tag == 6 ? Config().colors.whiteBackground : Config().colors.blackBgColor, for: .normal)
        
        self.btn1.backgroundColor = tag == 1 ? Config().colors.blueBgColor : .white
        self.btn2.backgroundColor = tag == 2 ? Config().colors.blueBgColor : .white
        self.btn3.backgroundColor = tag == 3 ? Config().colors.blueBgColor : .white
        self.btn4.backgroundColor = tag == 4 ? Config().colors.blueBgColor : .white
        self.btn5.backgroundColor = tag == 5 ? Config().colors.blueBgColor : .white
        self.btn6.backgroundColor = tag == 6 ? Config().colors.blueBgColor : .white
    }
}
