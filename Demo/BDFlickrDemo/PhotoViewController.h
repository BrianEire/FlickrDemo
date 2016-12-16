//
//  PhotoViewController.h
//  BDFlickrDemo
//
//  Created by BD on 16/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDFlickr/BDFlickr.h>

@interface PhotoViewController : UIViewController
@property (nonatomic, strong) Photo *photoDetails;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;

@end
