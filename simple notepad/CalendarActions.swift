//
//  CalendarActions.swift
//  NotePad Lite
//
//  Created by Roland Gill on 4/13/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import Foundation
import EventKit

class CalendarActions {
    private let eventStore = EventStore.sharedInstance
    private var allCalendars = [EKCalendar]()
    
    // public
    let calendar = NSCalendar.currentCalendar()
    var listOfReminders = [EKReminder]()
    
    func getRemindersCal() -> [EKReminder] { // fetch all reminders
        var listOfReminders = [EKReminder]()
        allCalendars = eventStore.calendarsForEntityType(.Reminder)
        // execute fetch of all reminders
        let allReminders: NSPredicate = eventStore.predicateForRemindersInCalendars([])
        eventStore.fetchRemindersMatchingPredicate(allReminders) { (reminders) -> Void in
            for rem in reminders! {
                print(rem.title)
            }
            listOfReminders = reminders! // list of reminders object set as all reminders
        }
        return listOfReminders
        
    }
    
    func requestCalendarAccess() { // request access to reminders
        eventStore.requestAccessToEntityType(.Reminder, completion: {
            granted, error in
            
            if granted == true {
                print("calendar authorized")
                self.getRemindersCal() // get all reminders if we have access to icalendar
            } else {
                print("ERROR: \(error)")
            }
        })
    }
    
    func checkCalAuth() -> Bool { // are we authorized to access the calendar?
        let status = EKEventStore.authorizationStatusForEntityType(.Reminder)
        
        switch status {
        case .Authorized:
            print("calendar authorized")
            self.getRemindersCal() /// fetch reminders if authorized
            return true
        case .NotDetermined:
            print("auth not determined")
            self.requestCalendarAccess()
            return false
        case .Denied, .Restricted:
            print("calendar auth failed")
            return false
            
        }
    }
    
    func setReminderForNote(when: NSDateComponents) -> EKReminder { // will set a reminder on iOS default calendar
        let newEvent = EKReminder(eventStore: eventStore)
        newEvent.calendar = eventStore.defaultCalendarForNewReminders()
        let comps: NSDateComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: NSDate()/*rm.dateWritten*/)
        newEvent.timeZone = NSTimeZone.localTimeZone()
        newEvent.startDateComponents = comps // start date is timestamp of note creation
        newEvent.dueDateComponents = when
        newEvent.completed = false

        print("reminder created \(newEvent.calendarItemIdentifier)")
        return newEvent // instance reminder for VC class created

    }
    
    func saveNew(reminder: EKReminder?) { // save a note
        if let newRem = reminder {
            do {
                try eventStore.saveReminder(newRem, commit: true) // save
                print("save successful")
                listOfReminders.append(newRem) // add to list of reminders
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
    
    func deleteEvent(reminder: EKReminder) { // delete
        do {
            try eventStore.removeReminder(reminder, commit: true)
        } catch {
            print("event not located in store \(error)")
        }
    }

}