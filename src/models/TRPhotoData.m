#import "TRPhotoData.h"

#import "ELHASO.h"
#import "TRUserData.h"


@interface TRPhotoData ()

@property (nonatomic, assign) double rating;

@end


@implementation TRPhotoData

#pragma mark -
#pragma mark Life

/** Transforms a dictionary into an TRPhotoData object.
 *
 * Returns nil if something went wrong.
 */
+ (TRPhotoData*)fromDict:(id)dict
{
    NSDictionary* jsonDict = CAST(dict, NSDictionary);
    if (!jsonDict) {
        DLOG(@"Didn't get a valid dict!");
        return nil;
    }

    return [[TRPhotoData alloc] initWithDict:jsonDict];
}

/** Constructs a photo data object from a dictionary.
 *
 * Will return a nil object if something went wrong during parsing.
 */
- (id)initWithDict:(NSDictionary*)dict
{
    LASSERT([dict isKindOfClass:[NSDictionary class]], @"Bad type");
    if (!(self = [super init]))
        return nil;

    NSNumber *number = CAST(dict[@"rating"], NSNumber);
    self.rating = [number doubleValue];

    self.photoName = CAST(dict[@"name"], NSString);
    self.photoDesc = CAST(dict[@"description"], NSString);
    self.imageUrl = [NSURL URLWithString:CAST(dict[@"image_url"], NSString)];
    self.user = [TRUserData fromDict:dict[@"user"]];

    NSNumber* latitude = CAST(dict[@"latitude"], NSNumber);
    NSNumber* longitude = CAST(dict[@"latitude"], NSNumber);
    if (latitude && longitude) {
        self.location = [[CLLocation alloc]
            initWithLatitude:[latitude doubleValue]
            longitude:[longitude doubleValue]];
    }

    self.cameraModel = CAST(dict[@"camera"], NSString);
    self.cameraLens = CAST(dict[@"lens"], NSString);
    self.photoAperture = CAST(dict[@"aperture"], NSString);
    self.focalLength = CAST(dict[@"focal_length"], NSString);
    self.iso = CAST(dict[@"iso"], NSString);
    self.shutterSpeed = CAST(dict[@"shutter_speed"], NSString);

    if (![self isValid])
        return nil;

    return self;
}

#pragma mark -
#pragma mark Methods

/** Returns YES if the object has all the necessary fields.
 *
 * At best the only values we really care about are the URL, the name and the
 * user information since these are the juicy bits that we need to show in the
 * detail view of a picture. Empty photo names are OK, I guess.
 */
- (BOOL)isValid
{
    if (!self.photoName) return NO;
    if (!self.imageUrl) return NO;
    if (!self.user) return NO;

    return YES;
}

/// Debug helper to see if we are parsing interesting data.
- (NSString*)description
{
    return [NSString stringWithFormat:@"TRPhotoData{name:%@, desc:%@, "
        @"url:%@, user:%@}",
        _photoName, _photoDesc, _imageUrl, _user];
}

/// Returns a formatted string with the rating of the photo.
- (NSString*)ratingText
{
    return [NSString stringWithFormat:@"%0.1f", self.rating];
}

@end
