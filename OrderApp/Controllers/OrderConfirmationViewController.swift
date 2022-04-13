//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/9/22.
//

import UIKit

// This class/view controller presents a confirmation message that the order has been submitted along with an estimated wait time
class OrderConfirmationViewController: UIViewController {
    
    var minutesToPrepare: Int
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var confirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
        progressBar.progress = 0
        
        setProgressTimer()
    }
    
    // Initialize with a prep time value
    init?(coder: NSCoder, prepTime: Int) {
        minutesToPrepare = prepTime
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create a timer to increase the progress bar progress according to the elapsed time and the estimated prep time
    func setProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.progressBar.progress += Float(1.0/(Double(self.minutesToPrepare*60)))
            
            if self.progressBar.progress == 1 {
                timer.invalidate()
            }
        }
    }
}
