//
//  CreateAlertViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/26/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import FlagKit
import Charts

struct AlertDataList : Codable {
    let id: Int
    let expected_rate: Double
    let base_currency: String
    let compare_currency: String
    let current_rate: Double
    let base_country: String
    let compare_country: String
    let send_to_email: Int
    let status: Int
}

class CreateAlertViewController : UIViewController ,UITextFieldDelegate{
    var vc : UIViewController?
    
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    var sendAlert : Bool = false {
        didSet {
            if !sendAlert {
                self.checkBoxView.imageView.image = UIImage(named: "checked_empty")?.withRenderingMode(.alwaysTemplate)
                self.checkBoxView.imageView.tintColor = Config().colors.grayBackground
            }else {
                self.checkBoxView.imageView.image = UIImage(named: "checked")?.withRenderingMode(.alwaysTemplate)
                self.checkBoxView.imageView.tintColor = Config().colors.blueBgColor
            }
        }
    }
    
    var isDeleted : Bool = false

    var usersData : UsersData?
    
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
            
            UserDefaults.standard.setStruct(saveCompared, forKey: localArray.comparedData)
        }
    }
    
    var data : DataClassArray? {
        didSet {
            
        }
    }
    
    var rateAlertData : [AlertDataList] = []{
        didSet {
            
        }
    }
    
    var currentAlertData : AlertDataList? {
        didSet {
            self.saveCompared.base = self.currentAlertData?.base_currency ?? "USD"
            self.saveCompared.symbols = self.currentAlertData?.compare_currency ?? "CAD"
            self.txt2.textField.text = String(format: "%.4f", (self.currentAlertData?.expected_rate ?? 0))
            self.submitBtn.btn.setTitle("Update Alert", for: .normal)
            self.sendAlert = self.currentAlertData?.send_to_email == 1 ? true : false
        }
    }
    
    var currentIndex : Int?
    
    
    var alertData : [RatesData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.numbers = []
                for x in self.alertData {
                    print("RATES : \(x.rate)")
                    self.numbers.append(x.rate)
                }
                self.updateGraph()
                
                self.rateDescLabel.label.text = "1 \(self.saveCompared.base) = \(String(format: "%.4f", self.alertData.last?.rate ?? 0)) \(self.saveCompared.symbols)"
                
                self.rateDescLabel.textField.text = self.alertData.last?.date.timeIntervalToFormatedDate(format: "MMMM dd, yyyy")
            }
        }
    }
    
    var viewModel : ConverterViewModel?
    
    lazy var chartView : LineChartView = {
        let t = LineChartView()
        t.delegate = self
        t.dragYEnabled = false
        t.rightAxis.drawLabelsEnabled = false
        t.leftAxis.gridLineDashLengths = [5, 5]
        t.xAxis.drawLabelsEnabled = false
        t.leftAxis.labelPosition = .insideChart
        t.leftAxis.gridLineDashLengths = [10,10]
        t.legend.enabled = false
        t.dragXEnabled  = false
        t.xAxis.drawGridLinesEnabled = false
        t.doubleTapToZoomEnabled = false
        t.highlightPerTapEnabled = false
        t.highlightPerDragEnabled = false
        t.chartDescription?.text = ""
        t.alpha = 0
        return t
    }()
    
    var numbers : [Double] = [] {
        didSet{
            self.hideShowChart(alpha: 1)
        }
    }//[100,1000,99,2,10,300,400,200,5,10,300,400,200]
    
    lazy var btnView : UIView = {
        let btn = UIView()
//        btn.isUserInteractionEnabled = false
//        btn.backgroundColor = .clear
        return btn
    }()
    
    lazy var txt1 : CustomTextFieldWithLabelTop = {
        let txt = CustomTextFieldWithLabelTop()
        txt.label.font = UIFont(name: Fonts.regular, size: 10)
        txt.labelView.font = UIFont(name: Fonts.bold, size: 25)
        txt.label.text = "WHEN"
        txt.labelView.tag = 1
        txt.labelView.text = "1"
        txt.labelView.textColor = Config().colors.grayBackground
        txt.labelView.isUserInteractionEnabled = true
        return txt
    }()
    
    lazy var equals : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 16)
        v.text = "="
        return v
    }()
    
    lazy var txt2 : CustomTextFieldWithLabelTopEditable = {
        let txt = CustomTextFieldWithLabelTopEditable()
        txt.label.font = UIFont(name: Fonts.regular, size: 10)
        txt.textField.font = UIFont(name: Fonts.bold, size: 25)
        txt.label.text = "EQUALS"
        txt.textField.placeholder = "0"
        txt.textField.textColor = Config().colors.blueBgColor
        txt.textField.keyboardType = .numberPad
        return txt
    }()
    
    
    lazy var topDesc : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 14)
        v.text = "You will be alerted daily about"
        v.textAlignment = .center
        return v
    }()
    
    lazy var bottomDesc : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 14)
        v.text = "Send rate alert to your e-mail daily."
