//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Michal Majernik on 3/10/22.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCustomCell") as! MemeTableCustomCell
        let meme = memes[indexPath.row]
        
        cell.mainImageView.image = meme.memedImage
        cell.textView.text = "\(meme.topText) ... \(meme.bottomText)"
        
        return cell
    }
    
    @IBAction func showAddView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
