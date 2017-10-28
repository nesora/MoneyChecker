//
//  CategoriesViewController.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var iconDictionary  = [ 0 : "image0", 1 : "image1", 2 : "image2", 3: "image3", 4 : "image4", 5 : "image5", 6 : "image6", 7 : "image7", 8 : "image8"]
    var categories : Category?
    let managedObjectContext = CoreDataStack.managedObjectContext
    var fetchedResultController = NSFetchedResultsController<NSFetchRequestResult>()
    
    @IBOutlet weak var categoryView: UIImageView!
    @IBOutlet weak var addNavigationButton: UIBarButtonItem!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var edit: UIBarButtonItem!
    
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if (categoriesTableView.isEditing) {
            edit.title = "Edit"
            categoriesTableView.setEditing(false, animated: true)
            addNavigationButton.title = "Add"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            edit.title = "Done"
            categoriesTableView.setEditing(true, animated: true)
            addNavigationButton.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func categorySegmentControlAction(_ sender: UISegmentedControl) {
        
        switch categorySegmentControl.selectedSegmentIndex {
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
        
        categoriesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        fetchedResultController = getFetchedResultController(getTypeParam: 0)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
        categoriesTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.view.backgroundColor = UIColor.white
    }
    
    // MARK:- PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let categoryController: EditAddCategoryViewController = segue.destination as! EditAddCategoryViewController
        
        if segue.identifier == "editCategory" {
            let cell = sender as! UITableViewCell
            let indexPath = categoriesTableView.indexPath(for: cell)
            let category:Category = fetchedResultController.object(at: indexPath!) as! Category
            categoryController.categories = category
        }
    }
    
    // MARK:- Retrieve Category
    func getFetchedResultController(getTypeParam: Int) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: categoryFetchRequest(typeParameter:  getTypeParam) , managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }
    
    func categoryFetchRequest(typeParameter: Int) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let predicate = NSPredicate(format: "%K = %i", "type", typeParameter)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        let category = fetchedResultController.object(at: indexPath) as! Category
        let iconAgain = Int(category.icon)
        
        if  let getIcon = iconDictionary[iconAgain] {
          cell.imageView?.image =  UIImage.init(named: getIcon)
        }
  
        cell.textLabel?.text = category.categoryName
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedObject:NSManagedObject = fetchedResultController.object(at: indexPath) as! NSManagedObject
        managedObjectContext.delete(managedObject)
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        categoriesTableView.reloadData()
    }
    
}

