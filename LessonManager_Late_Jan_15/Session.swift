//
//  Session.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 30/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

protocol SessionDelegate{
    func masterNeedsUpdate()
}

class Session: NSObject {
    var tutor:Tutor = Tutor()
    var client:Client = Client()
    //var activeViewController:AnyObject? = nil
    //var delegates:Array<SessionDelegate> = []
    var agendaMasterDelegate:SessionDelegate? = nil
}
