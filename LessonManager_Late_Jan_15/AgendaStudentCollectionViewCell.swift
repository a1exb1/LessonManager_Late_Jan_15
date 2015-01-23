//
//  AgendaStudentCollectionViewCell.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 01/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class AgendaStudentCollectionViewCell: UICollectionViewCell {

    var student:Student? = nil
    @IBOutlet weak var studentNameLabel: UILabel!
    
    func setup(student:Student){
        self.student = student
        self.studentNameLabel.text = student.Name
    }

}
