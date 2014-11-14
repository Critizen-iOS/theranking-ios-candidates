#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class TRUserData;

@interface TRPhotoData : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString* photoName;
@property (nonatomic, strong) NSString* photoDesc;
@property (nonatomic, strong) NSURL* imageUrl;
@property (nonatomic, strong) TRUserData* user;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) NSString* cameraModel;
@property (nonatomic, strong) NSString* cameraLens;
@property (nonatomic, strong) NSString* photoAperture;
@property (nonatomic, strong) NSString* focalLength;
@property (nonatomic, strong) NSString* iso;
@property (nonatomic, strong) NSString* shutterSpeed;

+ (TRPhotoData*)fromDict:(id)dict;
- (NSString*)ratingText;

@end
