//
//  Response.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 07/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class Response: NSObject {
    var Status:Int = 0
    var Message:String = ""
    
    init(json:JSON){
        Status = json["Status"].intValue
        Message = json["Message"].stringValue
    }
}


