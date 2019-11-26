//
//  SettingsCell.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/20/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import FlagKit


class SettingsHeaderCell: UICollectionViewCell {
    
    lazy var mainView : UIView = {
        let v = UIView()
        return v
    }()
  
    lazy var titlelabel : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 18)
        lbl.text = "Rate Alerts"
        return lbl
    }()
    
    lazy var descLabel : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "Create your rate alert for your prefered currency pairs. We'll monitor the market so you don't have to."
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var headerButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Create rate alert", for: .normal)
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.backgroundColor = Config().colors.whiteBackground
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Config().colors.blueBgColor.cgColor
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
        
        mainView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titlelabel.snp.bottom).offset(10)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(40)
        }
        
        mainView.addSubview(headerButton)
        headerButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(30)
        }
        
    }
    
    
    
}


class SettingsCell: BaseCell<AlertDataList> {
    
    override var data: AlertDataList? {
        didSet{
            let regionCode = data?.base_currency.getRegionCode()
            let flag = Flag(countryCode: regionCode ?? "")!
            let originalImage = flag.originalImage
            self.countryImage.image = originalImage
            self.countryName.text = "1 \(data?.base_currency ?? "") = \(String(format: "%.4f", (data?.expected_rate ?? 0.0))) \(data?.compare_currency ?? "")"
            self.countryCurrency.text = "1 \(data?.base_currency ?? "") = \(String(format: "%.4f", (data?.current_rate ?? 0.0))) \(data?.compare_currency ?? "") Mid-market rate"
            
        }
    }
    
    
    var indexPath : Int = 0
    
    var delegate : CurrencyListCellProtocol?
    
    lazy var mainView : UIView = {
        let v = UIView()
        return v
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.hidesWhenStopped = true
        a.color = .green
        return a
    }()
    
    lazy var countryImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        
        img.layer.masksToBounds = true
//        img.image = UIImage(named: "google_red")
        return img
    }()
    
    lazy var countryName : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 18)
        lbl.text = "USD"
        return lbl
    }()
    
    lazy var countryCurrency : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "US Dollar"
        return lbl
    }()
    
    override func setupView() {
        
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = Config().colors.blueBgColor.cgColor
        mainView.layer.cornerRadius = 10
        
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-5)
        }
        
        mainView.addSubview(countryImage)
        countryImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(mainView)
            make.leading.equalTo(mainView).offset(10)
            make.width.equalTo(self.frame.height - 20)
            make.height.equalTo(self.frame.height - 20 )
        }
        
        countryImage.layer.cornerRadius = (self.frame.height - 20) / 2
        
        mainView.addSubview(countryName)
        countryName.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(20)
            make.leading.equalTo(countryImage.snp.trailing).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(countryCurrency)
        countryCurrency.snp.makeConstraints { (make) in
            make.top.equalTo(countryName.snp.bottom)
            make.leading.equalTo(countryImage.snp.trailing).offset(10)
            make.trailing.equalTo(mainView).offset(-10)
            make.height.equalTo(20)
        }
        
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.width.equalTo(40)
        }
    }
    
    
    
}



class MarketAnalysisCell: BaseCell<MarketAnalysisData> {
    override var data: MarketAnalysisData? {
        didSet {
            self.titleLabel.text = data?.title
            self.descLabel.text = data?.publishedAt
        }
    }
    
    
    var titleHeight : CGFloat = 0 {
        didSet {
            print("CALUE OF IT : \(self.titleHeight)")
            self.titleLabel.snp.updateConstraints( { (make) in
                make.height.equalTo(self.titleHeight)
            })
        }
    }
    lazy var mainView : UIView = {
        let v = UIView()
        v.layer.borderColor = Config().colors.borderColor.cgColor
        v.layer.borderWidth = 1
//        v.layer.shadowRadius = 4
//        v.layer.shadowColor = Config().colors.greenBgColor.cgColor
//        v.layer.shadowOpacity = 1
//        v.layer.shadowOffset = CGSize(width: 0, height: 10)
        return v
    }()
    
