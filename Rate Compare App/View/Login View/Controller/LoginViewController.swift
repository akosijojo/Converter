//
//  LoginViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/9/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn

class LoginViewController: UIViewController ,UITextFieldDelegate {
    
    var clientId : String = "116666508049-q0drulaulnhapaobj336r5hhlah3vkas.apps.googleusercontent.com"
    var isShow : Bool = false
    var viewModel : LoginViewModel?
    
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    lazy var signUpLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign up"
        lbl.font = UIFont(name: Fonts.medium, size: 20)
        lbl.sizeToFit()
        lbl.textAlignment = .right
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    lazy var loginLogo : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Login_icon")
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        return img
    }()
    
    lazy var userNameTextField : TextField = {
        let txt = TextField()
        txt.placeholder = "Email"
        txt.layer.borderWidth = 1
        txt.layer.borderColor = Config().colors.borderColor.cgColor
        txt.layer.cornerRadius = 5
        txt.keyboardType = .emailAddress
        return txt
    }()
    
    lazy var passwordTextField : CustomTextFieldwithImage = {
        let v                = CustomTextFieldwithImage()
        v.layer.cornerRadius = 20
        v.textField.placeholder        = "Password"
        v.textField.isSecureTextEntry  = true
        v.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
        v.imageViewR.tintColor = Config().colors.grayBackground
        v.layer.borderWidth = 1
        v.layer.borderColor = Config().colors.borderColor.cgColor
        v.layer.cornerRadius = 5

        return v
    }()
    
    lazy var loginButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Config().colors.lightGraybackground.cgColor
        btn.layer.cornerRadius = 5
        btn.backgroundColor = Config().colors.blueBgColor
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        btn.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var lineLabelView : UIView = {
        let lbl = UIView()
        return lbl
    }()
    
    lazy var leftLine : UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = Config().colors.lightGraybackground
        return lbl
    }()
    
    lazy var label : UILabel = {
        let lbl = UILabel()
        lbl.text = "OR"
        lbl.font = UIFont(name: Fonts.regular, size: 14)
        lbl.textAlignment = .center
        lbl.textColor = Config().colors.textColorLight
        return lbl
    }()
    
    lazy var rightLine : UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = Config().colors.lightGraybackground
        return lbl
    }()
    
