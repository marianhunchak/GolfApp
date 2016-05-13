//
//  MainCollectionController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "menuCollectionCell"
private let nibNameMenuCollectionCell = "MenuCollectionCell"
private let nameOfbackroundImage = "a_home"
private let identifierOfListTableController = "ListTableController"

class MainCollectionController: UICollectionViewController  {
    
    var profile:Profile?
    
    var myCustomSubview : ContactSubView?
    var categories : ContactSubView = ContactSubView.loadViewFromNib()
    
    var teeTimeSubView : TeeTimeSubView?
    var teeTime : TeeTimeSubView = TeeTimeSubView.loadViewFromNib()
    
    var lTopInset : CGFloat?
    var menuFilesNameArray = ["hm_tee_time_btn", "hm_rest_btn", "hm_events_btn",
                              "hm_proshp_btn", "hm_courses_btn", "hm_pros_btn",
                              "hm_contact_btn", "hm_news_btn", "hm_htls_btn"]
    var menuItemsImgArray = ["a_tee_time", "a_restaurant", "a_events", "a_proshop", "a_courses", "a_pros", "a_contact", "a_news", "a_hotel"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lTopInset = self.view.frame.size.height / 2.0
        let backroundImage = UIImageView.init(image: UIImage.init(named:nameOfbackroundImage))
        backroundImage.frame = self.view.frame
        self.collectionView?.backgroundView = backroundImage
        let nib = UINib(nibName: nibNameMenuCollectionCell, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        NetworkManager.sharedInstance.getProfileAndAvertising { (pProfile) in
//            self.profile = pProfile
            self.categories.profile = pProfile
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MenuCollectionCell
        cell.menuLabel.text =  LocalisationDocument.sharedInstance.getStringWhinName(menuFilesNameArray[indexPath.row])
        cell.menuImageView.image = UIImage(named: menuItemsImgArray[indexPath.row])
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 6 {
            showContactSubView()
        }
        if indexPath.item == 4{
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier(identifierOfListTableController)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if indexPath.item == 0 {
        
            showTeeTimeSubView()
        
        }
    }
}

extension MainCollectionController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let lCellWidth:CGFloat = self.view.frame.width / 3.0 - 10.0;
        let lcellHeigt:CGFloat = (self.view.frame.height - lTopInset!) / 3.0 - 15.0 
        return CGSize(width: lCellWidth, height: lcellHeigt)
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: lTopInset!, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    func showContactSubView() {
            categories.center = self.view.center
            categories.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
            self.view.addSubview(categories)
            categories.alpha = 0
            self.collectionView!.addSubview(categories)
            UIView.animateWithDuration(1) { () -> Void in
                self.categories.alpha = 1
            }
    }
    
    func showTeeTimeSubView() {
        teeTime.center = self.view.center
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(teeTime)
        teeTime.alpha = 0
        self.collectionView!.addSubview(teeTime)
        UIView.animateWithDuration(1) { () -> Void in
            self.teeTime.alpha = 1
        }
    }
}
