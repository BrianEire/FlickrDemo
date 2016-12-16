//
//  SortViewController.h
//  BDFlickr
//
//  Created by BD on 16/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    RIGHT_SIDE_SCREEN,
    LEFT_SIDE_SCREEN,
} ScreenSide;

@interface SortViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrayToBeSorted;

@end
