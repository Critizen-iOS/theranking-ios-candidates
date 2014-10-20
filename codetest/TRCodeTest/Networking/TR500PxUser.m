//
//  TR500PxUser.m
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TR500PxUser.h"

@implementation TR500PxUser

static NSString * RESPONSE_USERNAME = @"username";
static NSString * RESPONSE_USER_PICTURE = @"userpic_url";

- (instancetype)initWithUser:(NSDictionary *)user {
    if (self = [super init]) {
        _name = user[RESPONSE_USERNAME];
        _userPicture = [NSURL URLWithString:user[RESPONSE_USER_PICTURE]];
    }
    return self;
}

@end
