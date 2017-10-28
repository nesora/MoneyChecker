//
//  EditAddCategoryViewController.swift
//  MoneyChecker
//
//  Created by Admin on 10/25/17.
//  Copyright © 2017 RosenKostov. All rights reserved.
//

import UIKit
import CoreData

class EditAddCategoryViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var navBarDone: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addCategorySegmentController: UISegmentedControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    let categoryEntityDescription = NSEntityDescription.entity(forEntityName: "Category", in: CoreDataStack.managedObjectContext)
    
    var iconDictionary  = [ 0 : "image0", 1 : "image1", 2 : "image2", 3: "image3", 4 : "image4", 5 : "image5", 6 : "image6", 7 : "image7", 8 : "image8"]
    var categories : Category?  = nil
    var getIconID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        chooseEditAdd()
        checkTextFeild()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        if categories != nil {
            editCategory()
        } else {
            createCategory()
        }
        dismissViewController()
    }
    
    func chooseEditAdd() {
        if categories != nil {
            self.navigationItem.title = "Update"
            nameTextField.text = categories?.categoryName
            if let type = categories?.type {
                addCategorySegmentController.selectedSegmentIndex = Int(type)
            }
        } else {
            self.navigationItem.title = "Add"
        }
    }
    
    // MARK:- Create Category
    func createCategory() {
        guard let checkedCategoryEntityDescription = categoryEntityDescription else {
            print("Wrong Category Entity Description")
            return
        }
        switch addCategorySegmentController.selectedSegmentIndex {
        case 0:
            if let checkId = getIconID, let name = nameTextField.text {
                let categories = Category(entity: checkedCategoryEntityDescription, insertInto: CoreDataStack.managedObjectContext)
                categories.icon = Int16(checkId)
                categories.categoryName = name
                categories.type = 0
                
            } else {
                alertForNotSelectedIcon()
                return
            }
        case 1:
            if let checkId = getIconID, let name = nameTextField.text {
                let categories = Category(entity: checkedCategoryEntityDescription, insertInto: CoreDataStack.managedObjectContext)
                categories.icon = Int16(checkId)
                categories.categoryName = name
                categories.type = 1
            } else {
                alertForNotSelectedIcon()
                return
            }
        default:
            break
        }
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch _ {
        }
    }
    
    // MARK:- Edit Category
    func editCategory() {
        guard let checkedCategoryName = nameTextField.text else {
            print("No category name")
            return
        }
        switch addCategorySegmentController.selectedSegmentIndex {
        case 0:
            categories?.categoryName = checkedCategoryName
            categories?.type = 0
            
            if getIconID == nil {
                if let icon = categories?.icon {
                    categories?.icon = icon
                }
            } else {
                if let iconID = self.getIconID {
                    categories?.icon = Int16(iconID)
                }
            }
        case 1:
            categories?.categoryName = checkedCategoryName
            categories?.type = 1
            if getIconID == nil {
                if let icon = categories?.icon {
                    categories?.icon = icon
                }
            } else {
                if let iconID = self.getIconID {
                    categories?.icon = Int16(iconID)
                }
            }
        default: break
        }
        do {
            try CoreDataStack.managedObjectContext.save()
        } catch _ {
        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        
        cell.categoryImage.image = UIImage.init(named: self.iconDictionary[indexPath.item]!)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - Check Text Field and Alerts
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (nameTextField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            navBarDone.isEnabled = true
        } else {
            navBarDone.isEnabled = false
        }
        return true
    }
    
    func checkTextFeild() {
        if (nameTextField.text?.isEmpty)! {
            navBarDone.isEnabled = false
        } else {
            navBarDone.isEnabled = true
        }
    }
    
    func alertForNotSelectedIcon() {
        let alert = UIAlertController(title: "Oops...", message: "Please select icon for the Category", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getIconID = indexPath.row
    }
    
    
    func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}
