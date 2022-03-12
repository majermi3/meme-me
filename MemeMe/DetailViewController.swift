//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Gökce Hatipoglu Majernik on 3/11/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }
}
