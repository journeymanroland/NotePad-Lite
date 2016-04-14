//
//  BetaNote.swift
//  simple notepad
//
//  Created by Roland Gill on 1/7/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import Foundation
import EventKit

class BetaNote: NSObject, NSCoding {
    var title: String?
    var contents: String?
    private var uuid: String = NSUUID().UUIDString // unique id for each note
    let dateWritten = NSDate()
    var isReminder: Bool = false
    // Data Persistance capabilities
    @objc required init?(coder aDecoder: NSCoder) {
        
        if let archivedTitle = aDecoder.decodeObjectForKey("title") as? String {
            self.title = archivedTitle
        }
        
        if let archivedContents = aDecoder.decodeObjectForKey("contents") as? String {
            self.contents = archivedContents
        }
        
        if let archivedUuid = aDecoder.decodeObjectForKey("uuid") as? String {
            self.uuid = archivedUuid
        }
        
        if let archivedReminder = aDecoder.decodeObjectForKey("isReminder") as? Bool {
            self.isReminder = archivedReminder
        }


    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(contents, forKey: "contents")
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(dateWritten, forKey: "dateWritten")
        aCoder.encodeObject(isReminder, forKey: "isReminder")
    }
    
    convenience override init() {
        self.init(title: "New Task", contents: "", isReminder: false)
    }
    
    init(title: String, contents: String?, isReminder: Bool) {
        super.init()
        self.title = title
        self.contents = contents
        self.isReminder = isReminder
        
    }
    
    func getUUID() -> String {
        return self.uuid
    }
    
    func setUUID(newId: String) {
        self.uuid = newId
    }
    
}

