//
//  APIEngine.h
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModels.h"

// 2 modes of recieving the images back from the API
typedef enum
{
    FETCH_ONE_BY_ONE,
    FETCH_ALL_AT_ONCE,
} FetchMode;


@protocol APIEngineDelegate <NSObject>
@optional
- (void) imagesReceived:(NSArray*)photos error:(NSError*)error;
- (void) singleImageReceived:(Photo*)photo error:(NSError*)error;
@end

@interface APIEngine : NSObject

+ (id)sharedManager;

// delegate
@property (nonatomic, weak) id<APIEngineDelegate> delegate;

#pragma mark - Interface to set API key
- (void)setAPIKey:(NSString*)APIKey;

#pragma mark - Interface for fetching images API
- (void) fetchRecentImageswithMode:(FetchMode)mode perPage:(NSString*)perPage pageNo:(NSString*)pageNo;

@end
