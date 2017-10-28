//
//  EditAddTransactionViewController.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit
import CoreData

class EditAddTransactionViewController: UIViewController  , UITextFieldDelegate , UIPickerViewDelegate , UIPickerViewDataSource , NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = CoreDataStack.managedObjectContext
    var fetchedResultController = NSFetchedResultsController<NSFetchRequestResult>()
    
    let transactionEntity = NSEntityDescription.entity(forEntityName: "Transaction", in: CoreDataStack.managedObjectContext)
    let pickerView = UIPickerView()
    var transactions : Transaction? = nil
    var categories : Category?
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    var getCategoryTitle : String?
    
    @IBOutlet weak var navBarDone: UIBarButtonItem!
    @IBOutlet var addEditTransaction: UIView!
    @IBOutlet weak var addEditTransactionSegmentControl: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismissViewController()
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
        if transactions != nil {
            editTransaction()
        } else {
            createTransaction()
        }
        dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController = getFetchedResultController(getTypeParam: 0)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
        }
        chooseUpdateAdd()
        dateTextField.delegate = self
        amountTextField.delegate = self
        categoryTextField.delegate = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        categoryTextField.inputView = pickerView
        checkTextFeild()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func transactionSegment(_ sender: UISegmentedControl) {
        
        pickerView.delegate = self
        switch addEditTransactionSegmentControl.selectedSegmentIndex {
        case 0:
            emptyTextFields()
            fetchedResultController = getFetchedResultController(getTypeParam: 0)
            pickerView.reloadInputViews()
            
        case 1:
            emptyTextFields()
            fetchedResultController = getFetchedResultController(getTypeParam: 1)
            pickerView.reloadInputViews()
            
        default:
            break
        }
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
    }
    
    // MARK: - Retrieve Category
    
    func getFetchedResultController(getTypeParam: Int) -> NSFetchedResultsController<NSFetchRequestResult> {
        fetchedResultController = NSFetchedResultsController(fetchRequest: categoryFetchRequest(typeParameter: getTypeParam) , managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func categoryFetchRequest(typeParameter: Int) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
        let predicate = NSPredicate(format: "%K = %i", "type", typeParameter)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    // MARK:- Create/Edit Transactions
    
    func createTransaction() {
        guard let transactionEntityCheck = transactionEntity else {
            print("Wrong transaction Entity")
            return
        }
        switch addEditTransactionSegmentControl.selectedSegmentIndex {
        case 0:
            let transactions = Transaction(entity: transactionEntityCheck, insertInto: CoreDataStack.managedObjectContext)
            if let theNumber = numberFormatter.number(from: amountTextField.text!), let theDate = dateTextField.text {
                transactions.amount = Double(truncating: theNumber)
                transactions.date = theDate
                transactions.type = 0
                transactions.setValue(categories, forKey: "category")
            }
        case 1:
            let transactions = Transaction(entity: transactionEntityCheck, insertInto: CoreDataStack.managedObjectContext)
            if let theNumber = numberFormatter.number(from: amountTextField.text!), let theDate = dateTextField.text {
                transactions.amount = Double(truncating: theNumber)
                transactions.date = theDate
                transactions.type = 1
                transactions.setValue(categories, forKey: "category")
            }
        default:
            break
        }
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch _ {
        }
    }
    
    func editTransaction() {
        guard let checkedAmount = amountTextField.text  else {
            print("No amount for income/expense")
            return
        }
        switch addEditTransactionSegmentControl.selectedSegmentIndex {
        case 0:
            if let theNumber = numberFormatter.number(from: checkedAmount), let theDate = dateTextField.text {
                transactions?.amount = Double(truncating: theNumber)
                transactions?.date = theDate
                transactions?.type = 0
            }
            if  getCategoryTitle == nil {
                transactions?.category?.categoryName = transactions?.category?.categoryName
            } else {
                transactions?.setValue(categories, forKey: "category")
            }
        case 1:
            if let theNumber = numberFormatter.number(from: checkedAmount), let theDate = dateTextField.text {
                transactions?.amount = Double(truncating: theNumber)
                transactions?.date = theDate
                transactions?.type = 1
            }
            if  getCategoryTitle == nil {
                transactions?.category?.categoryName = transactions?.category?.categoryName
            } else {
                transactions?.setValue(categories, forKey: "category")
            }
        default: break
        }
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch _ {
        }
    }
    
    func chooseUpdateAdd() {
        if transactions != nil {
            self.navigationItem.title = "Update"
            if let dateTime = transactions?.date , let price = transactions?.amount , let type = transactions?.type {
                dateTextField.text = String(describing: dateTime)
                amountTextField.text = String(describing: price)
                categoryTextField.text = transactions?.category?.categoryName
                addEditTransactionSegmentControl.selectedSegmentIndex = Int(type)
            }
        } else {
            self.navigationItem.title = "Add"
        }
    }
    
    // MARK:- Create DatePicker
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.backgroundColor = UIColor.white
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(EditAddTransactionViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - CategoryPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (fetchedResultController.fetchedObjects?.count) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let indexPath = NSIndexPath(row: row, section: 0)
        
        if  let fetchedObject: Category = self.fetchedResultController.object(at: indexPath as IndexPath) as? Category {
            return fetchedObject.categoryName
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let indexPath = NSIndexPath(row: row, section: 0)
        categories = self.fetchedResultController.object(at: indexPath as IndexPath) as? Category
        getCategoryTitle = categories?.categoryName
        categoryTextField.text = categories?.categoryName
        
    }
    
    // MARK:- Restrictions for textfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let amountText = (amountTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if (amountTextField.text?.contains("."))! && string.contains(".") {
            return false
        }
        if amountText.isEmpty {
            navBarDone.isEnabled = false
        } else {
            navBarDone.isEnabled = true
        }
        
        return true
    }
    
    func checkTextFeild() {
        guard let  amountCheck = amountTextField.text , let dateCheck = dateTextField.text , let categoryCheck = categoryTextField.text else {
            print("empty fields for amount , date and category ")
            return
        }
        if amountCheck.isEmpty ||  dateCheck.isEmpty || categoryCheck.isEmpty {
            navBarDone.isEnabled = false
        } else {
            navBarDone.isEnabled = true
        }
    }
    
    func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func emptyTextFields() {
        categoryTextField.text?.removeAll()
        amountTextField.text?.removeAll()
        dateTextField.text?.removeAll()
    }
    
}
