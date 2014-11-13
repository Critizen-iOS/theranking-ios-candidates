#import "TRUserData.h"

#import "ELHASO.h"


@interface TRUserData ()

@end


@implementation TRUserData

#pragma mark -
#pragma mark Life

/** Transforms a dictionary into an TRUserData object.
 *
 * Returns nil if something went wrong.
 */
+ (TRUserData*)fromDict:(id)dict
{
    NSDictionary* jsonDict = CAST(dict, NSDictionary);
    if (!jsonDict) {
        DLOG(@"Didn't get a valid dict!");
        return nil;
    }

    return [[TRUserData alloc] initWithDict:jsonDict];
}

/** Constructs a user data object from a dictionary.
 *
 * Will return a nil object if something went wrong during parsing.
 */
- (id)initWithDict:(NSDictionary*)dict
{
    LASSERT([dict isKindOfClass:[NSDictionary class]], @"Bad type");
    if (!(self = [super init]))
        return nil;

    self.userName = CAST(dict[@"username"], NSString);
    self.fullName = CAST(dict[@"fullname"], NSString);
    self.city = CAST(dict[@"city"], NSString);
    self.country = CAST(dict[@"country"], NSString);
    self.avatarUrl = [NSURL URLWithString:CAST(dict[@"userpic_url"], NSString)];

    if (![self isValid])
        return nil;

    return self;
}

#pragma mark -
#pragma mark Methods

/** Returns YES if the object has all the necessary fields.
 *
 * We really care about are the avatar URL, the name and the
 * full name. The rest is optional.
 */
- (BOOL)isValid
{
    if (self.userName.length < 1) return NO;
    if (self.fullName.length < 1) return NO;
    if (!self.avatarUrl) return NO;

    return YES;
}

/// Debug helper to see if we are parsing interesting data.
- (NSString*)description
{
    return [NSString stringWithFormat:@"TRUserData{userName:%@, fullName:%@, "
        @"avatar:%@}",
        _userName, _fullName, _avatarUrl];
}

@end
