//
//  ViewController.m
//  BDFlickrDemo
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "ViewController.h"
#import <BDFlickr/BDFlickr.h>
#import "PhotoViewController.h"
#import "SortViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()
@property (nonatomic, weak) APIEngine* apiEngine;
@property (nonatomic, weak) MBProgressHUD* hud;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photos";
    self.dataArray = [[NSMutableArray alloc] init];
    self.apiEngine = [APIEngine sharedManager];
    self.apiEngine.delegate = self;
    [self.apiEngine setAPIKey:@"db7cd8d6c6b6d0432c6f5495d5b42a7d"];

    //show a progress bar while we wait for the API to download and pass images back.
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Fetching images...";
    self.hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    
    //2 mode options : FETCH_ONE_BY_ONE or FETCH_ALL_AT_ONCE
    //Returns the most recent uploaded images to Flickr. Potentially NSFW
    //Can set the number of images to be returned and what page to source them
    [self.apiEngine fetchRecentImageswithMode:FETCH_ONE_BY_ONE perPage:@"20" pageNo:@"1"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *myPhoto = [self.dataArray objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView * myImg =(UIImageView *)[cell viewWithTag:101];
    myImg.image = myPhoto.image;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItemIndex = indexPath.row;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPhoto"])
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        PhotoViewController *destViewController = segue.destinationViewController;
        destViewController.photoDetails = [self.dataArray objectAtIndex:indexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"showSort"])
    {
        SortViewController *sortViewController = segue.destinationViewController;
        sortViewController.arrayToBeSorted = self.dataArray;
    }
    
}



#pragma mark - APIDelegate methods

//Delegate method called when the mode is FETCH_ALL_AT_ONCE
- (void)imagesReceived:(NSArray *)photos error:(NSError *)error
{

    dispatch_async(dispatch_get_main_queue(), ^(){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    self.dataArray = [[NSMutableArray alloc] initWithArray: photos];

    [self.collectionView reloadData];
}

//Delegate method called when the mode is FETCH_ONE_BY_ONE
- (void)singleImageReceived:(Photo *)photo error:(NSError *)error
{
    if (self.hud.alpha >= 1) // if the hud is visible and not being animated off screen already
    {
        dispatch_async(dispatch_get_main_queue(), ^(){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }

    [self.dataArray addObject:photo];
    [self.collectionView reloadData];
}


@end
