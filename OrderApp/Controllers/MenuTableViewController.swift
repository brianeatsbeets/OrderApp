//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import UIKit

// This class/view controller presents a listing of menu items in the selected category
class MenuTableViewController: UITableViewController {
    
    let category: String
    var menuItems = [MenuItem]()
    
    // Initialize with a category
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch and present menu items; display error if error
        MenuController.shared.fetchMenuItems(forCategory: category) { (result) in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems)
            case .failure(let error):
                self.displayError(error, title: "Failed to fetch menu items for \(self.category)")
            }
        }
    }
    
    // Update user activity state
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .menu(category: category))
    }
    
    // Update the UI elements
    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.title = self.category.capitalized
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    
    // Display an error if the menu items could not be fetched
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Navigate to the detailed menu item listing for the selected item
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        let menuItem = menuItems[indexPath.row]
        return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)

        configure(cell, forItemAt: indexPath)

        return cell
    }
    
    // Fetch and apply data for cell presentation
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
}
