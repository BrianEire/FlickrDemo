//
//  Photos.h
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//
#import <Foundation/Foundation.h>



@interface Photos : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *total;
@property (nonatomic, assign) double pages;
@property (nonatomic, assign) double page;
@property (nonatomic, strong) NSArray *photo;
@property (nonatomic, assign) double perpage;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
