//
//  NotepadTableViewController.swift
//  simple notepad
//
//  Created by Roland Gill on 12/29/15.
//  Copyright © 2015 Roland Gill. All rights reserved.
//

import UIKit
import EventKit

class EventStore: EKEventStore { // singleton of EKEventStore database
    static let sharedInstance = EKEventStore()
}

extension NotepadTableViewController: UISearchResultsUpdating {
    // UISearchResultsUpdating delegate method
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterNotesBySearch(searchController.searchBar.text!)
    }

}

class NotepadTableViewController: UITableViewController/*, UISearchResultsUpdating*/ {
     // models
    var notePad = [BetaNote]()
    var searchedNotes = [BetaNote]()
    var allCalendars = [EKCalendar]()
    //var listOfReminders = [EKReminder]()
    let calendarActions = CalendarActions()
    
    // constants
    let alertMsg = "To create reminders, the app must be permitted to access reminders, make sure to grant permission in Settings and try again"
    let eventStore = EventStore.sharedInstance
    let cellReuseIdentifier = "NotepadCell"
    let searchCtrlr = UISearchController(searchResultsController: nil)

    // outlets
    
    // VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarActions.checkCalAuth()
        notePad = PadPersistence.sharedInstance.retrieveData()
        
        // UI
        navigationItem.leftBarButtonItem = editButtonItem()

        
        
        searchCtrlr.searchResultsUpdater = self
        searchCtrlr.hidesNavigationBarDuringPresentation = false
        searchCtrlr.dimsBackgroundDuringPresentation = false
        searchCtrlr.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchCtrlr.searchBar
    }
    
    override func viewDidAppear(animated: Bool) {
        //print(PadPersistence.sharedInstance.retrieveData())
        notePad = PadPersistence.sharedInstance.retrieveData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject?) {
        // pass note data along to next view controller
        if segue.identifier == "noteContents" {
            if let noteContentsViewController =
                segue.destinationViewController as? NoteContentsViewController,
                cell = sender as? UITableViewCell,
                indexPath = self.tableView.indexPathForCell(cell) {
                    let n = notePad[indexPath.row]
                noteContentsViewController.selectedNote = n // send note to next VC

            }
        }
    }
    
    // tableview delegate methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NotepadCell", forIndexPath: indexPath)
        let titles = notePad.map { $0.title! } // show titles of each note object
        let searchedTitles = searchedNotes.map { $0.title! }
        if searchCtrlr.active && searchCtrlr.searchBar.text != "" {
            cell.textLabel?.text = "\(searchedTitles[indexPath.row])" // configure cell label
        } else {
            cell.textLabel?.text = "\(titles[indexPath.row])"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchCtrlr.active && searchCtrlr.searchBar.text != "" {
            return searchedNotes.count
        }
        return notePad.count
        
    }
    
    // should cells be editable?
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // implement swipe to delete interface
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let noteToDelete = notePad[indexPath.row] // Delete the row from the data source
            
            // Remove the poem and reload the table view.
            notePad = notePad.filter { $0 != noteToDelete }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Archive and save the poems again.
            PadPersistence.sharedInstance.overwriteData(notePad)
        }
    }
    
    func calendarUnaccessible(determine: Bool) {
        let alertIfDenied = UIAlertController(title: "Are you sure?", message: self.alertMsg, preferredStyle: .Alert)
        self.presentViewController(alertIfDenied, animated: true, completion: nil)
    }
    
    
    func filterNotesBySearch(txtQuery: String) {
        
        searchedNotes = notePad.filter({ note in
            //if let search = note.title {
            return note.title!.lowercaseString.containsString(txtQuery.lowercaseString)
            //}
        })
        tableView.reloadData()
    }
    
}
    





