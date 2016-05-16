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

class FacilitesCollectionViewController: UIViewController , UICollectionViewDelegate ,UICollectionViewDataSource
 {
    
    var facilitesItemsImgOnArray = ["facilites_club_house_on", "facilites_practice_on",   "facilites_pitching_on",
                                  "facilites_putting_on" ,     "facilites_buggy_on",      "facilites_club_hire_on",
                                  "facilites_proshop_on",      "facilites_pro_on",        "facilites_changing_room_on",
                                  "facilites_wifi_on" ,        "facilites_restaurant_on", "facilites_hotel_on_site_on",
                                  "facilites_poll_on" ,        "facilites_tennis_on",     "facilites_parking_on"]
    
    var facilitesItemsImgOfArray = ["facilites_club_house_off", "facilites_practice_off",   "facilites_pitching_off",
                                  "facilites_putting_off" ,     "facilites_buggy_off",      "facilites_club_hire_off",
                                  "facilites_proshop_off",      "facilites_pro_off",        "facilites_changing_room_off",
                                  "facilites_wifi_off" ,        "facilites_restaurant_off", "facilites_hotel_on_site_off",
                                  "facilites_poll_off" ,        "facilites_tennis_off",     "facilites_parking_off"]
    
    var facilitesItemNameArray = ["Club house", "Practice",    "Pitching",
                                  "Putting",    "Buggy",       "Location",
                                  "Proshop",    "Pros",        "Vestiaire",
                                  "Wifi",       "Restaurant",  "Hotel",
                                  "Piscine",    "Tennis",      "Parking"]
    
    var facilitesOnItemsImgArray = [String]()
    
    var lTopInset : CGFloat?
    
    
    @IBOutlet weak var facilitesCollectonView: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        cell.facilitesCellImage.image = UIImage(named: facilitesItemsImgOfArray[indexPath.row])
        cell.facilitesCellLabel.text = facilitesItemNameArray[indexPath.row]
        
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
