//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Megha Kulkarni on 17/08/19.
//  Copyright © 2019 Megha Kulkarni. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //Mark: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    

    func saveCategories() {
        do {
           try context.save()
        } catch {
          print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories =  try context.fetch(request)
        } catch {
            print("error loading categories \(error)")
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField =  UITextField()
        let alert = UIAlertController(title:"Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category "
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
