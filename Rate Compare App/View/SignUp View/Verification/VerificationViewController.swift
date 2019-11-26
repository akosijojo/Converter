//
//  VerificationViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/12/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//
import UIKit


class VerificationViewController : UIViewController , UITextFieldDelegate {
    // for timer
    
    var seconds: Int = 10
    var isTimerRunning = false
    var timer = Timer()
    var viewModel : LoginViewModel?
    
    var data : UsersDataList?
    
    lazy var scrollView : UIScrollView = {
        let t = UIScrollView()
        t.isScrollEnabled = true
        t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return t
    }()
    
    lazy var titleLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.bold, size: 30)
        t.text = "Verify Email"
        t.sizeToFit()
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.textAlignment = .left
        return t
    }()
    
    lazy var descLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.regular, size: 14)
        t.text = "We have sent you a 6-digit code.\nPlease view message box."
        t.sizeToFit()
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.textAlignment = .left
        t.numberOfLines = 2
        return t
    }()
    
    
    lazy var verificationTextField : UITextField = {
        let t = UITextField()
        t.placeholder = "Enter Code"
        t.keyboardType = .numberPad
        t.layer.borderWidth = 1
        t.layer.borderColor = Config().colors.borderColor.cgColor
        t.font = UIFont(name: Fonts.bold, size: 20)
        t.clearButtonMode = .whileEditing
        t.layer.cornerRadius = 5
        t.setLeftPadding(20)
        return t
    }()
    
    lazy var infoLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.medium, size: 12)
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.text = "Didn't recieve it?"
        return t
    }()
    
    lazy var resendButton : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.regular, size: 12)
        t.text = "Request new code: 00:08"
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        return t
    }()
    
    lazy var submitBtn : CustomButtonBottom = {
        let btn = CustomButtonBottom()
        btn.btn.setTitle("Submit", for: .normal)
        btn.btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.btn.backgroundColor = Config().colors.blueBgColor
        btn.btn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return btn
    }()
    
    init(data: UsersDataList) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        // Do any additional setup after loading the view, typically from a nib.
        setUpListener()
        setUpView()
        verificationTextField.delegate = self
        hidesKeyboardOnTapArround()
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessRequest =  { [weak self] status in
//            print("VERIFICATION DATA GET : \(status?.message)")
            DispatchQueue.main.async {
//                self?.hideLoading()
                self?.requestSucces()
            }
            
        }
        
        self.viewModel?.onSuccessGettingList =  { [weak self] data in
            DispatchQueue.main.async {
//                self?.hideLoading()
                self?.dismiss(animated: true, completion: {
                    self?.gotoTermsAndCondition(data: data)
                })
            }
        }
        
        self.viewModel?.onErrorHandling =  { [weak self] status in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: {
                    self?.alert(btn: "Ok", title: "", msg: status?.message ?? "Something went wrong",tag: nil)
                })
            }
        }
    }

    func gotoTermsAndCondition(data: UsersData?) {
        let controller = TermsAndConditionViewController(data: data)
        controller.viewModel = LoginViewModel()
        controller.viewModel?.model = LoginModel()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func requestSucces() {
        self.hideLoading()
        runTimer()
    }
    
    func alert(btn: String, title: String,msg: String,tag: Int? = nil) {
        DispatchQueue.main.async {
            let alert = self.alert(btn, title, msg) { (action) in
                
            }
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.runTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func whenShowKeyboard(_ notification : NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - 40 // 40 size of button
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self.scrollView.contentInset = contentInsets
            var aRect: CGRect = self.scrollView.frame
            aRect.size.height -= keyboardHeight
            if !aRect.contains(verificationTextField.frame.origin) {
                
//                verificationTextField.frame.origin.y -= 40
                
//                self.scrollView.contentInset = contentInsets
//                self.scrollView.scrollIndicatorInsets = contentInsets
//                self.scrollView.setContentOffset(CGPoint(x: 0, y: verificationTextField.frame.origin.y), animated: true)
            }
            
        }
    }
    
    @objc func whenHideKeyboard(_ notification : NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.contentInset = contentInsets
        
//        verificationTextField.frame.origin.y += 40
    }
    
    
    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = Config().colors.blackBgColor
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func setUpView() {
        view.addSubview(submitBtn)
        let bottomPadding = Config().bottomScreenInset
        submitBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(submitBtn.snp.top)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
    
        scrollView.addSubview(verificationTextField)
        verificationTextField.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(80)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(verificationTextField.snp.bottom).offset(80)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(20)
        }
        
        
        scrollView.addSubview(resendButton)
        resendButton.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(20)
            make.bottom.equalTo(scrollView)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resendVerif))
        resendButton.addGestureRecognizer(tap)
       
    }
    
    @objc func resendVerif() {
        self.showLoading()
        let param = ["email" : data?.email,"contact": data?.contact, "is_resend": 1 ] as [String : Any]
        self.viewModel?.getVerificationCode(param:param)
        self.seconds = 10
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
    }

    
    @objc func submitAction() {
        if let usersData = self.data {
            self.showLoading()
            let param = ["firstname" : usersData.firstName, "lastname" : usersData.lastName, "birthdate" : usersData.bdate, "contact" : usersData.contact,"email": usersData.email,"password": usersData.password,"code": self.verificationTextField.text ?? "" ]
            self.viewModel?.signUp(param:param )
        }
    }
 
    
    func runTimer() {
        DispatchQueue.main.async {
            self.resendButton.isUserInteractionEnabled = false
            self.resendButton.textColor = Config().colors.blackBgColor
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 0 {
            print("SETTING timer to zero")
            resendButton.text = "Resend Code"
            resendButton.textColor = Config().colors.blueBgColor
            resendButton.isUserInteractionEnabled = true
            timer.invalidate()
            
        }else{
            seconds -= 1
            resendButton.text = "Request new code: \(seconds)"
        }
    }
    
}


