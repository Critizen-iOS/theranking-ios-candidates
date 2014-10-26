//
//  FHDModel.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDItem.h"

@implementation FHDItem

+ (instancetype)itemWithJSON:(NSDictionary *)json
{
    FHDItem *item = [[self alloc] init];

    item.identifier = [json objectForKey:@"id"];
    item.name = ([json objectForKey:@"name"] == [NSNull null]) ? nil : [json objectForKey:@"name"];
    item.desc = ([json objectForKey:@"description"] == [NSNull null]) ? nil : [json objectForKey:@"description"];
    item.imageUrl = ([json objectForKey:@"imageUrl"] == [NSNull null]) ? nil : [json objectForKey:@"image_url"];
    item.rating = ([json objectForKey:@"rating"] == [NSNull null]) ? nil : [json objectForKey:@"rating"];
    item.camera = ([json objectForKey:@"camera"] == [NSNull null]) ? nil : [json objectForKey:@"camera"];
    item.latitude = ([json objectForKey:@"latitude"] == [NSNull null]) ? nil : [json objectForKey:@"latitude"];
    item.longitude = ([json objectForKey:@"longitude"] == [NSNull null]) ? nil : [json objectForKey:@"longitude"];
    
    NSDictionary *user = [json objectForKey:@"user"];
    item.userName = ([user objectForKey:@"username"] == [NSNull null]) ? nil : [user objectForKey:@"username"];
    item.userAvatarUrl = ([user objectForKey:@"userpic_url"] == [NSNull null]) ? nil : [user objectForKey:@"userpic_url"];
    
    return item;
}

@end
