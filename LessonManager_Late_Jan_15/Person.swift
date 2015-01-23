//
//  Person.swift
//  LessonManagerSwift
//
//  Created by Alex Bechmann on 24/10/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

class Person: NSObject {
   
    var PersonID: Int = 0;
    var Name: String = "";
    var UserName: String = ""
    var Password: String = ""
    var Phone: String = ""
    var Mobile: String = ""
    var Email: String = ""
    var AccountType:Int = 0
    var Active: String = "N"
    //var Lessons: Dictionary<NSDate, Array<Lesson>> = Dictionary<NSDate, Array<Lesson>>()
    
    func setProperties(json:JSON){
        self.Phone = json["Telephone"].stringValue
        self.Mobile = json["Mobile"].stringValue
        self.Email = json["Email"].stringValue
        self.UserName = json["UserName"].stringValue
        self.Password = json["Password"].stringValue
        self.AccountType = json["AccountType"].intValue
        self.Active = json["Active"].string == nil ? "N" : json["Active"].stringValue
    }
}




