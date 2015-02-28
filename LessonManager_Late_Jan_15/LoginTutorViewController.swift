//
//  LoginTableViewController.swift
//  LessonManagerSwift
//
//  Created by Alex Bechmann on 24/10/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

protocol LoginDelegate{
    func didLogin()
}

class LoginTutorTableViewController : EditingTableViewController{
    
    var tutor = Tutor()
    var loginDelegate:LoginDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var username:String? = Tools.GetValueFromPlist("LMdata", value: "login_tutor_username")
        var password:String? = Tools.GetValueFromPlist("LMdata", value: "login_tutor_password")

        if Tools.HasValue(username) && Tools.HasValue(password){
            tutor.UserName = username!
            tutor.Password = password!
            //login(username!, password: password!)
            
        }
    }

    override func itemsForEditingTableView() -> Array<Array<editingTableViewItem>> {
        var rc = Array<Array<editingTableViewItem>>()
        rc.append(
            [
                editingTableViewItem(textLabelText: "Username", detailTextLabelText: tutor.UserName, textFieldIdentifier: "Username", keyboardType: nil, editingType: nil, date: nil),
                editingTableViewItem(textLabelText: "Password", detailTextLabelText: tutor.Password, textFieldIdentifier: "Password", keyboardType: nil, editingType: nil, date: nil)
            ]
        )
        
        rc.append(
            [
                editingTableViewItem(textLabelText: "Login", detailTextLabelText: "", textFieldIdentifier: "Login", keyboardType: nil, editingType:EditingType.Button, date: nil)
            ]
        )
        return rc
    }

    override func editingTableView(tableView: UITableView, didSelectRowWithIdentifier identifier: String){
        if identifier == "Login"{
            login(tutor.UserName, password: tutor.Password)
        }
    }
    
    override func editingTextFieldDidChange(identifier: String, value: String) {
        if identifier == "Username"{
            tutor.UserName = value
        }
        if identifier == "Password"{
            tutor.Password = value
        }
    }
    
    func login(username:String, password:String){
        tutor.Login(username, password: password){ response in
            
            Tools.SetValueInPlist("LMdata", key: "login_tutor_username", value: username)
            Tools.SetValueInPlist("LMdata", key: "login_tutor_password", value: password)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            self.loginDelegate?.didLogin()
        }
    }
    
}
