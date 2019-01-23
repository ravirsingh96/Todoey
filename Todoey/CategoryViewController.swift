//
//  CategoryViewController.swift
//  Todoey
//
//  Created by ravi singh on 13/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm ()
    
    var categories: Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
        
    }

    //Mark:- TableView Datasource Method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added"
        
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
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//            do {
//                categories = try context.fetch(request)
//            } catch {
//                print("error \(error)")
//            }
           tableView.reloadData()
       }
}
  

