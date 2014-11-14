#import "TRUserData.h"

#import "ELHASO.h"


@interface TRUserData ()

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* fullName;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;

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

/** Returns the combined full name and nick.
 *
 * If any of the values doesn't exist, the empty string is returned.
 */
- (NSString*)combinedName
{
    if (self.userName.length && self.fullName.length) {
        return [NSString stringWithFormat:@"%@ (%@)",
            self.fullName, self.userName];
    } else if (self.userName.length) {
        return self.userName;
    } else if (self.fullName.length) {
        return self.fullName;
    } else {
        return @"";
    }
}

/** Returns a description of the user's location.
 *
 * This returns at least an empty string.
 */
- (NSString*)descriptionText
{
    if (self.country.length && self.city.length) {
        return [NSString stringWithFormat:@"%@ (%@)",
            self.city, self.country];
    } else if (self.country.length) {
        return self.country;
    } else if (self.city.length) {
        return self.city;
    } else {
        return @"";
    }
}

@end
