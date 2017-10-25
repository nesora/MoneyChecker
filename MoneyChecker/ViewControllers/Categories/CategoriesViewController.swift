//
//  CategoriesViewController.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var a = ["1" , "2" , "3"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return a.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        
        cell.textLabel?.text = "bla"
        
        return cell
    }

}
