//
//  VideoCell.swift
//  Youtube_Test_Programatically
//
//  Created by Fernando Cardenas on 17/07/16.
//  Copyright © 2016 Fernando. All rights reserved.
//

import UIKit

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet{
            titleLabel.text = video?.title
            
            setupThumbnailImage()
            setupProfileImage()
            
            if let channelName = video?.channel?.name, numberOfViews = video?.number_of_views {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                
                let subtitleText = "\(channelName) - \(numberFormatter.stringFromNumber(numberOfViews)!) - 2 years ago"
                subtitleTextView.text = subtitleText
            }
            
            //Measure the title text
            //It sets different contraints heights when the text is either short or long.
            if let title = video?.title {
                //For the height an arbitrary huge number
                let size = CGSizeMake(frame.width - 16 - 44 - 8 - 16, 1000)
                let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
                
                if estimatedRect.size.height > 20 {
                    titleHeightConstraint?.constant = 44
                }
                else{
                    titleHeightConstraint?.constant = 20
                }
                
            }
            
        }
    }
    
    func setupProfileImage() {
        if let profileImageURL = video?.channel?.profile_image_name{
            userProfileImageView.loadImageUsingString(profileImageURL)
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageURL = video?.thumbnail_image_name {
            thumbnailImageView.loadImageUsingString(thumbnailImageURL)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "swift-youtube")
        
        //When no image assigned we could use the following to test the layout
        //imageView.backgroundColor = UIColor.blueColor()
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_profile")
        
        //The image is displayed in a circle form
        //Half of the width and height, Width and height equal to 44.
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Black Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEVO - 1,604,586,092 views - 2 years ago"
        textView.textColor = UIColor.grayColor()
        //Text Views have some pixels that we need to remake
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        
        return textView
    }()
    
    let sepatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    var titleHeightConstraint: NSLayoutConstraint?
    
    override func setUpViews() {
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(sepatorView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        //Cleaner way to do it
        
        addConstrainstWithFormat("H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstrainstWithFormat("H:|-16-[v0(44)]", views: userProfileImageView)
        
        addConstrainstWithFormat("V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView,userProfileImageView, sepatorView)
        addConstrainstWithFormat("H:|[v0]|", views: sepatorView)
        
        //Constraints for Title Label
        //Top
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Bottom, multiplier: 1, constant: 8))
        
        //Left
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: userProfileImageView, attribute: .Right, multiplier: 1, constant: 8))
        
        //Right
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        
        //Height
        /*
        titleHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 20)
         */
        titleHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 44)
        addConstraint(titleHeightConstraint!)
        
        //Constraints for SubTitle Text View
        //Top
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1, constant: 4))
        
        //Left
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .Left, relatedBy: .Equal, toItem: userProfileImageView, attribute: .Right, multiplier: 1, constant: 8))
        
        //Right
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        
        //Height
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 30))
        
        
        /*One way to do it
         //Add Padding to Thumbnail Image
         addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : thumbnailImageView]))
         addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : thumbnailImageView]))
         
         //Add Constraints to Seperator Line
         addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : sepatorView]))
         addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : sepatorView]))
         */
    }
}
