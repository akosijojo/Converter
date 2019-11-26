//
//  BaseCell.swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/12/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

class BaseCell<T> : UICollectionViewCell {
    
    var data : T?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
    
    
}
