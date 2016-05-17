//
//  DetailmageTableCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/9/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

    // MARK: - Constants

private let reuseIdentifier = "imageCollectionCell"
private let nibNameImageCollectionCell = "ImageCollectionCell"
private let identifierOfCollectionCell = "imageCollectionCell"
private let defaultImageNameInCell = "a_place_holder_detail_page"


class DetailmageTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - Connections outlet elements DetailmageTableCell
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imagesArray  = [Image]() {
        didSet {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.imagesArray.count
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let nib = UINib(nibName: nibNameImageCollectionCell, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier:identifierOfCollectionCell)
        
        self.collectionView.layer.masksToBounds = true
        self.collectionView.layer.cornerRadius = 5.0
        self.collectionView.backgroundColor = Global.viewsBackgroundColor
        self.bringSubviewToFront(self.pageControl)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - CollectionViewdata source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if imagesArray.count == 0 {
            return 1
        }
        return self.imagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifierOfCollectionCell, forIndexPath: indexPath) as! ImageCollectionCell
        cell.cellImageView.image = UIImage(named: defaultImageNameInCell)
        
        if self.imagesArray.count > 0 {
            
        let lImage = imagesArray[indexPath.row]

        NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: lImage.url!)!, imageName: lImage.name!, completion: {
            (image) in
            
            if let lImage = image {
                cell.cellImageView.image = lImage
            }
        })
        }

        return cell
    }

    // MARK: - Settings for DetailmageTableCell
    
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        self.pageControl.currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
    }
    
}
