//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/9/22.
//

import UIKit

// This class/view controller presents a confirmation message that the order has been submitted along with an estimated wait time
class OrderConfirmationViewController: UIViewController {
    
    let minutesToPrepare: Int
    
    @IBOutlet var confirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
    
    // Initialize with a prep time value
    init?(coder: NSCoder, prepTime: Int) {
        minutesToPrepare = prepTime
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
