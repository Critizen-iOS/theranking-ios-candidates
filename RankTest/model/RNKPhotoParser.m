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

        NSString *auxField;

        auxField = [pictureJSON valueForKey:@"camera"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.camera = auxField;

        auxField = [pictureJSON valueForKey:@"focal_length"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.focal_length = auxField;

        auxField = [pictureJSON valueForKey:@"image_url"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.image_url = auxField;

        auxField = [pictureJSON valueForKey:@"description"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.photoDescription = auxField;

        if ([[pictureJSON valueForKey:@"latitude"] respondsToSelector:@selector(doubleValue)]) {
            newPhoto.latitude = [NSNumber numberWithDouble:[[pictureJSON valueForKey:@"latitude"] doubleValue]];
        }
        if ([[pictureJSON valueForKey:@"longitude"] respondsToSelector:@selector(doubleValue)]) {
            newPhoto.longitude = [NSNumber numberWithDouble:[[pictureJSON valueForKey:@"longitude"] doubleValue]];
        }

        auxField = [pictureJSON valueForKey:@"name"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.name = auxField;

        newPhoto.rating = [NSNumber numberWithFloat:[[pictureJSON valueForKey:@"rating"] floatValue]];

        auxField = [pictureJSON valueForKey:@"shutter_speed"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.shutter_speed = auxField;

        auxField = [pictureJSON valueForKey:@"aperture"];
        if ( (NSNull*)auxField == [NSNull null]) {
            auxField = nil;
        }
        newPhoto.aperture = auxField;


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

            auxField = [[pictureJSON valueForKey:@"user"] valueForKey:@"username"];
            if ( (NSNull*)auxField == [NSNull null]) {
                auxField = nil;
            }
            newUser.username = auxField;

            auxField = [[pictureJSON valueForKey:@"user"] valueForKey:@"userpic_url"];
            if ( (NSNull*)auxField == [NSNull null]) {
                auxField = nil;
            }
            newUser.userpic_url = auxField;

            auxField = [[pictureJSON valueForKey:@"user"] valueForKey:@"city"];
            if ( (NSNull*)auxField == [NSNull null]) {
                auxField = nil;
            }
            newUser.city = auxField;

            auxField = [[pictureJSON valueForKey:@"user"] valueForKey:@"country"];
            if ( (NSNull*)auxField == [NSNull null]) {
                auxField = nil;
            }
            newUser.country = auxField;

            auxField = [[pictureJSON valueForKey:@"user"] valueForKey:@"fullname"];
            if ( (NSNull*)auxField == [NSNull null]) {
                auxField = nil;
            }
            newUser.fullname = auxField;

            newPhoto.user = newUser;
        }
    }
}

@end
