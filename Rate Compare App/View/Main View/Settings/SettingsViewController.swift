//
//  SettingsViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

struct RatesDataArray: Codable {
    var value: [RatesData]
}

struct RatesData : Codable {
    let date: Int
    let rate: Double
}

struct MarketAnalysisData : Codable {
    let title : String
    let description: String
    let url: String
    let image: String?
    let publishedAt: String
    let source: Source
}

struct Source : Codable{
    let name: String
    let url: String
}

class SettingsViewController: BaseMainViewController {

    var viewModel : ConverterViewModel?
    
    var offset : Int = 0
    
    var alertsData : [AlertDataList]? {
        didSet{
            DispatchQueue.main.async {
                print("ALERT DATA COUNT : \(self.alertsData?.count)")
                self.collectionView.reloadData()
            }
        }
    }
    
    var marketAnalysisData : [MarketAnalysisData]? {
        didSet{
            DispatchQueue.main.async {
                print("marketAnalysisData DATA COUNT : \(self.marketAnalysisData?.count)")
                self.collectionView.reloadData()
            }
        }
    }
    
    var usersData : UsersData?
    
    lazy var btn1 : CustomButtonView = {
        let btn = CustomButtonView()
        btn.button.setTitle("Rate Alerts", for: .normal)
        btn.button.titleLabel?.font = UIFont(name: Fonts.bold, size: 14)
        btn.button.backgroundColor = Config().colors.lightGraybackground
        btn.button.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
        return btn
    }()
    
