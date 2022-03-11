//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Michal Majernik on 3/10/22.
//

import Foundation
import UIKit


class MemeCollectionViewController: UICollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMemes().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let memes = getMemes()
        let meme = memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
 
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
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
