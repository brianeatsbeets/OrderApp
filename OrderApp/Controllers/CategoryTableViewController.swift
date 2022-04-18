//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import UIKit

// This class/view controller presents a listing of the menu categories
class CategoryTableViewController: UITableViewController {
    
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization { granted in
            switch granted {
            case true:
                print("yay!")
            case false:
                print("aww.")
            }
        }
        
        // Fetch and present categories; display error if error
        MenuController.shared.fetchCategories { (result) in
            switch result {
            case .success(let categories):
                self.updateUI(with: categories)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }
    
    // Update user activity state
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .categories)
    }
    
    // Request authorization to display notifications
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
            completion(granted)
        }
    }
    
    // Update the UI elements
    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
    
    // Display an error if the categories could not be fetched
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Navigate to the menu item listing for the selected category
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        let category = categories[indexPath.row]
        return MenuTableViewController(coder: coder, category: category)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)

        configureCell(cell, forCategoryAt: indexPath)

        return cell
    }
    
    // Fetch and apply data for cell presentation
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category  = categories[indexPath.row]
        cell.textLabel?.text = category.capitalized
    }
}
