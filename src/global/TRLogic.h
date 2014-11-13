#import <Foundation/Foundation.h>

/// Domain for logic errors.
#define kErrorLogic @"kErrorLogic"

/// Logic callbacks pass nil on success or the NSError on failure.
typedef void(^logicCallback)(NSError* error);


@interface TRLogic : NSObject

+ (void)fetchPhotosWithCallback:(logicCallback)callback;
+ (NSArray*)getPhotos;

@end
