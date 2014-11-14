#import <Foundation/Foundation.h>

@interface TRUserData : NSObject

@property (nonatomic, strong) NSURL* avatarUrl;

+ (TRUserData*)fromDict:(id)dict;
- (NSString*)combinedName;
- (NSString*)descriptionText;

@end
