//
//  WebView.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 10/1/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class WebViewController : UIViewController {
    
    var url: URL?

    var webView : UIWebView = {
        let v = UIWebView()
        v.scrollView.bounces = false
        v.scalesPageToFit = true
        return v
    }()
    
    var backButtonView : UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = true
        return v
    }()
    
    init(url: String) {
        self.url = URL(string: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUpView()
        
        if let urlString = url {
            webView.loadRequest(URLRequest(url: urlString))
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func setUpView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}
