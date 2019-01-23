//
//  ViewController.swift
//  Todoey
//
//  Created by ravi singh on 05/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

   
    }
    
    // Mark - Table View Method Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if  let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ?.checkmark : .none
        }else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                 try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    // Mark - Add new Item

    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            print("sucess")

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.Items.append(newItem)
                    }
                    
                }catch{
                    print("Error saving new items \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Item"
            textfield = alertTextField
        }
       
        alert.addAction(action)
        
        present (alert , animated: true , completion: nil)
    }
    
  
    
    func loadItems() {
        todoItems = selectedCategory?.Items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

extension ToDoViewController : UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
}

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        
        }
        
      
    }
    


}
