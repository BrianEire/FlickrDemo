//
//  Photo.h
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Photo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, assign) double farm;
@property (nonatomic, strong) NSString *photoIdentifier;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double isfriend;
@property (nonatomic, assign) double isfamily;
@property (nonatomic, assign) double ispublic;
@property UIImage* image;
@property NSString* datePosted;
@property NSString* photoDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
