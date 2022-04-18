//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import UIKit

// This class/view controller presents a detailed listing for a specified menu item
class MenuItemDetailViewController: UIViewController {
    
    let menuItem: MenuItem
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailTextLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!
    
    // Initialize with a menu item to present
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the UI
        updateUI()
        addToOrderButton.layer.cornerRadius = 5.0
    }
    
    // Update user activity state
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .menuItemDetail(menuItem))
    }
    
    // Fetch and set the UI element values
    func updateUI() {
        nameLabel.text = menuItem.name
        priceLabel.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        detailTextLabel.text = menuItem.detailText
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    // Add the presented menu item to the order with an animation
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
            self.addToOrderButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
        MenuController.shared.order.menuItems.append(menuItem)
    }
}
