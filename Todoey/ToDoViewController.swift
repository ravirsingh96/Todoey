//
//  ViewController.swift
//  Todoey
//
//  Created by ravi singh on 05/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
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
         tableView.rowHeight = 60.0 
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.color else {fatalError()}
        
       updateNavBar(withHexCode: colourHex)
        
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       updateNavBar(withHexCode: "857A80")
        
        
    }
    
    //Mark:- Upadate Nav Bar
    
    func updateNavBar (withHexCode  colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller Does not Exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    // Mark - Table View Method Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
        
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
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
    
    // Mark:- Delete Data from model
    
    override func updateModel(at indexpath: IndexPath) {
        if let item = todoItems?[indexpath.row] {
            
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch{
                print("Error, \(error)")
            }
            
        }
          
    
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
