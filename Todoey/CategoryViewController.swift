//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ravi singh on 13/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm ()
    
    var categories: Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
       tableView.rowHeight = 65.0
        tableView.separatorStyle = .none
    }

    //Mark:- TableView Datasource Method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColours = UIColor(hexString: category.color) else {fatalError()}
            
             cell.backgroundColor = categoryColours
            cell.textLabel?.textColor = ContrastColorOf(categoryColours, returnFlat: true)
        }
        
        
       
        return cell
    
    }
    
    
    
    //Mark:- Add New Category
       @IBAction func addPressedButton(_ sender: UIBarButtonItem) {
        
        
         var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
          print("success")
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
          //  self.categories.append(newCategory)
            
            self.save(category: newCategory)
    }
   
    
        alert.addAction(action)
        
        alert.addTextField {(field) in
            
            textfield = field
            textfield.placeholder = "Add New Category"
            
        }
      present(alert, animated: true, completion: nil)
}
   
    

    //Mark:- Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //Mark:- Data Manupulation
    func save (category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving category\(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories () {
        
         categories = realm.objects(Category.self)
        //        let request : NSFetchRequest<Category> = Category.fetchRequest(){
//            do {
//                categories = try context.fetch(request)
//            } catch {
//                print("error \(error)")
//            }
      //     tableView.reloadData()
    //   }
}
// Mark:-  Delete Data From Swipe
   override func updateModel(at indexpath: IndexPath) {
    if let deletionForCategories = self.categories?[indexpath.row]{
      do{
        try self.realm .write {
        self.realm.delete(deletionForCategories)
    }
        }catch{
         print("Error deletion \(error)")
    }
        //    tableView.reloadData()
      }
    }
}

