//
//  AddCurrencyViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit


class AddCurrencyViewController : UIViewController {
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: Config().screenWidth - 100, height: 20))
    
    lazy var cancelButton:UIBarButtonItem = {
        let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hideSearchBar))
        b.tintColor = Config().colors.whiteBackground
        return b
    }()
   
    var data : [CountryListArray] = []
    
    var dataList : DataClassArray? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var dataListSaved : DataClassArray?
    
    var refresherTop : UIRefreshControl?
    
    var viewModel  : ConverterViewModel?
    
    var vc : UIViewController?
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = Config().colors.whiteBackground
        c.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        c.bounces = true
        return c
    }()
    
    var cellID = "cell List"

    init(data: [CountryListArray],vc: UIViewController) {
        self.data = data
        self.vc   = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpScroll()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CurrencyListCheckBoxCell.self, forCellWithReuseIdentifier: cellID)
        setUpView()
        getData()
        
//        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setUpNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let vc = vc as? CurrencyViewController {
            vc.data = self.data
            vc.collectionView.reloadData()
            
            if let  mainVc = vc.vc as? ConverterViewController {
                mainVc.data?.list = vc.data
            }
        }
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func whenShowKeyboard(_ notification : NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self.collectionView.contentInset = contentInsets
            self.collectionView.scrollIndicatorInsets = contentInsets
//            self.collectionView.snp.updateConstraints { (make) in
//                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
//            }
        }
    }
    
    @objc func whenHideKeyboard(_ notification : NSNotification) {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(" Add Currency", for: .normal)
        backButton.titleLabel?.font = UIFont(name: Fonts.bold, size: 20)
        backButton.sizeToFit()
        backButton.tintColor = Config().colors.whiteBackground
        backButton.titleLabel?.textColor = Config().colors.whiteBackground
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        let b1 = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(searchCurrency))
        b1.tintColor = Config().colors.whiteBackground
        
        self.navigationItem.rightBarButtonItem = b1
    }
    
    func setUpScroll() {
        refresherTop = UIRefreshControl()
        refresherTop?.addTarget(self, action: #selector(refreshTop), for: .valueChanged)
        collectionView.refreshControl = refresherTop
    }
    
    @objc func refreshTop() {
        self.searchBar.text = ""
        let base = self.data.count > 0 ?  self.data[0].currency : "USD"
        var param = ["base": base]
        self.viewModel?.getDataList(param: param)
    }
    
    func getData() {
        
        self.viewModel?.onSuccessGettingList = { [weak self] data in

            self?.dataList = data?.convertData()
            self?.dataListSaved = self?.dataList
            self?.stopLoading()
        }
        
        self.viewModel?.onErrorHandling = { [weak self] error in
            print("ERROR : \(error?.message)")
            if let stat = error {
                    self?.showErrorAlert(status: stat)
            }
        }
        
        
        let base = self.data.count > 0 ?  self.data[0].currency : "USD"
        var param = ["base": base]
        self.viewModel?.getDataList(param: param)
        
        
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.refresherTop?.endRefreshing()
            self.collectionView.emptyView(image: "", text: "", dataCount: self.dataList?.list.count ?? 0)
        }
    }
    
    func showErrorAlert(status: StatusList) {
        
        DispatchQueue.main.async {
            self.refresherTop?.endRefreshing()
            self.collectionView.emptyView(image: "", text: status.message, dataCount: self.dataList?.list.count ?? 0)
        }
        
//        DispatchQueue.main.async {
////            let errorAlert = self.alert("Ok", status.title, status.message, action: { (action) in
//                self.refresherTop?.endRefreshing()
//            })
//            self.present(errorAlert, animated: true, completion: nil)
//
//        }
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchCurrency() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = cancelButton
        
    }
    
    @objc func hideSearchBar() {
        self.view.endEditing(true)
        setUpNavigationBar()
//        self.searchBar.text = ""
        self.dataList = self.dataListSaved
//        self.updateEmptyView(text: "No data loaded")
    }
    
    func setUpView() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view).offset(40)
            }else {
                make.top.equalTo(view)
            }
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    deinit {
        print("DEINIT VIEW")
    }
    
    
    func alert(btn: String, title: String, msg: String) {
        let alert  = self.alert(btn, title, msg) { (action) in
            
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


extension AddCurrencyViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CurrencyListCheckBoxCell else {
            return UICollectionViewCell()
        }
        cell.checkBox.isHidden = checkData(data: dataList?.list[indexPath.row]) ? false : true
        cell.data = dataList?.list[indexPath.row]
        cell.indexPath = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DID SELECT : \(indexPath.row) \(self.data.count > 2)")
        guard let cell = collectionView.cellForItem(at: indexPath) as? CurrencyListCheckBoxCell else {
            return
        }
        
            if let data = self.dataList?.list[indexPath.row] {
                if !cell.checkBox.isHidden {
                    if self.data.count > 2 {
                        self.checkData(data: data,remove: true)
                        cell.checkBox.isHidden = true
                    }else {
                        self.alert(btn: "OK", title: "", msg: "Minimum of 2 currency")
                    }
                }else {
                    if self.data.count < 10 {
                        self.data.append(data)
                        cell.checkBox.isHidden = false
                    }else {
                        self.alert(btn: "OK", title: "", msg:  "Maximum of 10 currency")
                    }
                }
            }
        
        
    }
    
    func checkData(data: CountryListArray?,remove: Bool? = nil) -> Bool {
        var index : Int = 0
        if let d = data {
            for x in self.data {
                if d.currency == x.currency {
                    if let _ = remove {
                        self.data.remove(at: index)
                    }
                    return true
                }
                index += 1
            }
        }
        return false
    }
}


extension AddCurrencyViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
        print("Searching ")
        searchAction(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAction(searchText: searchText)
    }
    
    func searchAction (searchText: String) {
        if searchText != "" {
            var returnedArray : [CountryListArray] = []
            if let data = self.dataListSaved?.list {
                
                for searchItems in data {
                    let items = searchItems.currency.stringConvertWithoutEncoded()
                    if items.lowercased().contains(searchText.lowercased()) {
                        returnedArray.append(searchItems)
                    }else {
                        
                    }
                    
                }
                
            }
            
            self.dataList?.list = returnedArray
        }else {
            self.dataList = self.dataListSaved
        }
    }
    
    func updateEmptyView(text: String) {
//        UIView.animate(withDuration: 0.5) {
            self.collectionView.emptyView(image: "", text: text, dataCount: self.dataList?.list.count ?? 0)
//        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchAction(searchText: searchBar.text ?? "")
    }
}