    lazy var titleLabel : UILabel = {
        let lbl = UILabel()
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 18)
//        lbl.text = "Create your rate alert for your prefered currency pairs. We'll monitor the market so you don't have to."
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var descLabel : UILabel = {
        let lbl = UILabel()
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 16)
//        lbl.text = "Create your rate alert for your prefered currency pairs. We'll monitor the market so you don't have to."
        lbl.numberOfLines = 3
        return lbl
    }()
    
    override func setupView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 2 
        
        // set the cornerRadius of the containerView's layer
        mainView.layer.cornerRadius = 10
        
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 5
//        mainView.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-10)
        }
        
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainView).offset(20)
            make.leading.equalTo(mainView).offset(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.height.equalTo(titleHeight)
        }
        
        mainView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(mainView).offset(20)
            make.trailing.equalTo(mainView).offset(-20)
            make.bottom.equalTo(mainView).offset(-20)
        }
        
    }
    
    func calculateHeightOfText(text: String,font: UIFont? ,width: CGFloat) -> CGFloat {
        let height = text.height(withConstrainedWidth: width, font: font ?? UIFont.systemFont(ofSize: 18))
        return height
    }

    
}

protocol SettingsBodyCellDelegate : class {
    func headerButtonAction(cell: SettingsBodyCell)
    func onClickNews(cell: SettingsBodyCell,url: String)
    func onClickRate(cell: SettingsBodyCell,index: Int)
    func refreshAlert(cell: SettingsBodyCell,offset: Int)
    func refreshNewsTop(cell: SettingsBodyCell)
}

class SettingsBodyCell: BaseCell<[AlertDataList]> ,UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.indexPath == 0  ? data?.count ?? 0 : marketData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if self.indexPath == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SettingsCell else {
                    return UICollectionViewCell()
                }
                cell.data = data?[indexPath.row]
//                if indexPath.row == ((data?.count ?? 0) - 1) && (data?.count ?? 0) >= 10 {
//                    print("LOADING ")
////                    if let data = self.data {
////                        self.data?.append(data[0])
////                    }
//
//                // show loading bottom
//                   self.isLoading = 1
//                   self.loadingViewAction(show: true)
//                }
                
                return cell
            }else {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as? MarketAnalysisCell else {
                    return UICollectionViewCell()
                }
                cell.data = marketData?[indexPath.row]
                cell.titleHeight = self.calculateHeightOfText(text: self.marketData?[indexPath.row].title ?? "", font: UIFont(name: Fonts.bold, size: 18), width: self.collectionView.frame.width - 80)
                
//                if indexPath.row == ((data?.count ?? 0) - 1) {
//                    print("LOADING ")
//                    self.isLoading = 2
//                    self.loadingViewAction(show: true)
//                }
                return cell
            }
        
//        return UICollectionViewCell()
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.indexPath == 0 {
            return CGSize(width: self.collectionView.frame.width, height: 90)
        }else {
            let heightTitle = self.calculateHeightOfText(text: self.marketData?[indexPath.row].title ?? "", font: UIFont(name: Fonts.bold, size: 18), width: self.collectionView.frame.width - 80)
            let heightDesc = self.calculateHeightOfText(text: self.marketData?[indexPath.row].publishedAt ?? "", font: UIFont(name: Fonts.regular, size: 16), width: self.collectionView.frame.width - 80)
            
            return CGSize(width: self.collectionView.frame.width, height: heightTitle + heightDesc + 70)
        }
    }
