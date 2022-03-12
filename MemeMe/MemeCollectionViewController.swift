//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Michal Majernik on 3/10/22.
//

import Foundation
import UIKit


class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var memeCollectionView: UICollectionView!
    
    let imageDimension = 150.0
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numOfImages = getNumOfImagesPerRow()
        
        let space:CGFloat = 3.0
        let dimension = getCellDimension(numberOfImages: numOfImages, space: space)

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memeCollectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
 
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        openDetailView(meme)
    }
    
    func openDetailView(_ meme: Meme) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        controller.meme = meme
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func showAddView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func getNumOfImagesPerRow() -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return CGFloat(floor(view.frame.size.width / imageDimension))
        }
        return CGFloat(floor(view.frame.size.height / imageDimension))
    }
    
    func getCellDimension(numberOfImages: CGFloat, space: CGFloat) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return (view.frame.size.width - (2 * space)) / numberOfImages
        }
        return (view.frame.size.height - (2 * space)) / numberOfImages
    }
}
