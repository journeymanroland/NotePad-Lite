//
//  NoteContentsViewController.swift
//  simple notepad
//
//  Created by Roland Gill on 1/8/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit
import EventKit

class NoteContentsViewController: UIViewController, UITextViewDelegate {
    var selectedNote: BetaNote?
    var notePad = [BetaNote]() // model
    var noteWasEdited = false // was note text edoted in this screen?
    var associatedReminder: EKReminder?
    let alertMsg = "You won't be able to make this note a reminder unless you enable Calendar access"
    let calendar = NSCalendar.currentCalendar()
    let eventStore = EventStore.sharedInstance
    
    @IBOutlet weak var noteContents: UITextView!
    @IBOutlet weak var toggleEditing: UIBarButtonItem!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var toggleReminder: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        noteWasEdited = false
        
        // check if note was able to load
        noteContents.editable = false // note not initially editable
        noteContents.delegate = self // set current VC as TextField delegate
        
        notePad = PadPersistence.sharedInstance.retrieveData() // notepad persistance singleton
        
        if let journalEntry = selectedNote { /// unwrap note
            noteContents.text = journalEntry.contents
            navigationItem.title = journalEntry.title
        } else {
            print("did not load note")
        }
    
    }
    
    // Edit button - user can change notes
    @IBAction func editSavedNote(sender: UIBarButtonItem) {
        if sender == toggleEditing {
            print("working")
            toggleEditing.title = "Done"
            self.noteContents.becomeFirstResponder() // make textfield 1st responder
            noteContents.editable = true
        } else {
            toggleEditing.title = "Edit"
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        noteWasEdited = true // note was edited
        if let editedNote = selectedNote { // save note if text is edited
            editedNote.contents = textView.text
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "set as reminder" {
            if let reminderVC = segue.destinationViewController as? SetReminderViewController {
                print("\(selectedNote) passed to reminder VC")
                reminderVC.reminder = selectedNote
            }
        }
    }
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()) {
            if noteWasEdited == true {
                
                print(selectedNote?.contents)
                if let n = selectedNote {
                    PadPersistence.sharedInstance.noteEdited(n)
                    print("note saved")
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let journalEntry = selectedNote {
            self.reminderSwitchState(journalEntry.isReminder)
        }
    }
    
    @IBAction func setAsReminder(sender: UISwitch) {
        if let toBeReminder = selectedNote {
            if !toBeReminder.isReminder {
                self.performSegueWithIdentifier("set as reminder", sender: UIViewController())
            }
        }
    }
    
    func reminderSwitchState(state: Bool) {
        if selectedNote != nil {
            toggleReminder.setOn(state, animated: true)
        }
    }
    
}
