//
//  TransactionsViewController.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit
import CoreData

class TransactionsViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource , NSFetchedResultsControllerDelegate  {
    
    let managedObjectContext = CoreDataStack.managedObjectContext
    var fetchedResultController = NSFetchedResultsController<NSFetchRequestResult>()
    var transactions : Transaction?
    
    @IBOutlet weak var transactionsSegmentControl: UISegmentedControl!
    @IBOutlet weak var transactionsTableView: UITableView!
    
    @IBAction func transactionSegmentChanged(_ sender: UISegmentedControl) {
        switch transactionsSegmentControl.selectedSegmentIndex {
        case 0:
            fetchedResultController = getFetchedResultController(getTypeParam: 0)
        case 1:
            fetchedResultController = getFetchedResultController(getTypeParam: 1)
        default:
            break
        }
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
        transactionsTableView.reloadData()
    }
    @IBOutlet weak var addNavigationButton: UIBarButtonItem!
    @IBOutlet weak var edit: UIBarButtonItem!
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if (transactionsTableView.isEditing) {
            edit.title = "Edit"
            transactionsTableView.setEditing(false, animated: true)
            addNavigationButton.title = "Add"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            edit.title = "Done"
            transactionsTableView.setEditing(true, animated: true)
            addNavigationButton.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController = getFetchedResultController(getTypeParam: 0)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
        transactionsTableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.view.backgroundColor = UIColor.white
        transactionsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK:- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let transactionController : EditAddTransactionViewController = segue.destination as! EditAddTransactionViewController
        
        if segue.identifier == "editTransaction" {
            let cell = sender as! UITableViewCell
            let indexPath = transactionsTableView.indexPath(for: cell)
            let transaction:Transaction = fetchedResultController.object(at: indexPath!) as! Transaction
            
            transactionController.transactions = transaction
        }
        
    }
    
    // MARK:- Retrieve Transaction
    func getFetchedResultController(getTypeParam: Int) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: transactionFetchRequest(typeParameter:  getTypeParam) , managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }
    
    func transactionFetchRequest(typeParameter: Int) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        let predicate = NSPredicate(format: "%K = %i", "type", typeParameter)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    // MARK: - TableView data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let numberOfSections = fetchedResultController.sections?.count ?? 0
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects ?? 0
        
        return numberOfRowsInSection
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionsTableViewCell
        
        let transactions = fetchedResultController.object(at: indexPath)
        
        cell.configure(for: transactions as! Transaction)
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedObject:NSManagedObject = fetchedResultController.object(at: indexPath) as! NSManagedObject
        
        managedObjectContext.delete(managedObject)
        do {
            try managedObjectContext.save()
        } catch _ {
        }
        transactionsTableView.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        transactionsTableView.reloadData()
    }
    
}
