//
//  MemeTableCustomCell.swift
//  MemeMe
//
//  Created by Michal Majernik on 3/10/22.
//

import Foundation
import UIKit


class MemeTableCustomCell: UITableViewCell {
    var title: String?
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var mainImageView: UIImageView!
    
}
