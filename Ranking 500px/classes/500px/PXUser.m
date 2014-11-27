//
//  PXUser.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "PXUser.h"

#import "NSDictionary+Data.h"

#pragma mark - = PXUser = -

@implementation PXUser

#pragma mark - Creation -

/*
 * Create a new photo object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json
{
    if( (self = [super init]) ) {
        _userId = [json integerForKey:@"id"];

        _userName = [json valueForKey:@"username"];
        _firstName = [json valueForKey:@"firstname"];
        _lastName = [json valueForKey:@"lastname"];
        _fullName = [json valueForKey:@"fullname"];

        _city = [json valueForKey:@"city"];
        _country = [json valueForKey:@"country"];

        _userPicUrl = [json valueForKey:@"userpic_url"];
    }

    return self;
}

@end
