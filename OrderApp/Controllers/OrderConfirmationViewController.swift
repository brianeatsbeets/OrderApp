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
    let secondsToPrepare: Double
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var confirmationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
        progressBar.progress = 0
        
        setProgressTimer()
        createNotification()
    }
    
    // Initialize with a prep time value
    init?(coder: NSCoder, prepTime: Int) {
        minutesToPrepare = prepTime
        secondsToPrepare = Double(minutesToPrepare*60)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create a timer to increase the progress bar progress according to the elapsed time and the estimated prep time
    func setProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.progressBar.progress += Float(1.0/(self.secondsToPrepare))
            
            if self.progressBar.progress == 1 {
                timer.invalidate()
            }
        }
    }
    
    // Create a local notification that is displayed 10 minutes before the order will be ready
    func createNotification() {
        
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Hope you're hungry!"
        content.body = "Your order will be ready in 10 minutes."
        
        // Configure the time to deliver the notification
        var alertTime = 3.0
        if secondsToPrepare-600 > 0 {
            alertTime = secondsToPrepare-600
        }
        
        // Create the notification request and schedule it
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alertTime, repeats: false)
        let request = UNNotificationRequest(identifier: "tenMinuteAlert", content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if let error = error {
                print("Notification add error: \(error.localizedDescription)")
            }
        }
    }
}
