//
//  ConverterViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class ConverterViewController : BaseMainViewController {

    var refreshMainRate : Bool = true
    var refresh : Bool = false
    var refresherTop : UIRefreshControl?
    var onClick : Bool = false
    var data: DataClassArray? {
        didSet{
            if refresh {
                DispatchQueue.main.async {
                    //                print("RATE : \(self.data?.list[0].rate ?? 0)")
                    if let list = self.data?.list {
                        for x in  list {
                            print("DATA CHECK: \(x.country_name) == \(x.rate)")
                        }
                    }
                    
                    self.baseRate = self.data?.list[0]
                    if self.refreshMainRate {
                        self.mainRate = (self.data?.list[0].rate ?? 0.0)
                        self.refreshMainRate = false
                    }
                    
                    self.collectionView.reloadData()
                    self.headerView.descLabel.text = self.data?.date.timeIntervalToFormatedDate(format: "MMMM dd, yyyy")
                    self.saveChangesToLocal()
                    self.refresh = false
                }
            }
        }
    }
    
    lazy var headerView : CustomHeaderView = {
        let v = CustomHeaderView()
        v.titleLabel.text = "Live Exchange Rate"
        v.descLabel.text = ""
        return v
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = Config().colors.whiteBackground
        c.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        c.bounces = true
        return c
    }()
    
    var currencyBarButton =  UIBarButtonItem()
    
    var viewModel  : ConverterViewModel?
    
    var cellId = "cellId"
    
    var amount : Double = 1 {
        didSet {
            self.mainRate = (self.data?.list[0].rate ?? 0.0)
            self.collectionView.reloadData()
            UserDefaults.standard.set(amount, forKey: localArray.amountSet)
        }
    }
    
    var baseRate : CountryListArray?
    var mainRate : Double = 0.0
    
    override func viewWillDisappear(_ animated: Bool) {
        if (refresherTop?.isRefreshing ?? false ){
            refresherTop?.endRefreshing()
        }
    }
    
    override func setUpNavigationBar() {
        self.setUpTitleView(text: "Converter")
        currencyBarButton =  UIBarButtonItem(image: UIImage(named: "currency")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(currencyAction))
        currencyBarButton.tintColor = .white
        
        self.tabBarController?.navigationItem.rightBarButtonItems = [currencyBarButton]
//        defaultBarButton = UIBarButtonItem(image: UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(bellAction))
//        defaultBarButton.tintColor = Config().colors.whiteBackground
//        
//        self.tabBarController?.navigationItem.rightBarButtonItems = [defaultBarButton,currencyBarButton]
    }
    
    @objc func currencyAction() {
        let controller = CurrencyViewController(data: self.data?.list ?? [],vc: self)
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func setUpOnViewDidLoad() {
    
        self.refresh = true
        let amount = UserDefaults.standard.double(forKey: localArray.amountSet)
        self.amount = amount == 0 ? 1 : amount
        
        if let dataLocal =  self.viewModel?.getDataFromLocal() {
            self.data = dataLocal.convertData()
        }
        
        setUpScroll()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ConverterCell.self, forCellWithReuseIdentifier: cellId)
        getData()
    }
    
    
    override func setUpView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-40)
            }else {
                make.top.equalTo(view)
            }
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(60)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(view).offset(-40)
//            }else {
            make.top.equalTo(headerView.snp.bottom)
