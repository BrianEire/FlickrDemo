//
//  PhotoViewController.m
//  BDFlickrDemo
//
//  Created by BD on 16/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.image = self.photoDetails.image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
