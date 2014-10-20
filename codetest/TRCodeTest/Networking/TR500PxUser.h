//
//  TR500PxUser.h
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TR500PxUser : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSURL *userPicture;

- (instancetype)initWithUser:(NSDictionary *)user;

/*
 user: {
 id: 294042,
 username: "GeorgePapapostolou",
 firstname: "George",
 lastname: "Papapostolou",
 city: "kos island",
 country: "greece",
 usertype: 0,
 fullname: "George Papapostolou",
 userpic_url: "https://gp1.wac.edgecastcdn.net/806614/avatars/avatars.500px.net/294042/61c2af129bd06ade5f2cfd3f5609f3cb648f7858/1.jpg?2",
 userpic_https_url: "https://gp1.wac.edgecastcdn.net/806614/avatars/avatars.500px.net/294042/61c2af129bd06ade5f2cfd3f5609f3cb648f7858/1.jpg?2",
 upgrade_status: 2,
 affection: 177986
 }
 */
@end
