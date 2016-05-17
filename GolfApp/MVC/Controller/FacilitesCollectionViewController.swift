//
//  FacilitesCollectionViewController.swift
//  GolfApp
//
//  Created by Admin on 13.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var nibNameFacilitesCollectionCell = "FacilitesCollectionCell"
private var facilitesCollectionCellIdentifier = "FacilitesCollectionCell"

class FacilitesCollectionViewController: BaseViewController , UICollectionViewDelegate ,UICollectionViewDataSource
 {
    
    var facilitesItemsImgOnArray = ["facilites_club_house_", "facilites_practice_",   "facilites_pitching_",
                                  "facilites_putting_" ,     "facilites_buggy_",      "facilites_club_hire_",
                                  "facilites_proshop_",      "facilites_pro_",        "facilites_changing_room_",
                                  "facilites_wifi_" ,        "facilites_restaurant_", "facilites_hotel_on_site_",
                                  "facilites_poll_" ,        "facilites_tennis_",     "facilites_parking_"]
 
    
    var facilitesItemNameArray = ["Club house" , "Practice",    "Pitching",
                                  "Putting" ,    "Buggy",       "Club Hire" ,
                                  "Proshop" ,    "Pros" ,       "Shower"  ,
                                  "Wi-fi",       "Restaurant",  "Hotel" ,
                                  "Pool",        "Tennis",      "Parking"]
    
    var facilitiesLocalisNames = ["crs_club_house_icon", "crs_practice_icon",   "crs_pitching_icon",
                                  "crs_putting_icon",    "crs_buggy_icon",      "crs_club_hire_icon",
                                  "crs_proshop_icon",    "crs_pros_icon",       "crs_shower_icon",
                                  "crs_wifi_icon",       "crs_restaurant_icon", "crs_hotel_icon",
                                  "crs_pool_icon",       "crs_tennis_icon",     "crs_parking_icon"]
                                  
                                  
    
    var facilites = [String]()
    
    var lTopInset : CGFloat?
    
    
    @IBOutlet weak var facilitesCollectonView: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_facilities_details_nav_bar")
        backgroundCollectionView.layer.cornerRadius = 5
        
        let nib = UINib(nibName: nibNameFacilitesCollectionCell, bundle: nil)
        self.facilitesCollectonView?.registerNib(nib, forCellWithReuseIdentifier: facilitesCollectionCellIdentifier)
    }

    //MARK:UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return facilitesItemNameArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(facilitesCollectionCellIdentifier, forIndexPath: indexPath) as! FacilitesCollectionCell
        var imgName = facilitesItemsImgOnArray[indexPath.row]
        
        if self.facilites.contains(facilitesItemNameArray[indexPath.row]) {
            
            imgName += "on"
        } else {
            imgName += "off"
        }
        cell.facilitesCellImage.image = UIImage(named: imgName)
        let name = facilitiesLocalisNames[indexPath.row]
        cell.facilitesCellLabel.text = LocalisationDocument.sharedInstance.getStringWhinName(name)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let lCellWidth:CGFloat = self.view.frame.width / 3.0 - 32.0
        let lcellHeigt:CGFloat = (self.view.frame.height) / 5.0 - 30
        
        return CGSize(width: lCellWidth, height: lcellHeigt)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: -50.0, left: 20.0, bottom: 0.0, right: 20.0)
    }
}
