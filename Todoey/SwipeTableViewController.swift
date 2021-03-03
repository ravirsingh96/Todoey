//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by ravi singh on 25/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //Mark:- TableView DataSources Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! SwipeTableViewCell
        
      //  cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added"
        cell.delegate =  self
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
//            if let deletionForCategories = self.categories?[indexPath.row]{
//                do{
//                    try self.realm .write {
//                        self.realm.delete(deletionForCategories)
//                    }
//                }catch{
//                    print("Error deletion \(error)")
//                }
//                //    tableView.reloadData()
//            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-Icon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive   //delete last row of table view so don't  call table view in swiptabledelegate
        // options.transitionStyle = .border
        return options
    }
    
    //Mark:- Upadte Model
    
    func updateModel(at indexpath: IndexPath)  {
        
    }
}
