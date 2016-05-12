//
//  DetailmageTableCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/9/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCollectionCell"
private let nibNameImageCollectionCell = "ImageCollectionCell"
private let identifierOfCollectionCell = "imageCollectionCell"


class DetailmageTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagesArray  = [NSDictionary]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let nib = UINib(nibName: nibNameImageCollectionCell, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier:identifierOfCollectionCell)
        self.collectionView.layer.masksToBounds = true
        self.collectionView.layer.cornerRadius = 5.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if imagesArray.count == 0 {
        
            return 1
        }
        
        return self.imagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifierOfCollectionCell, forIndexPath: indexPath) as! ImageCollectionCell
        
        if self.imagesArray.count > 0 {
        let imageURL = NSURL.init(string: self.imagesArray[indexPath.row]["url"] as! String)
        let imageName = self.imagesArray[indexPath.row]["name"] as! String
        NetworkManager.sharedInstance.getImageWhihURL(imageURL!, imageName: imageName, completion: { (image) in
            
            if let lImage = image {
                cell.cellImageView.image = lImage
            }
        })
        } else {
            cell.cellImageView.image = UIImage(named: "a_place_holder_detail_page")
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let lCell = cell as! ImageCollectionCell
            lCell.pageControl.numberOfPages = self.imagesArray.count
            lCell.pageControl.currentPage = indexPath.row
    }
}