//        v.textAlignment = .center
        return v
    }()
    
    
    
    lazy var btn1 : CustomImageViewButton = {
        let btn = CustomImageViewButton()
        btn.label.text = "USD"
        btn.backgroundColor = Config().colors.whiteBackground
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
        btn.tag = 2
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var rateDescLabel : CustomTextFieldWithLabelTopEditable = {
        let txt = CustomTextFieldWithLabelTopEditable()
        txt.label.font = UIFont(name: Fonts.bold, size: 18)
        txt.textField.font = UIFont(name: Fonts.regular, size: 16)
        txt.label.text = ""
        txt.textField.placeholder = ""
        txt.label.textColor = Config().colors.blueBgColor
        txt.textField.keyboardType = .numberPad
        return txt
    }()
    
    
    lazy var checkBoxView : CustomCheckBoxViewWithLabel = {
        let v = CustomCheckBoxViewWithLabel()
        v.label.text = "Send rate alert to my email"
        return v
    }()
    
    
    lazy var submitBtn : CustomButtonBottom = {
        let btn = CustomButtonBottom()
        btn.btn.setTitle("Save alert", for: .normal)
        btn.btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.btn.backgroundColor = Config().colors.blueBgColor
        btn.btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 18)
        btn.btn.addTarget(self, action: #selector(submitAlert), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        txt2.textField.delegate = self
        setUpView()
        hidesKeyboardOnTapArround()
        
        if let data = self.viewModel?.getComparedDataFromLocal() {
            saveCompared = data
        }
        
//        updateGraph()
        setUpListener()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(" Rate Alert", for: .normal)
        backButton.titleLabel?.font = UIFont(name: Fonts.bold, size: 20)
        backButton.sizeToFit()
        backButton.tintColor = Config().colors.whiteBackground
        backButton.titleLabel?.textColor = Config().colors.whiteBackground
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        if let data = currentAlertData {
            let b1 = UIBarButtonItem(image: UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(deleteCurrency))
            b1.tintColor = Config().colors.whiteBackground
            
            self.navigationItem.rightBarButtonItem = b1
        }
    }
    
    
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteCurrency() {
        let alert = self.alertWithActions("Delete", "Cancel", "Are you sure you want to delete this alert?", "", actionOk: { (action) in
            if let user = self.usersData, let currentData = self.currentAlertData {
                self.isDeleted = true
                self.viewModel?.deleteRateAlert(param: ["uid": user.id,"id": currentData.id,"api_token" : user.token])
            }
        }) { (cancel) in
            
        }
        
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func setUpView() {
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        btn1.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        btn2.addGestureRecognizer(tap4)
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
//        view.addSubview(checkBoxView)
//        checkBoxView.snp.makeConstraints { (make) in
//            make.height.equalTo(40)
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
//            make.bottom.equalTo(submitBtn.snp.top)
//        }
        
        view.addSubview(bottomDesc)
        bottomDesc.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.bottom.equalTo(submitBtn.snp.top)
        }
        
        view.addSubview(rateDescLabel)
        rateDescLabel.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.bottom.equalTo(bottomDesc.snp.top).offset(-10)
        }
        
        view.addSubview(btnView)
//        btnView.snp.makeConstraints { (make) in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(view)
//            make.trailing.equalTo(view)
//            make.height.equalTo(100)
//        }
//
//        view.addSubview(txt1)
//        txt1.snp.makeConstraints { (make) in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            make.leading.equalTo(view).offset(40)
//            make.width.equalTo(view.frame.width / 3)
//            make.height.equalTo(60)
//        }
//
//        view.addSubview(equals)
//        equals.snp.makeConstraints { (make) in
//            make.width.equalTo(20)
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
//            make.centerX.equalTo(view)
//            make.height.equalTo(20)
//        }
//
//        view.addSubview(txt2)
//        txt2.snp.makeConstraints { (make) in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            make.trailing.equalTo(view).offset(-40)
//            make.width.equalTo(view.frame.width / 3)
//            make.height.equalTo(60)
//        }
        
        view.addSubview(topDesc)
        topDesc.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        view.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(topDesc.snp.bottom).offset(10)
//            make.top.equalTo(txt1.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(40)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(60)
        }
        
        view.addSubview(arrow)
        arrow.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.top.equalTo(topDesc.snp.bottom).offset(30)
//            make.top.equalTo(txt1.snp.bottom).offset(30)
            make.centerX.equalTo(view)
            make.height.equalTo(20)
        }
        
        view.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
             make.top.equalTo(topDesc.snp.bottom).offset(10)
