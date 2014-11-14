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

+ (TRPhotoData*)fromDict:(id)dict;
- (NSString*)ratingText;
- (NSString*)locationText;
- (NSString*)cameraText;

@end
