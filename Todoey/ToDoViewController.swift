//
//  ViewController.swift
//  Todoey
//
//  Created by ravi singh on 05/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
 let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    print(dataFilePath)
        
      
      loadItems()
       // if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            
       //     itemArray = items
       // }
    }
    
    // Mark - Table View Method Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?.checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    // Mark - Add new Item

    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (UIAlertAction) in
            print("sucess")
            
            let newItem = Item()
            newItem.title = textfield.text!
            
       
            self.itemArray.append(newItem)
            
            self.saveItems()
            
          
        }
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Item"
            textfield = alertTextField
        }
       
        alert.addAction(action)
        
        present (alert , animated: true , completion: nil)
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("encoding error item array \(error)")
        }
          tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
           do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding \(error)")
            }
            
        }
        
    }

}

