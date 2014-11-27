//
//  RNKPhotoParser.m
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPhotoParser.h"
#import "Photo.h"
#import "User.h"

@implementation RNKPhotoParser

- (void) addOrModifyPictureWithJSON: (NSDictionary*) pictureJSON inContext: (NSManagedObjectContext*) context {

    // Test if already exists
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext: context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@",[pictureJSON valueForKey:@"id"]];
    [request setPredicate:predicate];
    NSArray *photoArray = [context executeFetchRequest:request error:nil];

    if ([photoArray count]) {
        // update ranking
        Photo *photo = [photoArray firstObject];
        photo.rating = [NSNumber numberWithFloat:[[pictureJSON valueForKey:@"rating"] floatValue]];
    } else {
        // new Picture
        Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                        inManagedObjectContext:context];


        newPhoto.id = [NSString stringWithFormat:@"%ld",(long)[[pictureJSON valueForKey:@"id"] integerValue]];
        newPhoto.camera = [[pictureJSON valueForKey:@"camera"] description];
        newPhoto.focal_length = [[pictureJSON valueForKey:@"focal_length"] description];
        newPhoto.image_url = [pictureJSON valueForKey:@"image_url"];
        newPhoto.photoDescription = [[pictureJSON valueForKey:@"description"] description];
        //newPhoto.latitude = [NSNumber numberWithDouble:[[pictureJSON valueForKey:@"latitude"] doubleValue]];
        //newPhoto.longitude = [NSNumber numberWithDouble:[[pictureJSON valueForKey:@"longitude"] doubleValue]];
        if ([[pictureJSON valueForKey:@"latitude"] respondsToSelector:@selector(doubleValue)]) {
            newPhoto.latitude = [NSNumber numberWithDouble:[[pictureJSON valueForKey:@"latitude"] doubleValue]];
        }
        if ([[pictureJSON valueForKey:@"longitude"] respondsToSelector:@selector(doubleValue)]) {
            newPhoto.longitude = [NSNumber numberWithDouble:[[pictureJSON valueForKey:@"longitude"] doubleValue]];
        }
        newPhoto.name = [pictureJSON valueForKey:@"name"];
        newPhoto.rating = [NSNumber numberWithFloat:[[pictureJSON valueForKey:@"rating"] floatValue]];
        newPhoto.shutter_speed = [[pictureJSON valueForKey:@"shutter_speed"] description];
        newPhoto.aperture = [[pictureJSON valueForKey:@"aperture"] description];

        //Check user
        NSString *userId = [NSString stringWithFormat:@"%ld",(long)[[[pictureJSON valueForKey:@"user"] valueForKey:@"id"] integerValue]];


        NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
        [userRequest setEntity:[NSEntityDescription entityForName: @"User"
                                           inManagedObjectContext: context]];
        NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"id=%@",userId];
        [userRequest setPredicate: userPredicate];
        NSArray *userArray = [context executeFetchRequest: userRequest error:nil];
        if ([userArray count]) {
            User *user = [userArray firstObject];
            newPhoto.user = user;
            //TODO: update user if something new
        } else {
            //Create new user
            User *newUser = [NSEntityDescription insertNewObjectForEntityForName: @"User"
                                                          inManagedObjectContext: context];

            newUser.id = userId;
            newUser.username = [[pictureJSON valueForKey:@"user"] valueForKey:@"username"];
            newUser.userpic_url = [[pictureJSON valueForKey:@"user"] valueForKey:@"userpic_url"];
            newUser.city = [[pictureJSON valueForKey:@"user"] valueForKey:@"city"];
            newUser.country = [[pictureJSON valueForKey:@"user"] valueForKey:@"country"];
            newUser.fullname = [[pictureJSON valueForKey:@"user"] valueForKey:@"fullname"];

            newPhoto.user = newUser;
        }
    }
}

@end
