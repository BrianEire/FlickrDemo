//
//  ViewController.h
//  BDFlickrDemo
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDFlickr/BDFlickr.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, APIEngineDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (assign) NSInteger selectedItemIndex;

//- (void)imagesReceived:(NSArray *)photos error:(NSError *)error;
//- (void)singleImageReceived:(Photo *)photo error:(NSError *)error;

@end

