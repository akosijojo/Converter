//
//  CurrencyViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit


class CurrencyViewController : UIViewController {
    
    var data : [CountryListArray] = []
    
    weak var vc : UIViewController?
    
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CurrencyListCell.self, forCellWithReuseIdentifier: cellID)
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setTitle(" Edit Currency", for: .normal)
        backButton.titleLabel?.font = UIFont(name: Fonts.bold, size: 20)
        backButton.sizeToFit()
        backButton.tintColor = Config().colors.whiteBackground
        backButton.titleLabel?.textColor = Config().colors.whiteBackground
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton

    
        let b1 = UIBarButtonItem(image: UIImage(named: "circle_plus")?.withRenderingMode(.alwaysTemplate),style: .plain, target: self, action: #selector(addCurrency))
        b1.tintColor = Config().colors.whiteBackground
        
        self.navigationItem.rightBarButtonItem = b1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let vc = vc as? ConverterViewController {
            vc.refresh = true
            vc.data?.list = self.data
            
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addCurrency() {
        let controller = AddCurrencyViewController(data: self.data, vc: self)
        controller.viewModel = ConverterViewModel()
        controller.viewModel?.model = ConverterModel()
        self.navigationController?.pushViewController(controller, animated: true)
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
        self.data = []
        self.vc = nil
        print("DEINIT VIEW")
    }
    
    func alert(btn: String, title: String, msg: String) {
        let alert  = self.alert(btn, title, msg) { (action) in
            
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension CurrencyViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CurrencyListCellProtocol{
    
    func checkAction(cell: CurrencyListCheckBoxCell, indexPath: Int) {
        
    }
    
    func deleteAction(cell: CurrencyListCell, indexPath: Int) {
        print("DELETING AT INDEX PATH : \(indexPath)")
        if self.data.count > 2 {
            self.data.remove(at: indexPath)
            self.collectionView.deleteItems(at: [IndexPath(row: indexPath, section: 0)])
            
            for x in 0...data.count - 1 {
                guard let cell = collectionView.cellForItem(at: IndexPath(row: x, section: 0)) as? CurrencyListCell else {
                    return
                }
                
                cell.indexPath = x
                
            }
            
        }else {
            self.alert(btn: "Ok", title: "", msg: "Minimum of 2 currency")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CurrencyListCell else {
            return UICollectionViewCell()
        }
        
        cell.indexPath = indexPath.row
        cell.data = data[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count ?? 0
    }
    
}
