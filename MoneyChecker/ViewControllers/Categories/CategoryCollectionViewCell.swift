//
//  CategoryTableViewCell.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor.gray
            } else {
                backgroundColor = UIColor.clear
            }
        }
    }
    
}
