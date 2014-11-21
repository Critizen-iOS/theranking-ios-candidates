//
//  CZUser.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZUser.h"
#import "CZPhoto.h"
#import "NSObject+Null.h"

@implementation CZUser

@dynamic avatarURL;
@dynamic name;
@dynamic photos;

+ (CZUser *) createUserWithJSONData:(NSDictionary *) jsonData context:(NSManagedObjectContext *) context{
    
    CZUser* user = [NSEntityDescription insertNewObjectForEntityForName:@"CZUser"
                                                 inManagedObjectContext:context];
    
    //
    // Username
    //
    if ([[jsonData objectForKey:@"username"] isNotNull]) {
        [user setName:[jsonData objectForKey:@"username"]];
    }
    
    //
    // Avatar URL
    //
    if ([[jsonData objectForKey:@"userpic_url"] isNotNull]) {
        [user setAvatarURL:[jsonData objectForKey:@"userpic_url"]];
    }
    
    return user;
}

@end
