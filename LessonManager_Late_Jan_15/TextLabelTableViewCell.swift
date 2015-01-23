//
//  TextLabelTableViewCell.swift
//  LessonManagerSwift
//
//  Created by Alex Bechmann on 25/10/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

class TextLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var input: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
