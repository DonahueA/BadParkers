//
//  Comment.swift
//  BadParkers
//
//  Created by Donahue Avila on 4/15/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import Foundation


struct Comment: Comparable {
    static func <(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.date == rhs.date
    }
    
    var Author: String
    var Comment: String
    var date: Date
    
}