//    lazy var fbButton : FBSDKLoginButton = {
//        let btn = FBSDKLoginButton(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
//        btn.readPermissions = ["public_profile","email"]
//        return btn
//    }()
    
    lazy var customfbButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Facebook", for: .normal)
        btn.setTitleColor(Config().colors.whiteBackground, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = Config().colors.lightGraybackground.cgColor
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor(hex: "4267B2")
        btn.titleLabel?.font = UIFont(name: Fonts.regular, size: 16)
        btn.addTarget(self, action: #selector(loginOnFbAction), for: .touchUpInside)
        return btn
    }()
    
    
    let googleButton : GIDSignInButton = {
        let lbl = GIDSignInButton()
        lbl.style = .wide
        return lbl
    }()
    
    let customGoogleButton : UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign in with Google"
        lbl.backgroundColor = Config().colors.redBgColor
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont(name: Fonts.regular, size: 16)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hidesKeyboardOnTapArround()
        setUpListener()
        setUpView()
        userNameTextField.delegate = self
        passwordTextField.textField.delegate = self
//        fbButton.delegate = self
        
        let tapSignUp = UITapGestureRecognizer(target: self, action: #selector(signUpButtonAction))
        signUpLabel.addGestureRecognizer(tapSignUp)
        // Do any additional setup after loading the view, typically from a nib.

//        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.clientID = clientId
//        GIDSignIn.sharedInstance().delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
//        GIDSignIn.sharedInstance()?.disconnect()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(whenShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(whenHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            self.passwordTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
   
    @objc func whenShowKeyboard(_ notification : NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            self.scrollView.contentInset = contentInsets
            var aRect: CGRect = self.scrollView.frame
            aRect.size.height -= keyboardHeight
            if userNameTextField.isFirstResponder {
                if !aRect.contains(userNameTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
                }
            }else if passwordTextField.isFirstResponder {
                if !aRect.contains(passwordTextField.frame.origin) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
                }
            }else {
                
            }
            
        }
    }
    
    @objc func whenHideKeyboard(_ notification : NSNotification) {
       scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setUpListener() {
        self.viewModel?.onSuccessGettingList = { [weak self] data in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: {
                    self?.loginSuccessAction(data: data)
                })
            }
        }
        
        self.viewModel?.onErrorHandling = { [weak self
            ] status in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: {
                    self?.alert(btn: "OK", title: "", msg: status?.message ?? "Something went wrong")
                })
            }
        }
    }
    
    func alert(btn: String,title: String,msg: String){
        let alert = self.alert(btn, title, msg) { (action) in
            
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
        scrollView.addSubview(signUpLabel)
        signUpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(loginLogo)
        loginLogo.snp.makeConstraints { (make) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(40)
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        scrollView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(loginLogo.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(userNameTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(lineLabelView)
        lineLabelView.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        lineLabelView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineLabelView)
            make.centerX.equalTo(lineLabelView)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        lineLabelView.addSubview(leftLine)
        leftLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineLabelView)
            make.leading.equalTo(lineLabelView)
            make.trailing.equalTo(label.snp.leading).offset(-20)
            make.height.equalTo(1)
        }
        
        lineLabelView.addSubview(rightLine)
        rightLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineLabelView)
            make.leading.equalTo(label.snp.trailing).offset(20)
            make.trailing.equalTo(lineLabelView)
            make.height.equalTo(1)
        }
        
        scrollView.addSubview(customfbButton)
        customfbButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineLabelView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(customGoogleButton)
        customGoogleButton.snp.makeConstraints { (make) in
            make.top.equalTo(customfbButton.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView).offset(-10)
        }

        // gesture of showing password
        let showPass = UITapGestureRecognizer(target: self, action: #selector(showPasswordAction(_:)))
        self.passwordTextField.imageViewR.addGestureRecognizer(showPass)
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(signInWithGoogleAction(_:)))
        customGoogleButton.isUserInteractionEnabled = true
        customGoogleButton.addGestureRecognizer(googleTap)
    }
    
    @objc func signUpButtonAction() {
         let controller = SignUpViewController()
        controller.viewModel = LoginViewModel()
        controller.viewModel?.model = LoginModel()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func gmailButtonAction() {
        
    }
    
    func loginSuccessAction(data: UsersData?) {
      
        self.viewModel?.model?.saveToLocal(data: data)
        
        let navigationController = UINavigationController(
            rootViewController: CustomTabBarController()
        )
        navigationController.navigationBar.barTintColor = Config().colors.blueBgColor
        navigationController.navigationBar.tintColor  = Config().colors.blackBgColor
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Config().colors.whiteBackground]
        self.present(navigationController, animated: true, completion: {
            if FBSDKAccessToken.current() != nil {
                let manager = FBSDKLoginManager()
                manager.logOut()
            }
            if GIDSignIn.sharedInstance()?.currentUser != nil {
                GIDSignIn.sharedInstance()?.signOut()
            }
        })
    }
    
    @objc func loginButtonAction() {
        if userNameTextField.text != "" && passwordTextField.textField.text != "" {
            if let email = userNameTextField.text , let pass = passwordTextField.textField.text {
                self.showLoading()
                let param = ["email" : email, "password" : pass]
                self.viewModel?.login(param:  param)
            }
        }else {
            self.alert(btn: "OK", title: "", msg: "All fields are required")
        }
        
    }
    
    @objc func showPasswordAction(_ sender: UIGestureRecognizer) {
        if !isShow{
            self.passwordTextField.imageViewR.image = UIImage(named: "eye_slash")?.withRenderingMode(.alwaysTemplate)
            isShow = true
            self.passwordTextField.textField.isSecureTextEntry = false
        }else {
            self.passwordTextField.imageViewR.image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
            isShow = false
            self.passwordTextField.textField.isSecureTextEntry = true
        }
    }
    
    @objc func loginOnFbAction() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFbData()
                }
            }
        }
    }
    
    func getFbData() {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name,last_name,picture.type(large),email"]).start { (connection, result, err) in
                if (err == nil) {
                    let faceDic = result as! [String:AnyObject]
                    if let email = faceDic["email"] as? String ,let firstName = faceDic["first_name"] as? String, let lastName = faceDic["last_name"] as? String , let fid = faceDic["id"] as? String {
                        let param = ["firstname": firstName ,"lastname": lastName , "email": email ,"facebook_id": fid]
                        self.showLoading()
                        self.viewModel?.login(param: param, fb: true)
                    }
                }
            }
        }
    }
}


extension LoginViewController : GIDSignInDelegate,GIDSignInUIDelegate{
    
    @objc func signInWithGoogleAction(_ sender: UIGestureRecognizer) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...
    
        customGoogleButton.text = "Sign in with \(fullName ?? "Google")"
    
        print("SIGNING IN GOOGLE : \(fullName) \n \(givenName) \n \(familyName) \n \(email)")
    }
    

}


//
//extension LoginViewController : FBSDKLoginButtonDelegate {
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Users did logout ")
//    }
//
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print("Error : \(error)")
//        }else if (result?.isCancelled ?? false) {
//
//            print("CANCELLED LOGIN )")
//        }else {
//            getFbData()
//            print("SUCCESSFULLY LOGIN \(result)")
//        }
//    }
//
////    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
////        print("Users did logout ")
////    }
////
////    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
////
////        if error != nil {
////            print("Error : \(error)")
////        }else if (result?.isCancelled ?? false) {
////
////            print("CANCELLED LOGIN )")
////        }else {
////            print("SUCCESSFULLY LOGIN \(result)")
////        }
////
////    }
//        @objc func getFBUserData(){
//        if((FBSDKAccessToken.current()) != nil){
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    //everything works print the user data
//                    print(result)
//                }
//            })
//        }
//        }
//
////
//
////
//}
