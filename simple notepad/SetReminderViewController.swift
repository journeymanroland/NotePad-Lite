//
//  SetReminderViewController.swift
//  NotePad Lite
//
//  Created by Roland Gill on 3/25/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

//TODO: repeating reminders
//TODO: there is repeat code for set reminder function
//TODO:
//TODO: create reminder when date and time are picked
//

import UIKit
import EventKit
import Foundation

class SetReminderViewController: UIViewController {
    var reminderTitle: String?
    var reminder: BetaNote? // note object
    let calendarActions = CalendarActions()
    var newReminder: EKReminder?
    // outlets
    @IBOutlet weak var noteReminderDateChoice: UIDatePicker! // date picker obj
    @IBOutlet weak var dateOfReminder: UILabel!
    @IBOutlet weak var timeOfReminder: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(reminderTitle)
        // get user permission to access calendar
    }
        
    // action completed when section on picker wheel is chosen    
    @IBAction func dateChosen(sender: UIDatePicker) {
        let dateFrmtr = NSDateFormatter()
        dateFrmtr.dateStyle = .LongStyle
        dateFrmtr.timeStyle = .ShortStyle
        let fullDateTime = dateFrmtr.stringFromDate(noteReminderDateChoice.date)
        let labels = fullDateTime.componentsSeparatedByString(" at ")
        dateOfReminder.text? = labels[0]
        timeOfReminder.text? = labels[1]
    }
    
    // 'back'/'done' button
    override func viewWillDisappear(animated: Bool) {
        if (self.isMovingFromParentViewController()) {
            let dueDate: NSDateComponents = calendarActions.calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: self.noteReminderDateChoice.date) // reminder's due date is date set on date picker
            print("reminder set for:  \(newReminder)")
            let nr = calendarActions.setReminderForNote(dueDate)
            newReminder = nr
            calendarActions.saveNew(newReminder)
            self.reminder?.isReminder = true // note now set as reminder
        }
    }
    
    @IBAction func goToRepsConfig(sender: UISwitch) {
        self.performSegueWithIdentifier("repetition settings", sender: UIViewController())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "set repetition"  {
            if let configVC = segue.destinationViewController as? ConfigureReminderReps {
                print(newReminder)
                configVC.repeatingReminder = newReminder
            }
        }
    }
    
}
