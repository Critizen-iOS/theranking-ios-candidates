//
//  PXUser.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - = PXUser = -

@interface PXUser: NSObject

#pragma mark - Creation -

/*!
 * Create a new user object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json;


#pragma mark - Properties -

//! ID of the user.
@property (nonatomic, readonly) NSInteger userId;
//! Username.
@property (nonatomic, readonly) NSString *userName;
//! First name.
@property (nonatomic, readonly) NSString *firstName;
//! Last name.
@property (nonatomic, readonly) NSString *lastName;
//! A combination of first and last names or a username that would naturally appear on the site.
@property (nonatomic, readonly) NSString *fullName;
//! City as specified in user's profile.
@property (nonatomic, readonly) NSString *city;
//! Country as specified in user's profile.
@property (nonatomic, readonly) NSString *country;
//! Profile picture’s URL of the user.
@property (nonatomic, readonly) NSString *userPicUrl;
/*!
 * Whether the user is a premium user.<br>
 * Non-zero values identify premium users; a value of 2 identifies an Awesome user while a value of 1 identifies a Plus user.<br>
 * Other states may be added in the future, so write your parsers accordingly.
 */
@property (nonatomic, readonly) NSInteger upgradeStatus;
//! User followers count.
@property (nonatomic, readonly) NSInteger followersCount;
//! Affection value.
@property (nonatomic, readonly) NSInteger affection;

//TODO: Profile format

@end
