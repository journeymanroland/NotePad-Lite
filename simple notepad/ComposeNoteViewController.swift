//
//  ComposeNoteViewController.swift
//  simple notepad
//
//  Created by Roland Gill on 1/7/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

//TODO: switch button remains on if event is a reminder
//TODO: fetch one reminder

import UIKit
import EventKit

class ComposeNoteViewController: UIViewController, UITextViewDelegate {
    //let cellReuseIdentifier = "NoteCell"
    
    // referencing outlets
    var newNote: BetaNote?
   
    @IBOutlet var noteBody: UITextView! // contents box
    @IBOutlet weak var noteIsReminder: UISwitch!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var reminderDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Compose New Note" // screen title
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ComposeNoteViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        noteBody.delegate = self
        noteBody.text = "Compose your note"
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            if newNote == nil {
                newNote = BetaNote(title: noteTitle.text!,
                    contents: noteBody.text, isReminder: false) // instantiate note
            }
            if let createdNote = newNote {
                print(createdNote)
                self.saveAndPersist(createdNote)
            }
        }
    }
    @IBAction func noteWillBeReminder(sender: UISwitch) {
        newNote = BetaNote(title: noteTitle.text!,
                           contents: noteBody.text, isReminder: false) // instantiate note
        self.performSegueWithIdentifier("set reminder", sender: UIViewController())
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        print("did begin editing")
        noteBody.text = "" // clear text box upon clicking
    }
    
    func saveAndPersist(note: BetaNote) {
//        newNote = BetaNote(title: noteTitle.text!,
//            contents: noteBody.text, isReminder: false)
        PadPersistence.sharedInstance.persistData(note)
        print("note saved")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "set reminder" {
            if let setReminderVC = segue.destinationViewController as? SetReminderViewController {
                print("\(newNote) passed to reminder VC")
                setReminderVC.reminderTitle = handleTitle()
            }
        }
    }
    
    @IBAction func addReminderDate(sender: UISwitch) {
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        print("textview is no longer 1st responder")
        view.endEditing(true)
    }
    
    func handleTitle() -> String? {
        if noteTitle.text == "" {
            return "New Note"
        } else {
            return noteTitle.text!
        }
    }
}
