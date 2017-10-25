//
//  TransactionsViewController.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource {

 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var b = ["1" , "2" , " 3"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return b.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "transactionsCell", for: indexPath)
        
        
        return cell
    }
    
    
}
