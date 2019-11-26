//
//  TermsAndConditionViewController.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/12/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class TermsAndConditionViewController : UIViewController {
    
    var data : UsersData?
    var viewModel : LoginViewModel?
    
    lazy var scrollView : UIScrollView = {
        let t = UIScrollView()
        t.isScrollEnabled = true
        return t
    }()
    
    lazy var titleLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.bold, size: 30)
        t.text = "Terms and Condition"
        t.sizeToFit()
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.textAlignment = .left
        return t
    }()
    
    lazy var descLabel : UILabel = {
        let t = UILabel()
        t.font = UIFont(name: Fonts.regular, size: 16)
        t.text = "We have sent you a 6-digit code.\nPlease view message box."
        t.sizeToFit()
        t.minimumScaleFactor = 0.2
        t.adjustsFontSizeToFitWidth = true
        t.textAlignment = .left
        t.numberOfLines = 0
        return t
    }()
    
    lazy var submitBtn : Custom2Button = {
        let btn = Custom2Button()
        btn.btn2.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return btn
    }()
    
    init(data : UsersData?) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Config().colors.whiteBackground
        //        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        // Do any additional setup after loading the view, typically from a nib.
         descLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \n Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."
        
        setUpView()
        
    
        submitBtn.btn1.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        submitBtn.btn2.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
    
    func setUpView() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let height : CGFloat = descLabel.text?.height(withConstrainedWidth: view.safeAreaLayoutGuide.layoutFrame.width - 40, font: UIFont(name: Fonts.regular, size: 16)!) ?? 40
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(height)
        }
    
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.height.equalTo(80)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(scrollView)
        }
    
    }
    
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
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
        
        self.viewModel?.model?.saveToLocal(data: self.data)
        
        let navigationController = UINavigationController(
            rootViewController: CustomTabBarController()
        )
        navigationController.navigationBar.barTintColor = Config().colors.blueBgColor
        navigationController.navigationBar.tintColor  = Config().colors.blackBgColor
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Config().colors.whiteBackground]
        self.present(navigationController, animated: true, completion: nil)
    }

}