//            make.top.equalTo(txt2.snp.bottom).offset(10)
            make.trailing.equalTo(view).offset(-40)
            make.width.equalTo(view.frame.width / 3)
            make.height.equalTo(60)
        }
    
        view.addSubview(chartView)
        chartView.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.bottom.equalTo(rateDescLabel.snp.top).offset(-10)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendAlertAction))
        checkBoxView.imageView.addGestureRecognizer(tap)
        
    }

    @objc func sendAlertAction() {
       sendAlert = !sendAlert
    }
    
    @objc func selectCurrency(_ sender : UIGestureRecognizer) {
        let tag = sender.view?.tag
        print("CLICKING AT : \(tag)")
        var data : [CountryListArray] = [CountryListArray(country_name : self.saveCompared.base ,currency: self.saveCompared.base , rate: 0, amount:0),CountryListArray(country_name :  self.saveCompared.symbols ,currency: self.saveCompared.symbols , rate: 0, amount:0)]
        
        let controller = SelectingCurrencyViewController(data: data, vc: self)
        controller.tag = tag
        controller.navTitle = " Rate Alert"
        controller.viewModel = ConverterViewModel()
        controller.viewModel?.model = ConverterModel()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [Config().colors.blueBgColor] //Sets the colour to blue
        line1.drawCirclesEnabled = false
        line1.drawFilledEnabled = true
        line1.drawValuesEnabled = false
        
        // add high light on graph
        let ll1 = ChartLimitLine(limit: (self.alertData.last?.rate ?? 0), label: "\(String(format: "%.4f", self.alertData.last?.rate ?? 0))")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        chartView.leftAxis.addLimitLine(ll1)
        
        
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        chartView.data = data //finally - it adds the chart data to the chart and causes an update
       
        chartView.setNeedsDisplay()
        chartView.animate(xAxisDuration: 1)
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessGettingRatesHistory = { [weak self] data in
            self?.alertData = data ?? []
        }
        
        self.viewModel?.onSuccessGettingAlertList = { [weak self] data in
            self?.rateAlertData = data
        }
        
        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
                print("ERRORRRRRRRRRRR")
                self?.alert(btn: "OK", title: "", msg: error?.message ?? "Something went wrong",tag: error?.status == 1 ? 1 : nil)
            }
        }
        
        self.requestData()
    }
    
    func hideShowChart(alpha : CGFloat) {
        UIView.animate(withDuration: 1.0) {
            self.chartView.alpha = alpha
            self.chartView.layoutIfNeeded()
        }
    }
    
    func requestData() {
        self.hideShowChart(alpha: 0)
        let dateNow = Date()
        let fromDate = Calendar.current.date(byAdding: .day, value: -10, to: dateNow)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-M-dd"
        
        
        print("DATA request : \(dateFormater.string(from: dateNow)) == \(dateFormater.string(from: fromDate ?? Date()))")
        
        let base = saveCompared.base
        let symbols = saveCompared.symbols
        let param : [String:Any] = ["base": base, "symbols" : symbols, "start_at" : dateFormater.string(from:  fromDate ?? dateNow),"end_at": dateFormater.string(from: dateNow)]
        self.viewModel?.getRatesHistory(param: param)
    }
    
    
   @objc func submitAlert() {
        if let user = usersData {
            var param : [String:Any] = [:]
            if let currentData = currentAlertData {
                param = ["uid": user.id, "email" : user.email, "previous_rate" : currentData.expected_rate ,"expected_rate": Double(txt2.textField.text ?? "") ?? 0,"base_currency":self.saveCompared.base, "compare_currency": self.saveCompared.symbols,"send_to_email": sendAlert ? 1 : 0,"alert_id": currentData.id,"api_token": user.token]
            }else {
                param = ["uid": user.id, "email" : user.email, "previous_rate" : 0 ,"expected_rate": Double(txt2.textField.text ?? "") ?? 0,"base_currency":self.saveCompared.base, "compare_currency": self.saveCompared.symbols,"send_to_email": sendAlert ? 1 : 0,"api_token": user.token]
            }
            
            self.viewModel?.saveRateAlert(param: param)
        }
    }
    
    func alert(btn: String,title: String,msg: String,tag: Int? = nil) {
            let alert = self.alert(btn, title, msg) { (action) in
                if let tag = tag {
                    if tag == 1 {
                        if let vc = self.vc as? SettingsViewController {
                            print("IS DELETED : \(self.isDeleted) \( self.currentIndex)")
                            if !self.isDeleted {
                                for x in self.rateAlertData {
                                    if let curr = self.currentIndex {
                                        vc.alertsData?[curr] = x
                                    }else {
                                        vc.alertsData?.insert(x, at: 0)
                                    }
                                }
                            } else {
                                if let curr = self.currentIndex {
                                    vc.alertsData?.remove(at: curr)
                                    vc.collectionView.reloadData()
                                }
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}


extension CreateAlertViewController : ChartViewDelegate {

//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return months[Int(value) % months.count]
//    }
}


class CustomCheckBoxViewWithLabel : UIView {
    lazy var imageView : UIImageView = {
        let img = UIImageView()
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "checked_empty")?.withRenderingMode(.alwaysTemplate)
        img.isUserInteractionEnabled = true
        img.tintColor = Config().colors.grayBackground
        return img
    }()
    
    lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.regular, size: 16)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.4
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self)
            make.width.height.equalTo(20)
        }
        
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(self)
            make.top.bottom.equalTo(self)
        }
    }

}
