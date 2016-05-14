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
private let nameForBackgroundImage = "a_home"
private let identifierOfListTableController = "ListTableController"

class MainCollectionController: UICollectionViewController  {
    
    var profile:Profile?
    var lTopInset : CGFloat?
    var menuFilesNameArray = ["hm_tee_time_btn", "hm_rest_btn",    "hm_events_btn",
                              "hm_proshp_btn",   "hm_courses_btn", "hm_pros_btn",
                              "hm_contact_btn",  "hm_news_btn",    "hm_htls_btn"]
    
    var menuItemsImgArray = ["a_tee_time", "a_restaurant", "a_events", "a_proshop", "a_courses", "a_pros", "a_contact", "a_news", "a_hotel"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lTopInset = self.view.center.y
        let backroundImage = UIImageView.init(image: UIImage.init(named:nameForBackgroundImage))
        backroundImage.frame = self.view.frame
        self.collectionView?.backgroundView = backroundImage
        
        let nib = UINib(nibName: nibNameMenuCollectionCell, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        NetworkManager.sharedInstance.getProfileAndAvertising { (pProfile) in
            self.profile = pProfile
        }
        
    }
    
    //MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MenuCollectionCell
        cell.menuLabel.text =  LocalisationDocument.sharedInstance.getStringWhinName(menuFilesNameArray[indexPath.row])
        cell.menuImageView.image = UIImage(named: menuItemsImgArray[indexPath.row])
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == 6 {
            showContactSubView()
        }
        if indexPath.item == 4 {
            
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
    
    //MARK: Private methods
    
    func showContactSubView() {
        
        let contact = ContactView.loadViewFromNib()
        contact.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(contact)
        contact.profile = profile
        contact.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            contact.alpha = 1
        }
    }
    
    func showTeeTimeSubView() {
    
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }
}
