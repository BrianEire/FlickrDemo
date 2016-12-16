//
//  NetworkManager.h
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APISuccess)(NSData *data);
typedef void (^APIFailure)(NSData *data, NSError *error);

@interface NetworkManager : NSObject

+ (id)sharedManager;

- (void) submitGETrequest:(NSString*)url params:(NSString*)params customHeaders:(NSDictionary *)headers success:(APISuccess)success failure:(APIFailure)failure;

@property NSURLSession *session;

@end