//    self.collectionView.frame.width - 80
    func calculateHeightOfText(text: String,font: UIFont? ,width: CGFloat) -> CGFloat {
        let height = text.height(withConstrainedWidth: width, font: font ?? UIFont.systemFont(ofSize: 18))
        return height
    }
    
    func loadingViewAction(show: Bool) {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: show ? 40 : 0, right: 0)
        if show {
            if !self.activityIndicator.isAnimating {
                self.activityIndicator.startAnimating()
                if isLoading == 1 {
                    self.delegate?.refreshAlert(cell: self, offset:1)
                }
            }
            
        }else {
            if isLoading == 1 {
                self.offset += 1
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if self.indexPath == 0 {
            self.delegate?.onClickRate(cell: self, index: indexPath.row)
         }else {
            self.delegate?.onClickNews(cell: self,url: marketData?[indexPath.row].url ?? "")
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.indexPath == 0 {
            if self.isLastCellVisible && !(self.activityIndicator.isAnimating) {
                self.isLoading = 1
                self.loadingViewAction(show: true)
            }
        }
    }
    
    
    var offset : Int = 0
    var refresherTop : UIRefreshControl?
    var refresherBottom : UIRefreshControl?
    
    override var data: [AlertDataList]? {
        didSet{
//            if isLoading == 1 {
            if (self.refresherTop?.isRefreshing ?? false) {
                self.refresherTop?.endRefreshing()
            }
            self.loadingViewAction(show: false)
//            }
            self.collectionView.reloadData()
        }
    }
    
    var isLoading : Int = 0
    
    var marketData: [MarketAnalysisData]? {
        didSet{
            if (self.refresherTop?.isRefreshing ?? false) {
                self.refresherTop?.endRefreshing()
            }
//            if isLoading == 2 {
//                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                self.activityIndicator.stopAnimating()
//            }
            
            self.loadingViewAction(show: false)
            self.collectionView.reloadData()
        }
    }
    
    var delegate : SettingsBodyCellDelegate?
    
    let cellId = "Cell ID"
    let cellId2 = "Cell ID2"
    
    var indexPath : Int = 0{
        didSet {
            print("SECTION : \(self.indexPath)")
            self.collectionView.reloadData()
        }
    }
    
    var isLastCellVisible: Bool {
        
        if (self.data?.count ?? 0)  > 9 {
//            if( self.data?.isEmpty ?? false) {
//                return true
//            }
            
            let lastIndexPath =  IndexPath(item: (self.data?.count ?? 0) - 1, section: 0)
            
            var cellFrame = self.collectionView.layoutAttributesForItem(at: lastIndexPath)!.frame
            
            cellFrame.size.height = cellFrame.size.height
            
            var cellRect = self.collectionView.convert(cellFrame, to: self.collectionView.superview)
            
            cellRect.origin.y = cellRect.origin.y - cellFrame.size.height - 100
            // substract 100 to make the "visible" area of a cell bigger
            
            var visibleRect =  CGRect(x: self.collectionView.bounds.origin.x, y: self.collectionView.bounds.origin.y, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height - self.collectionView.contentInset.bottom)
            
            visibleRect = self.collectionView.convert(visibleRect, to: self.collectionView.superview)
            
            if visibleRect.contains(cellRect) {
                return true
            }
            
            return false
        }else {
            return false
            
        }
       
    }
    
    let activityIndicator : UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.hidesWhenStopped = true
        a.color = .gray
        return a
    }()
    
    lazy var mainView : UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var titlelabel : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.bold, size: 18)
        lbl.text = "Rate Alerts"
        return lbl
    }()
    
    lazy var descLabel : UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.text = "Create your rate alert for your prefered currency pairs. We'll monitor the market so you don't have to."
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var headerButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Create rate alert", for: .normal)
        btn.setTitleColor(Config().colors.blueBgColor, for: .normal)
        btn.backgroundColor = Config().colors.whiteBackground
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Config().colors.blueBgColor.cgColor
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        col.bounces = false
        col.isPagingEnabled = true
        col.backgroundColor = Config().colors.whiteBackground
        return col
    }()
    
    override func setupView() {
        setUpScroll()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MarketAnalysisCell.self, forCellWithReuseIdentifier: cellId2)
        
        self.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self)
        }
        
        mainView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { (make) in
            make.top.equalTo(mainView)
            make.leading.equalTo(mainView)
            make.trailing.equalTo(mainView)
            make.height.equalTo(20)
        }
        
        mainView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titlelabel.snp.bottom).offset(10)
            make.leading.equalTo(mainView)
            make.trailing.equalTo(mainView)
            make.height.equalTo(40)
        }
        
        mainView.addSubview(headerButton)
        headerButton.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.leading.equalTo(mainView)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        mainView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerButton.snp.bottom).offset(20)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(mainView)
        }
        
        mainView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainView)
            make.width.height.equalTo(40)
            make.centerX.equalTo(mainView)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerButtonAction))
        headerButton.addGestureRecognizer(tap)
    }
    
    @objc func headerButtonAction() {
        self.delegate?.headerButtonAction(cell: self)
    }
    
    func hideButton(show: Bool) {
        headerButton.snp.updateConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(show ? 10 : 0)
            make.height.equalTo(show ? 30 : 0)
        }
        headerButton.isHidden = show ? false : true
    }
    
    func setUpScroll() {
        refresherTop = UIRefreshControl()
        refresherTop?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        refresherTop?.addTarget(self, action: #selector(refreshTop), for: .valueChanged)
        collectionView.refreshControl = refresherTop
    }
//
    @objc func refreshTop() {
        print("REFRESHING TOP")
        if indexPath == 0 {
            self.delegate?.refreshAlert(cell: self, offset: 0)
        }else {
            self.delegate?.refreshNewsTop(cell: self)
        }
        
    }
    
    @objc func refresBottom() {
        print("REFRESHING BOTTOM")
    }
    
}
