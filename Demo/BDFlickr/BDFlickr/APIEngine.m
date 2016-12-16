//
//  APIEngine.m
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "APIEngine.h"
#import "NetworkManager.h"
#import "SDKConstants.h"

@interface APIEngine ()
@property NetworkManager* networkManager;
@property NSString* apiKey;
@property NSMutableArray* photoArray;
@property NSArray* resultPhotoArray;
@end

@implementation APIEngine

+ (id)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.networkManager = [NetworkManager sharedManager];
    }
    return self;
}

- (void)setAPIKey:(NSString*)APIKey
{
    self.apiKey = APIKey;
}

// interface point with the client. Check for an API Uses the network manage to make a GET call and then serialize the JSON responce and pass in to the Model.
- (void) fetchRecentImageswithMode:(FetchMode)mode perPage:(NSString*)perPage pageNo:(NSString*)pageNo
{
    if (self.apiKey == nil)
    {
        NSLog(@"Please call setAPIKey: with the API key first");
        return;
    }
    
    self.resultPhotoArray = [[NSArray alloc] init];
    
    NSString* URL = [NSString stringWithFormat:FLIKR_RECENT_ENDPOINT, @"flickr.photos.getRecent", perPage, pageNo,self.apiKey];
    
    [self.networkManager submitGETrequest:URL params:nil customHeaders:nil success:^(NSData *data) {
        // parse the category data here and return array
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        FlickrData* flickrData = [[FlickrData alloc] initWithDictionary:responseDict];
        
        if ([flickrData.stat isEqualToString:@"ok"])
        {
            if (flickrData.photos.photo.count > 0){
                self.photoArray = [[NSMutableArray alloc] init];
                self.resultPhotoArray = flickrData.photos.photo;
                
                [self downloadPhotos:flickrData.photos.photo mode:mode];
                
            }
            
        }
        
    } failure:^(NSData *data, NSError *error) {
        if (mode == FETCH_ONE_BY_ONE)
        {
            SEL selector = NSSelectorFromString(@"singleImageReceived:error:");
            if ([self.delegate respondsToSelector:selector])
            {
                [self.delegate singleImageReceived:nil error:error];
            }
        }
        else
        {
            SEL selector = NSSelectorFromString(@"imagesReceived:error:");
            if ([self.delegate respondsToSelector:selector])
            {
                [self.delegate imagesReceived:nil error:error];
            }
        }
    }];
}


// The first Flickr API didnt give us all the required details about the image so we need to call again and request more.
- (void) fetchImageDetails:(NSString *)imageId completion:(void (^)(NSString* description, NSString* datePosted))completionBlock
{
    
    NSString* URL = [NSString stringWithFormat:FLIKR_IMG_DETAILS, @"flickr.photos.getInfo", imageId, self.apiKey];
    
    [self.networkManager submitGETrequest:URL params:nil customHeaders:nil success:^(NSData *data) {
        // parse the category data here and return array
        NSDictionary *responseDict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectForKey:@"photo"];
        
        NSDictionary* descDict = [responseDict objectForKey:@"description"];
        NSString* description = [descDict objectForKey:@"_content"];
        
        NSDictionary* datesDict = [responseDict objectForKey:@"dates"];
        NSString* postedDate = [datesDict objectForKey:@"posted"];
        completionBlock(description, postedDate);
        
    } failure:^(NSData *data, NSError *error) {
        completionBlock(@"", @"");
    }];
}


//download each image and pass them back to the delegate
- (void) downloadPhotos:(NSArray*)array mode:(FetchMode)mode{
    
    
    Photo* photo = [array firstObject];
    [self fetchImageDetails:photo.photoIdentifier completion:^(NSString *description, NSString *datePosted) {
        
        photo.photoDescription = description;
        photo.datePosted = datePosted;
        
        __block UIImage* downloadedImage;
        NSString* imageURL = [NSString stringWithFormat:FLIKR_IMAGE_ENDPOINT, photo.farm, photo.server, photo.photoIdentifier, photo.secret];
        
        NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                       downloadTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                           
                                                           downloadedImage = [UIImage imageWithData:
                                                                              [NSData dataWithContentsOfURL:location]];
                                                           photo.image = downloadedImage;
                                                           [self.photoArray addObject:photo];
                                                           // calling delegate method back on main thread as it is likely the user/client will call UI code from here, it doesnt have to be mainthread necessarily. 
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               if (mode == FETCH_ONE_BY_ONE)
                                                               {
                                                                   SEL selector = NSSelectorFromString(@"singleImageReceived:error:");
                                                                   if ([self.delegate respondsToSelector:selector])
                                                                   {
                                                                       [self.delegate singleImageReceived:photo error:nil];
                                                                   }
                                                               }
                                                               else
                                                               {
                                                                   if (self.photoArray.count ==  self.resultPhotoArray.count)
                                                                   {
                                                                       SEL selector = NSSelectorFromString(@"imagesReceived:error:");
                                                                       if ([self.delegate respondsToSelector:selector])
                                                                       {
                                                                           [self.delegate imagesReceived:self.photoArray error:nil];
                                                                       }
                                                                   }
                                                               }
                                                               
                                                               if (self.photoArray.count != self.resultPhotoArray.count)
                                                               {
                                                                   NSMutableArray* newArray = [array mutableCopy];
                                                                   [newArray removeObjectAtIndex:0];
                                                                   [self downloadPhotos:[newArray copy] mode:mode];
                                                               }
                                                           });
                                                       }];
        [downloadPhotoTask resume];
    }];
}


@end