    lazy var btn2 : CustomButtonView = {
        let btn = CustomButtonView()
        btn.button.setTitle("Market Analysis", for: .normal)
        btn.button.backgroundColor = Config().colors.whiteBackground
        btn.button.addTarget(self, action: #selector(btn2Action), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.bounces = false
        col.isPagingEnabled = true
        col.backgroundColor = Config().colors.whiteBackground
        col.showsHorizontalScrollIndicator = false
        return col
    }()
    
    let cellId = "cell id"
    let headerId = "Header id"
    override func setUpOnViewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingsBodyCell.self, forCellWithReuseIdentifier: cellId)
        self.usersData = self.viewModel?.getUsersDataFromLocal()
        setUpListener()
    }
    
    override func setUpNavigationBar() {
        setUpTitleView(text: "Settings")
        defaultBarButton = UIBarButtonItem(image: UIImage(named: "logout")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(logoutAction))
        defaultBarButton.tintColor = Config().colors.whiteBackground
        //        currencyBarButton.image: UIImage(named: "currency")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(currencyAction)
        self.tabBarController?.navigationItem.rightBarButtonItems = [defaultBarButton]
    }
    
    override func setUpView() {
        view.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-30)
            }else {
                make.top.equalTo(view)
            }
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        view.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-30)
            }else {
                make.top.equalTo(view)
            }
            make.leading.equalTo(btn1.snp.trailing).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(btn1.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
    }
    
    
    @objc func btn1Action() {
        
        if  self.btn1.button.backgroundColor == Config().colors.lightGraybackground {
            self.btn2.button.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
            self.btn2.button.backgroundColor = Config().colors.whiteBackground
        }else {
            self.btn1.button.titleLabel?.font = UIFont(name: Fonts.bold, size: 14)
            self.btn1.button.backgroundColor = Config().colors.lightGraybackground
            self.btn2.button.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
            self.btn2.button.backgroundColor = Config().colors.whiteBackground
        }
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
    
    @objc func btn2Action() {
        if  self.btn2.button.backgroundColor == Config().colors.lightGraybackground {
            self.btn1.button.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
            self.btn1.button.backgroundColor = Config().colors.whiteBackground
        }else {
            self.btn2.button.titleLabel?.font = UIFont(name: Fonts.bold, size: 14)
            self.btn2.button.backgroundColor = Config().colors.lightGraybackground
            self.btn1.button.titleLabel?.font = UIFont(name: Fonts.regular, size: 14)
            self.btn1.button.backgroundColor = Config().colors.whiteBackground
        }
        
        self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: true)
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessGettingAlertList = { [weak self] data in
            self?.checkData(data: data)
        }
        
        self.viewModel?.onSuccessGettingNewsList = { [weak self] data in
            self?.marketAnalysisData = data
        }

        self.viewModel?.onErrorHandling = { [weak self] error in
            DispatchQueue.main.async {
//                self?.alert(btn: "OK", title: "", msg: error?.message ?? "Something went wrong")
            }
        }
 
        self.requestData()
    }
    
    func checkData(data : [AlertDataList]){
        var dataReturned : [AlertDataList] = self.alertsData ?? []
        for x in data {
            let index = self.alertsData?.index(where: { (result) -> Bool in
                return result.id == x.id
            })
            print("CHECK INDEX OF DATA ")
            if index != nil {
//                self.alertsData?[index!] = x
                dataReturned[index!] = x
            }else {
//                self.alertsData?.append(x)
                dataReturned.append(x)
            }
        }
        
        self.alertsData = dataReturned
        
    }
    
    func requestData() {
        if let user = usersData {
            self.requestAlerts(userData: user,offset: offset)
            self.requestNews(userData: user)
        }
    }
    
    func requestAlerts(userData : UsersData,offset: Int) {
        let param : [String:Any] = ["uid": userData.id,"offset": offset,"api_token": userData.token]
        self.viewModel?.getAlertList(param: param)
    }
    
    func requestNews(userData : UsersData) {
        let paramNews : [String:Any] = ["api_token": userData.token]
        self.viewModel?.getDataNewsList(param: paramNews)
    }
    func alert(btn: String,title: String,msg: String) {
        if self.viewIfLoaded?.window != nil {
            let alert = self.alert(btn, title, msg) { (action) in
                self.collectionView.reloadData()
            }
            //        self.present(alert, animated: true, completion: nil)
            self.navigationController?.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func logoutAction() {
        let alert = self.alertWithActions("Logout", "Cancel", "Are you sure do you want to logout ?", "", actionOk: { (action) in
            self.viewModel?.removeUsersData()
            
            let controller = LoginViewController()
            controller.viewModel = LoginViewModel()
            controller.viewModel?.model = LoginModel()
            let navigationController = UINavigationController(
                rootViewController:controller
            )
            navigationController.navigationBar.barTintColor = Config().colors.whiteBackground
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            
            self.present(navigationController, animated: true, completion: {
                self.tabBarController?.view.removeFromSuperview()
            })
            
        }) { (cancelAct) in
            
        }
        
       self.navigationController?.present(alert, animated: true, completion: nil)
        
    }
}

extension SettingsViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SettingsBodyCellDelegate {
    func refreshAlert(cell: SettingsBodyCell, offset: Int) {
        if let user = usersData {
            if offset == 0 {
                self.offset = 0
            }else {
                self.offset += 1
            }
            self.requestAlerts(userData: user, offset: self.offset)
        }
//        let data = cell.data
//        cell.data?.append(contentsOf: data!)
    }
    
    func refreshNewsTop(cell: SettingsBodyCell) {
        if let user = usersData {
            self.requestNews(userData: user)
        }
    }
    
    
    func headerButtonAction(cell: SettingsBodyCell) {
        let controller = CreateAlertViewController()
        controller.viewModel = ConverterViewModel()
        controller.viewModel?.model = ConverterModel()
        controller.usersData = self.usersData
        controller.vc = self
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onClickNews(cell: SettingsBodyCell,url: String) {
        
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        
    }
    
    func onClickRate(cell: SettingsBodyCell,index: Int) {
        let controller = CreateAlertViewController()
        controller.viewModel = ConverterViewModel()
        controller.viewModel?.model = ConverterModel()
        controller.usersData = self.usersData
        controller.currentAlertData = self.alertsData?[index]
        controller.currentIndex = index
        controller.vc = self
        self.tabBarController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SettingsBodyCell else {
            return UICollectionViewCell()
        }
        print("CELL INDEXPATH : \(indexPath.section)")
        cell.indexPath = indexPath.item
        cell.delegate = self
        cell.hideButton(show: indexPath.row == 0 ? true : false)
        cell.data = self.alertsData
        cell.marketData = self.marketAnalysisData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
   
//
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? SettingsHeaderCell else {
//                return UICollectionReusableView()
//            }
//            return cell
//        default:
//            return UICollectionReusableView()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: self.collectionView.frame.width, height: 130)
//    }
//
    


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("COLLECTION STOP SCROLLING  HAHHAH")
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            print(indexPath?.item)
            if indexPath?.item == 0 {
                btn1Action()
            }else {
                 btn2Action()
            }
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("COLLECTION STOP SCROLLING ")
    }
    
}
