//
//  PadPersistence.swift
//  NotePad Lite
//
//  Created by Roland Gill on 3/19/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import Foundation

private let SingletonSharedInstance = PadPersistence()

class PadPersistence {
    private let userDefaultsKey = "AllNotes"
    
    class var sharedInstance : PadPersistence { // create singleton for class 
        return SingletonSharedInstance
    }
    
    func persistData(poem: BetaNote) {
        // Retrieve the saved notes.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var noteGroup: [BetaNote]
        if let poemsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            noteGroup = NSKeyedUnarchiver.unarchiveObjectWithData(poemsArchived as! NSData) as! [BetaNote]
        } else {
            noteGroup = []
        }
        
        // Append the newly created note.
        noteGroup.insert(poem, atIndex: 0)
        
        // Save the notes.
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(noteGroup), forKey: userDefaultsKey)
    }
    
    func overwriteData(notes: [BetaNote]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(notes), forKey: userDefaultsKey)
    }
    
    // Retrieve the poems.
    func retrieveData() -> [BetaNote] {
        var poems: [BetaNote]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let poemsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            poems = NSKeyedUnarchiver.unarchiveObjectWithData(poemsArchived as! NSData) as! [BetaNote]
        } else {
            poems = []
        }
        return poems
    }
    
    func noteEdited(noteSelected: BetaNote) {
        var allNotes = PadPersistence.sharedInstance.retrieveData()
        var i = 0
        while i < allNotes.count {
            if noteSelected.getUUID() == allNotes[i].getUUID() {
                allNotes[i] = noteSelected
            }
            i = i + 1
        }
        overwriteData(allNotes)
    }
    
}
