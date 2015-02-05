//
//  StudentCourseLinksWebViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 03/02/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class StudentCourseLinksWebViewController: UIViewController, UIWebViewDelegate {

    var webView = UIWebView()
    var tutor = Tutor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let requestURL = NSURL(string: URL())
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
        webView.delegate = self
        
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(webView)
        
        webView.addTopConstraint(toView: webView.superview, relation: NSLayoutRelation.Equal, constant: 0)
        webView.addRightConstraint(toView: webView.superview, relation: NSLayoutRelation.Equal, constant: 0)
        webView.addBottomConstraint(toView: webView.superview, relation: NSLayoutRelation.Equal, constant: 0)
        webView.addLeftConstraint(toView: webView.superview, relation: NSLayoutRelation.Equal, constant: 0)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: "close")
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "\(tutor.Name)'s Lessons"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func URL() -> String{
        return Tools.Domain() + "/sections/frames/lesson_slots.aspx?from=defaultlessontimes&tp=tutor&tutorid=\(tutor.PersonID)&clientid=\(session.client.ClientID)&auth=0CCAAC112"
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        Tools.AddLoaderToView(webView.superview!)
        webView.hidden = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        Tools.HideLoaderFromView(webView.superview!)
        webView.hidden = false
    }

}
