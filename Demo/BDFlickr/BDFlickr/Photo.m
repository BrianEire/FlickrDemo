//
//  Photo.m
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "Photo.h"


NSString *const kPhotoSecret = @"secret";
NSString *const kPhotoOwner = @"owner";
NSString *const kPhotoFarm = @"farm";
NSString *const kPhotoId = @"id";
NSString *const kPhotoServer = @"server";
NSString *const kPhotoTitle = @"title";
NSString *const kPhotoIsfriend = @"isfriend";
NSString *const kPhotoIsfamily = @"isfamily";
NSString *const kPhotoIspublic = @"ispublic";


@interface Photo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Photo

@synthesize secret = _secret;
@synthesize owner = _owner;
@synthesize farm = _farm;
@synthesize photoIdentifier = _photoIdentifier;
@synthesize server = _server;
@synthesize title = _title;
@synthesize isfriend = _isfriend;
@synthesize isfamily = _isfamily;
@synthesize ispublic = _ispublic;


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
        self.secret = [self objectOrNilForKey:kPhotoSecret fromDictionary:dict];
        self.owner = [self objectOrNilForKey:kPhotoOwner fromDictionary:dict];
        self.farm = [[self objectOrNilForKey:kPhotoFarm fromDictionary:dict] doubleValue];
        self.photoIdentifier = [self objectOrNilForKey:kPhotoId fromDictionary:dict];
        self.server = [self objectOrNilForKey:kPhotoServer fromDictionary:dict];
        self.title = [self objectOrNilForKey:kPhotoTitle fromDictionary:dict];
        self.isfriend = [[self objectOrNilForKey:kPhotoIsfriend fromDictionary:dict] doubleValue];
        self.isfamily = [[self objectOrNilForKey:kPhotoIsfamily fromDictionary:dict] doubleValue];
        self.ispublic = [[self objectOrNilForKey:kPhotoIspublic fromDictionary:dict] doubleValue];
        
    }
    
    return self;
}


- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.secret forKey:kPhotoSecret];
    [mutableDict setValue:self.owner forKey:kPhotoOwner];
    [mutableDict setValue:[NSNumber numberWithDouble:self.farm] forKey:kPhotoFarm];
    [mutableDict setValue:self.photoIdentifier forKey:kPhotoId];
    [mutableDict setValue:self.server forKey:kPhotoServer];
    [mutableDict setValue:self.title forKey:kPhotoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isfriend] forKey:kPhotoIsfriend];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isfamily] forKey:kPhotoIsfamily];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ispublic] forKey:kPhotoIspublic];
    
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
    
    self.secret = [aDecoder decodeObjectForKey:kPhotoSecret];
    self.owner = [aDecoder decodeObjectForKey:kPhotoOwner];
    self.farm = [aDecoder decodeDoubleForKey:kPhotoFarm];
    self.photoIdentifier = [aDecoder decodeObjectForKey:kPhotoId];
    self.server = [aDecoder decodeObjectForKey:kPhotoServer];
    self.title = [aDecoder decodeObjectForKey:kPhotoTitle];
    self.isfriend = [aDecoder decodeDoubleForKey:kPhotoIsfriend];
    self.isfamily = [aDecoder decodeDoubleForKey:kPhotoIsfamily];
    self.ispublic = [aDecoder decodeDoubleForKey:kPhotoIspublic];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_secret forKey:kPhotoSecret];
    [aCoder encodeObject:_owner forKey:kPhotoOwner];
    [aCoder encodeDouble:_farm forKey:kPhotoFarm];
    [aCoder encodeObject:_photoIdentifier forKey:kPhotoId];
    [aCoder encodeObject:_server forKey:kPhotoServer];
    [aCoder encodeObject:_title forKey:kPhotoTitle];
    [aCoder encodeDouble:_isfriend forKey:kPhotoIsfriend];
    [aCoder encodeDouble:_isfamily forKey:kPhotoIsfamily];
    [aCoder encodeDouble:_ispublic forKey:kPhotoIspublic];
}


- (id)copyWithZone:(NSZone *)zone
{
    Photo *copy = [[Photo alloc] init];
    
    if (copy) {
        
        copy.secret = [self.secret copyWithZone:zone];
        copy.owner = [self.owner copyWithZone:zone];
        copy.farm = self.farm;
        copy.photoIdentifier = [self.photoIdentifier copyWithZone:zone];
        copy.server = [self.server copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.isfriend = self.isfriend;
        copy.isfamily = self.isfamily;
        copy.ispublic = self.ispublic;
    }
    
    return copy;
}


@end
