//
//  ConfigureReminderReps.swift
//  NotePad Lite
//
//  Created by Roland Gill on 4/12/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit
import EventKit
class ConfigureReminderReps: UIViewController {
    var repFrequency: EKRecurrenceFrequency?
    var repeatingReminder: EKReminder?
    // outlets
    @IBOutlet weak var repetitionSettings: UISegmentedControl!
    @IBOutlet weak var repetitionEndDate: UIDatePicker!
    @IBOutlet weak var timeInterval: UISlider!
    @IBOutlet weak var intervalLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(repeatingReminder)
    }
    
    @IBAction func doneSetting(sender: UIButton) {
        
        if let freq = repFrequency,
        let rem = repeatingReminder {
            let repsRule = EKRecurrenceRule(recurrenceWithFrequency: freq, interval: Int(timeInterval.value), end: EKRecurrenceEnd(endDate: repetitionEndDate.date))
            rem.addRecurrenceRule(repsRule)
        }
        
        self.dismissViewControllerAnimated(true, completion: {
            // give back reminder with recurrence to last vc
            
        })
    }
    
    @IBAction func cancelReminderConfig(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func endRepConfig(sender: UIBarButtonItem) {
        if let freq = repFrequency,
            let rem = repeatingReminder {
            let repsRule = EKRecurrenceRule(recurrenceWithFrequency: freq, interval: Int(timeInterval.value), end: EKRecurrenceEnd(endDate: repetitionEndDate.date))
            rem.addRecurrenceRule(repsRule)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showInterval(sender: UISlider) {
        intervalLbl.text? += " \(timeInterval.value)"
    }
    
    @IBAction func repChoiceSet(sender: UISegmentedControl) {
        switch repetitionSettings.selectedSegmentIndex {
        case 0:
            repFrequency = .Daily
            timeInterval.maximumValue = 6 // repeat every 6 days
        case 2:
            repFrequency = .Monthly
            timeInterval.maximumValue = 11
        case 3:
            repFrequency = .Yearly
            timeInterval.maximumValue = 1
        default:
            repFrequency = .Weekly
            timeInterval.maximumValue = 51
        }
    }
}
