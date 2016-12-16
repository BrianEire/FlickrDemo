//
//  FlickrData.m
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "FlickrData.h"
#import "Photos.h"


NSString *const kFlickrDataStat = @"stat";
NSString *const kFlickrDataPhotos = @"photos";


@interface FlickrData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FlickrData

@synthesize stat = _stat;
@synthesize photos = _photos;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.stat = [self objectOrNilForKey:kFlickrDataStat fromDictionary:dict];
        self.photos = [Photos modelObjectWithDictionary:[dict objectForKey:kFlickrDataPhotos]];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stat forKey:kFlickrDataStat];
    [mutableDict setValue:[self.photos dictionaryRepresentation] forKey:kFlickrDataPhotos];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.stat = [aDecoder decodeObjectForKey:kFlickrDataStat];
    self.photos = [aDecoder decodeObjectForKey:kFlickrDataPhotos];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_stat forKey:kFlickrDataStat];
    [aCoder encodeObject:_photos forKey:kFlickrDataPhotos];
}

- (id)copyWithZone:(NSZone *)zone
{
    FlickrData *copy = [[FlickrData alloc] init];
    
    if (copy) {
        
        copy.stat = [self.stat copyWithZone:zone];
        copy.photos = [self.photos copyWithZone:zone];
    }
    
    return copy;
}


@end