//            }
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func checkData(data: DataClassArray?) {
        
        if self.data == nil {
            self.data = data
        }else {
            self.data?.date = data?.date ?? Int(Date().timeIntervalSince1970)
            if let list = data?.list {
                for x in  list {
                    let index = self.data?.list.index(where: { (result) -> Bool in
                        return result.currency == x.currency
                    })
                    print("CHECK INDEX OF DATA : \(index) == \(x.country_name) == \(x.rate)")
                    if index != nil {
                        self.data?.list[index!].rate = x.rate
                    }else {
                        self.data?.list.append(x)
                    }
                    
                }
            }
            print("DATA : \(self.data?.list.count)")
        }
    
    }
    
    func getData() {
        self.refresherTop?.beginRefreshing()
        self.viewModel?.onSuccessGettingList = { [weak self] data in
//            print("DATA GET : \(da ta?.list.count)")
            self?.refresh = true
            self?.checkData(data: data?.convertData())
            self?.stopLoading()
            
        }
        
        self.viewModel?.onErrorHandling = { [weak self] error in
            print("ERROR : \(error?.message)")
            
            if let stat = error {
                self?.showErrorAlert(status: stat)
            }
//            self?.stopLoading()
        }
        
        var param = setUpParameters()

        self.viewModel?.getDataList(param: param)
    
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.refresherTop?.endRefreshing()
        }
    }
    
    func showErrorAlert(status: StatusList) {
        
        DispatchQueue.main.async {
//            let errorAlert = self.alert("Ok", status.title, status.message, action: { (action) in
            
                self.refresherTop?.endRefreshing()
                self.collectionView.emptyView(image: "", text: status.message, dataCount: self.data?.list.count ?? 0)
                
//            })
//            self.present(errorAlert, animated: true, completion: nil)
            
        }
        
    }
    
    func setUpScroll() {
        refresherTop = UIRefreshControl()
        refresherTop?.addTarget(self, action: #selector(refreshTop), for: .valueChanged)
        collectionView.refreshControl = refresherTop
    }
    
    @objc func refreshTop() {
        var param = setUpParameters()
        self.viewModel?.getDataList(param: param)
    }
    
    func setUpParameters() -> [String:Any] {
        var param : [String:Any] = ["base": "CAD","symbols": "CAD,EUR,USD,GBP"]
        var listCurrency : String = ""
        if let list = self.data?.list {
            for x in list {
                if listCurrency == "" {
                    listCurrency = "\(x.currency)"
                }else {
                    listCurrency = "\(listCurrency),\(x.currency)"
                }
            }
            
            if list[0].currency == "EUR" {
                listCurrency = listCurrency.replacingOccurrences(of: "EUR,", with: "")
            }
            
            param = ["base" : list[0].currency , "symbols": listCurrency,"euro_handling" : list[0].currency == "EUR" ? 1 : 0]
        
        }
        print("GETTING PARAMETERS")
        return param
    }
    
    func saveChangesToLocal() {
        self.viewModel?.model?.saveToLocal(data: self.data?.convertData())
    }
    
    func calculateAmount(data: Double) -> Double {
        let totalRate = mainRate / data
        let amountConvert = amount / totalRate
        return amountConvert
    }
}



extension ConverterViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ConverterCellProtocol {
    func conCLickCalculator(cell: ConverterCell) {
        let controller = CalculatorViewController(img:  cell.countryImage.image, name: cell.countryName.text, currency: cell.countryCurrency.text,vc: self,amount: cell.amount)
        tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ConverterCell else {
            return UICollectionViewCell()
        }
        
        data?.list[indexPath.row].amount = calculateAmount(data: (data?.list[indexPath.row].rate ?? 0.0))

        cell.delegate = self
        cell.baseRate = self.baseRate
        cell.data = data?.list[indexPath.row]
        cell.index = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onClick = true
        let data = self.data?.list[indexPath.row]
        self.data?.list.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
        self.data?.list.insert(data!, at: 0)
        self.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        let  dataCount = self.data?.list.count ?? 0
//
        for x in 0...dataCount - 1 {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: x, section: 0)) as? ConverterCell else {
                return
            }
                if x == 0 {
                    cell.index = x
//                    self.collectionView.reloadData()
                }else {
                    cell.index = x
//                    cell.amount = self.amount
                    cell.baseRate = self.data?.list[0]
                    cell.data = self.data?.list[x]
                }

        }
//
        
      
    }
    
}

class CustomHeaderView : UIView {
    lazy var titleLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.bold, size: 18)
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor  = 0.2
        v.textColor = Config().colors.blackBgColor
        return v
    }()
    
    lazy var descLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Fonts.regular, size: 14)
        v.adjustsFontSizeToFitWidth = true
        v.minimumScaleFactor  = 0.2
        v.textColor = Config().colors.blackBgColor
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpView()  {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(20)
        }
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(20)
        }
    }
    
}
