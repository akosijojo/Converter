//
//  SignUpViewContoroller.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/10/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class SignUpViewController : UIViewController {
    var isShow : Bool = false
    var viewModel : LoginViewModel?
    lazy var scrollView : UIScrollView = {
        let t = UIScrollView()
        t.isScrollEnabled = true
        return t
    }()
    
    var activeView : UITextField?
    
    lazy var titleLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.bold, size: 30)
        t.text = "Create an account"
        t.sizeToFit()
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.textAlignment = .left
        return t
    }()
    
    lazy var descLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.regular, size: 14)
        t.text = "Fill up the following fields to proceed."
        t.sizeToFit()
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.textAlignment = .left
        return t
    }()
    
    lazy var fNameTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.label.text = "Firstname"
        t.textField.placeholder = "Enter Firstname"
        return t
    }()
    
    lazy var lNameTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.label.text = "Lastname"
        t.textField.placeholder = "Enter Lastname"
        return t
    }()
    
    lazy var bDateTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.label.text = "Birthdate"
        t.textField.placeholder = "0000-00-00"
        return t
    }()
    
    lazy var ageTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.textField.isEnabled = false
        t.label.text = "Age"
        t.textField.placeholder = "0"
        return t
    }()
    
    lazy var contactNumberTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.label.text = "Contact Number"
        t.textField.placeholder = "Enter Contact Number"
        t.textField.keyboardType = .numberPad
        
        return t
    }()
    
    lazy var emailTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.label.text = "E-mail"
        t.textField.autocapitalizationType = .none
        t.textField.placeholder = "Enter E-mail Address"
        t.textField.keyboardType = .emailAddress
        return t
    }()
    
    lazy var passTextField : CustomTextFieldWithLabel = {
        let t = CustomTextFieldWithLabel()
        t.textField.isSecureTextEntry = true
        t.label.text = "Password"
        t.textField.placeholder = "Enter Password"
        t.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
        t.imageViewR.tintColor = Config().colors.grayBackground
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
    
    var datePicker : UIDatePicker?
    var textFieldHeight : CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        setUpView()
        
        fNameTextField.textField.delegate = self
        fNameTextField.textField.tag = 0
        lNameTextField.textField.delegate = self
        lNameTextField.textField.tag = 1
        bDateTextField.textField.delegate = self
        bDateTextField.textField.tag = 2
        contactNumberTextField.textField.delegate = self
        contactNumberTextField.textField.tag = 3
        emailTextField.textField.delegate = self
        emailTextField.textField.tag = 4
        passTextField.textField.delegate = self
        passTextField.textField.tag = 5
        
        hidesKeyboardOnTapArround()
        setUpDatePicker()
        
        setUpListener()
       
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessRequest =  { [weak self] status in
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.gotoVerification()
            }
        }
        
        self.viewModel?.onErrorHandling =  { [weak self] status in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: {
                    self?.alert(btn: "Ok", title: "", msg: status?.message ?? "Something went wrong")
                })
                
            }
        }
    }
    
    func gotoVerification() {
        let controller = VerificationViewController(data: UsersDataList(firstName: self.fNameTextField.textField.text ?? "", lastName: self.lNameTextField.textField.text ?? "", bdate: self.bDateTextField.textField.text ?? "",age: self.ageTextField.textField.text ?? "", contact: self.contactNumberTextField.textField.text ?? "", email: self.emailTextField.textField.text ?? "", password: self.passTextField.textField.text ?? ""))
        controller.viewModel = LoginViewModel()
        controller.viewModel?.model = LoginModel()
        self.navigationController?.pushViewController(controller, animated: true)
    }
        
    
    func setUpDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        datePicker?.addTarget(self, action: #selector(dateSelected(_:)), for: .valueChanged)
        
        bDateTextField.textField.inputView = datePicker
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
        
        bDateTextField.textField.inputAccessoryView = toolBar
        bDateTextField.textField.addTarget(self, action: #selector(isValidDate), for: .editingDidEnd)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUpNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

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
            
            self.scrollView.isScrollEnabled = true
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            var aRect: CGRect = self.scrollView.frame
            aRect.size.height -= keyboardHeight
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
          
            let maxScrollHeight: CGFloat = self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom
            
            if fNameTextField.textField.isFirstResponder {
                if !aRect.contains(fNameTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: maxScrollHeight - (textFieldHeight * 5 + 50)), animated: true)
                }
            }else if lNameTextField.textField.isFirstResponder {
                if !aRect.contains(lNameTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: maxScrollHeight - (textFieldHeight * 4 + 40)), animated: true)
                }
            }else if bDateTextField.textField.isFirstResponder {
                if !aRect.contains(bDateTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y:maxScrollHeight - (textFieldHeight * 3 + 30)), animated: true)
                }
            }else if contactNumberTextField.textField.isFirstResponder {
                if !aRect.contains(contactNumberTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: maxScrollHeight - (textFieldHeight * 2 + 20)), animated: true)
                }
            }else if emailTextField.textField.isFirstResponder {
                if !aRect.contains(emailTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: maxScrollHeight - (textFieldHeight + 10)), animated: true)
                }
            }else if passTextField.textField.isFirstResponder {
                if !aRect.contains(passTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: maxScrollHeight), animated: true)
                }
            }else {
                
            }
            
        }
    }
    
    @objc func whenHideKeyboard(_ notification : NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setUpNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = Config().colors.blackBgColor
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftButton = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func submitAction() {
        
        if checkEmptyTextField() {
            self.alert(btn: "OK", title: "", msg: "All fields are required")
        }else {
            let numberCheck = checkContactNumber()
            let validEmail = (emailTextField.textField.text?.isValidEmail ?? false )
            if  numberCheck && validEmail {
                
                self.showLoading()
                self.viewModel?.getVerificationCode(param: ["email" : self.emailTextField.textField.text ?? "","contact":self.contactNumberTextField.textField.text ?? "" , "is_resend": 0 ])
//
            }else {
                self.alert(btn: "OK", title: "", msg:  !validEmail ? "Invalid email address" : "Invalid contact number" )
            }
            
        }
        
        
    }
    
    func alert(btn: String,title: String,msg: String) {
        let alert = self.alert(btn, title, msg) { (action) in
            
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpView() {
        view.addSubview(submitBtn)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(fNameTextField)
        fNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(textFieldHeight)
        }
        
        scrollView.addSubview(lNameTextField)
        lNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(fNameTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(textFieldHeight)
        }
        
        scrollView.addSubview(bDateTextField)
        bDateTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lNameTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.width.equalTo((Config().screenWidth - 100) - 50) // 50 padding // 100 width of age
            make.height.equalTo(textFieldHeight)
        }
        
        scrollView.addSubview(ageTextField)
        ageTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lNameTextField.snp.bottom).offset(10)
            make.leading.equalTo(bDateTextField.snp.trailing).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(textFieldHeight)
        }
        
        scrollView.addSubview(contactNumberTextField)
        contactNumberTextField.snp.makeConstraints { (make) in
            make.top.equalTo(bDateTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(textFieldHeight)
        }
        
        scrollView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(contactNumberTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(textFieldHeight)
        }
        
        scrollView.addSubview(passTextField)
        passTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(textFieldHeight)
            make.bottom.equalTo(scrollView).offset(-10)
        }
        
        passTextField.showRightImageView()
        // gesture of showing password
        let showPass = UITapGestureRecognizer(target: self, action: #selector(showPasswordAction(_:)))
        self.passTextField.imageViewR.addGestureRecognizer(showPass)
        
    }
    
    @objc func showPasswordAction(_ sender: UIGestureRecognizer) {
        if !isShow{
            self.passTextField.imageViewR.image = UIImage(named: "eye_slash")?.withRenderingMode(.alwaysTemplate)
            isShow = true
            self.passTextField.textField.isSecureTextEntry = false
        }else {
            self.passTextField.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
            isShow = false
            self.passTextField.textField.isSecureTextEntry = true
        }
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("CLICKED RETURN : \(textField.tag)")
        
        switch textField.tag {
        case 0:
            lNameTextField.textField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(lNameTextField.frame, animated: true)
        case 1:
            bDateTextField.textField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(bDateTextField.frame, animated: true)
        case 2:
            contactNumberTextField.textField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(contactNumberTextField.frame, animated: true)
        case 3:
            emailTextField.textField.becomeFirstResponder()
            self.scrollView.scrollRectToVisible(emailTextField.frame, animated: true)
        case 4:
            passTextField.textField.becomeFirstResponder() 
            self.scrollView.scrollRectToVisible(passTextField.frame, animated: true)
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc func isValidDate() {
        if let dateString = bDateTextField.textField.text {
            print("DATE STRING : \(dateString)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            if let date = dateFormatter.date(from: dateString){
                print("date is valid")
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                let finalDate = calendar.date(from:components)
                ageTextField.textField.text = "\(computeAge(bdate: finalDate!))"
            } else {
                print("date is invalid")
                ageTextField.textField.text = ""
            }
        }
        
    }
    
    @objc func dateSelected(_ datePicker: UIDatePicker ) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        bDateTextField.textField.text = dateFormat.string(from: datePicker.date)
//        view.endEditing(true)
    }
    
    func computeAge(bdate: Date) -> Int{
        let now = Date()
        let birthday: Date = bdate
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
    
    func checkEmptyTextField() -> Bool {
        if (fNameTextField.textField.text?.isEmpty ?? false) || fNameTextField.textField.text == ""{
            return true
        }else if (lNameTextField.textField.text?.isEmpty ?? false) || lNameTextField.textField.text == ""{
            return true
        }else if (fNameTextField.textField.text?.isEmpty ?? false) || fNameTextField.textField.text == ""{
            return true
        }else if (bDateTextField.textField.text?.isEmpty ?? false) || bDateTextField.textField.text == ""{
            return true
        }else if (contactNumberTextField.textField.text?.isEmpty ?? false) || contactNumberTextField.textField.text == ""{
            return true
        }else if (emailTextField.textField.text?.isEmpty ?? false) || emailTextField.textField.text == ""{
            return true
        }else if (passTextField.textField.text?.isEmpty ?? false) || passTextField.textField.text == ""{
            return true
        }else {
            return false
        }
    }
    
    func checkContactNumber() -> Bool {
        if let textCount = contactNumberTextField.textField.text?.characters.count {
            print("CONTACT NUMBER COUNT : \(textCount)")
            if  textCount > 6 && textCount < 14 {
                return true
            }
        }
        return false
    }
    

}



