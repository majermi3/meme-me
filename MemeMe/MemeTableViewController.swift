//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Michal Majernik on 3/10/22.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMemes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let memes = getMemes()
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"
        
        return cell
    }
    
    func getMemes() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    @IBAction func showAddView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
