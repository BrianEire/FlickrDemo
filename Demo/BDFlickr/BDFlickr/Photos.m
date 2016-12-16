//
//  Photos.m
//  BDFlickr
//
//  Created by BD on 15/12/2016.
//  Copyright © 2016 BD. All rights reserved.
//

#import "Photos.h"
#import "Photo.h"


NSString *const kPhotosTotal = @"total";
NSString *const kPhotosPages = @"pages";
NSString *const kPhotosPage = @"page";
NSString *const kPhotosPhoto = @"photo";
NSString *const kPhotosPerpage = @"perpage";


@interface Photos ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Photos

@synthesize total = _total;
@synthesize pages = _pages;
@synthesize page = _page;
@synthesize photo = _photo;
@synthesize perpage = _perpage;


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
        self.total = [self objectOrNilForKey:kPhotosTotal fromDictionary:dict];
        self.pages = [[self objectOrNilForKey:kPhotosPages fromDictionary:dict] doubleValue];
        self.page = [[self objectOrNilForKey:kPhotosPage fromDictionary:dict] doubleValue];
        NSObject *receivedPhoto = [dict objectForKey:kPhotosPhoto];
        NSMutableArray *parsedPhoto = [NSMutableArray array];
        if ([receivedPhoto isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedPhoto) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedPhoto addObject:[Photo modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedPhoto isKindOfClass:[NSDictionary class]]) {
            [parsedPhoto addObject:[Photo modelObjectWithDictionary:(NSDictionary *)receivedPhoto]];
        }
        
        self.photo = [NSArray arrayWithArray:parsedPhoto];
        self.perpage = [[self objectOrNilForKey:kPhotosPerpage fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.total forKey:kPhotosTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pages] forKey:kPhotosPages];
    [mutableDict setValue:[NSNumber numberWithDouble:self.page] forKey:kPhotosPage];
    NSMutableArray *tempArrayForPhoto = [NSMutableArray array];
    for (NSObject *subArrayObject in self.photo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPhoto addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPhoto addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPhoto] forKey:kPhotosPhoto];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perpage] forKey:kPhotosPerpage];
    
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
    
    self.total = [aDecoder decodeObjectForKey:kPhotosTotal];
    self.pages = [aDecoder decodeDoubleForKey:kPhotosPages];
    self.page = [aDecoder decodeDoubleForKey:kPhotosPage];
    self.photo = [aDecoder decodeObjectForKey:kPhotosPhoto];
    self.perpage = [aDecoder decodeDoubleForKey:kPhotosPerpage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_total forKey:kPhotosTotal];
    [aCoder encodeDouble:_pages forKey:kPhotosPages];
    [aCoder encodeDouble:_page forKey:kPhotosPage];
    [aCoder encodeObject:_photo forKey:kPhotosPhoto];
    [aCoder encodeDouble:_perpage forKey:kPhotosPerpage];
}

- (id)copyWithZone:(NSZone *)zone
{
    Photos *copy = [[Photos alloc] init];
    
    if (copy) {
        
        copy.total = [self.total copyWithZone:zone];
        copy.pages = self.pages;
        copy.page = self.page;
        copy.photo = [self.photo copyWithZone:zone];
        copy.perpage = self.perpage;
    }
    
    return copy;
}


@end
