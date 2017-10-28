//
//  TransactionsTableViewCell.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit
import CoreData

class TransactionsTableViewCell: UITableViewCell {
    
    var categories: Category?
    
    var iconDictionary  = [ 0 : "image0", 1 : "image1", 2 : "image2", 3: "image3", 4 : "image4", 5 : "image5", 6 : "image6", 7 : "image7", 8 : "image8"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionCellImage: UIImageView!
    @IBOutlet weak var transactionCategoryName: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    
    func configure(for transactions: Transaction) {
        
        
        if  let iconAgain = transactions.category?.icon, let getIcon = iconDictionary[Int(iconAgain)] {
            transactionCellImage.image = UIImage.init(named: getIcon)
        }
        
        if let currentDate = transactions.date {
            transactionDate.text = String(describing: currentDate)
        }
        
        transactionAmount.text = ( "$ \(String(describing: transactions.amount))")
        transactionCategoryName.text = transactions.category?.categoryName
    }
    
}
