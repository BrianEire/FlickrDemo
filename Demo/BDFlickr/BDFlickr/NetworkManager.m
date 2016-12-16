//
//  NetworkManager.m
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

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
        self.session = [NSURLSession sharedSession];
    }
    return self;
}


- (void) submitGETrequest:(NSString*)url params:(NSString*)params customHeaders:(NSDictionary *)headers success:(APISuccess)success failure:(APIFailure)failure{
    
    if (params!= nil)
    {
        url = [NSString stringWithFormat:@"%@?%@", url, params];
    }
    
    NSURL *URL = [[NSURL alloc]initWithString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL];
    
    if (headers != nil)
    {
        for (id key in headers) {
            NSString *value = [headers objectForKey:key];
            [request addValue:value forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *  error) {
        
        if (error)
        {
            if (failure!= nil)
            {
                failure(data, error);
            }
            
        }
        else{
            if (success !=nil)
            {
                success(data);
            }
        }
        
    }];
    
    [task resume];
}

@end
