#import <Foundation/Foundation.h>

@interface TRUserData : NSObject

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* fullName;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSURL* avatarUrl;

+ (TRUserData*)fromDict:(id)dict;

@end
