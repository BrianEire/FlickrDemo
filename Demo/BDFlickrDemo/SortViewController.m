//
//  SortViewController.m
//  BDFlickr
//
//  Created by BD on 16/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "SortViewController.h"
#import <BDFlickr/Photo.h>

@interface SortViewController ()

@property NSArray* sortedArray1;
@property NSArray* sortedArray2;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sorted Arrays";

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_semaphore_t notified = dispatch_semaphore_create(0);
    
    dispatch_group_t myGroup = dispatch_group_create();
    dispatch_group_async(myGroup, queue, ^{
        @synchronized(self.arrayToBeSorted) {
            self.sortedArray1 = [self quickSort:[self.arrayToBeSorted mutableCopy]withSortOrder:NSOrderedDescending];

        }
        
    });
    
    dispatch_group_async(myGroup, queue, ^{
        @synchronized(self.arrayToBeSorted) {
            self.sortedArray2 = [self quickSort:[self.arrayToBeSorted mutableCopy] withSortOrder:NSOrderedAscending];

        }
        
    });
    
    
    
    dispatch_group_notify(myGroup, queue, ^{
        // done
        dispatch_semaphore_signal(notified);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self printPhotoTitlesToScreen:[self.sortedArray1 mutableCopy] onScreenSide:LEFT_SIDE_SCREEN];
            [self printPhotoTitlesToScreen:[self.sortedArray2 mutableCopy] onScreenSide:RIGHT_SIDE_SCREEN];
            
        });
    });
    
    
    dispatch_semaphore_wait(notified, DISPATCH_TIME_FOREVER);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *)quickSort:(NSMutableArray *)unsortedDataArray withSortOrder:(NSInteger) sortOrder
{
    
    NSMutableArray *lessArray = [[NSMutableArray alloc] init];
    NSMutableArray *greaterArray =[[NSMutableArray alloc] init];
    if ([unsortedDataArray count] <1)
    {
        return nil;
    }
    int randomPivotPoint = arc4random() % [unsortedDataArray count];
    Photo *aPhoto = [unsortedDataArray objectAtIndex:randomPivotPoint];
    NSString *pivotValue = aPhoto.title;
    [unsortedDataArray removeObjectAtIndex:randomPivotPoint];
    for (Photo *myPhoto in unsortedDataArray)
    {
        //quickSortCount++; //This is required to see how many iterations does it take to sort the array using quick sort
        
        NSComparisonResult result = [pivotValue compare:myPhoto.title];
        
        if (result == sortOrder)
        {
            [lessArray addObject:myPhoto];
        }
        else
        {
            [greaterArray addObject:myPhoto];
        }
    }
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    [sortedArray addObjectsFromArray:[self quickSort:lessArray withSortOrder:sortOrder]];
    [sortedArray addObject:aPhoto];
    [sortedArray addObjectsFromArray:[self quickSort:greaterArray withSortOrder:sortOrder]];
    
    
    return sortedArray;
}

-(void) printPhotoTitlesToScreen:(NSMutableArray *)sortedDataArray onScreenSide:(ScreenSide)side;
{
    int frameX;
    int frameWidth =self.view.bounds.size.width/2;
    int frameY = 5;
    
    if (side==LEFT_SIDE_SCREEN)
    {
        frameX = 0;
        
    }
    else
    {
        frameX = (self.view.bounds.size.width/2);
    }
    
    for (Photo *myPhoto in sortedDataArray)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frameX, frameY, frameWidth, 20)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = myPhoto.title;
        titleLabel.textColor = [UIColor whiteColor];
        if ([myPhoto.title isEqualToString:@""])
        {
            titleLabel.text = @"(empty title)";
        }
        
        [self.view addSubview:titleLabel];
        frameY+=20;
    }
}


@end
