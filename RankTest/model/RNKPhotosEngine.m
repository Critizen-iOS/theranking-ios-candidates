//
//  RNKPhotosEngine.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPhotosEngine.h"
#import "RNKPhotosAPI.h"
#import "RNKDataBaseEngine.h"
#import "Photo.h"
#import "User.h"
#import "RNKConstants.h"
@import CoreData;

@interface RNKPhotosEngine ()

@property (strong, nonatomic) RNKPhotosAPI *photosAPI;

@end

@implementation RNKPhotosEngine {

}

- (instancetype) init {

    if (self = [super init]) {
        //
    }
    return self;

}

- (RNKPhotosAPI*) photosAPI {

    if (!_photosAPI) {
        _photosAPI = [[RNKPhotosAPI alloc] init];
    }

    return _photosAPI;
}

- (void) getPopularPicturesOnCompletion: (void(^)(BOOL result, NSError *error)) completionBlock {

    __weak __typeof(self)weakSelf = self;
    [self.photosAPI getPopularPicturesJSON:^(NSArray *picturesJSON, NSError *error) {

        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (picturesJSON && !error) {
            [strongSelf parseAndSavePicturesBackgroud: picturesJSON completion:^{
                completionBlock (true, nil);
            }];
        } else {
            completionBlock (false, error);
        }

    }];
}


#pragma mark - private

- (void) parseAndSavePicturesBackgroud: (NSArray*) arrayWithPictures completion:(void(^)(void))completion{

    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [[RNKDataBaseEngine sharedInstance] getManagedObjectContext];

    [temporaryContext performBlock:^{

        for (NSDictionary *dictPhoto in arrayWithPictures) {

            int counter = 1;

            // Test if already exists
            NSFetchRequest *request = [[NSFetchRequest alloc] init];

            [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext: temporaryContext]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id=%@",[dictPhoto valueForKey:@"id"]];
            [request setPredicate:predicate];
            NSArray *photoArray = [temporaryContext executeFetchRequest:request error:nil];
            if ([photoArray count]) {
                // update ranking
                Photo *photo = [photoArray firstObject];
                photo.rating = [NSNumber numberWithFloat:[[dictPhoto valueForKey:@"rating"] floatValue]];
            } else {
                // new Picture
                Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                                inManagedObjectContext:temporaryContext];


                newPhoto.id = [NSString stringWithFormat:@"%ld",(long)[[dictPhoto valueForKey:@"id"] integerValue]];
                newPhoto.camera = [[dictPhoto valueForKey:@"camera"] description];
                newPhoto.focal_length = [[dictPhoto valueForKey:@"focal_length"] description];
                newPhoto.image_url = [dictPhoto valueForKey:@"image_url"];
                newPhoto.photoDescription = [[dictPhoto valueForKey:@"description"] description];
                //newPhoto.latitude = [NSNumber numberWithDouble:[[dictPhoto valueForKey:@"latitude"] doubleValue]];
                //newPhoto.longitude = [NSNumber numberWithDouble:[[dictPhoto valueForKey:@"longitude"] doubleValue]];
                if ([[dictPhoto valueForKey:@"latitude"] respondsToSelector:@selector(doubleValue)]) {
                    newPhoto.latitude = [NSNumber numberWithDouble:[[dictPhoto valueForKey:@"latitude"] doubleValue]];
                }
                if ([[dictPhoto valueForKey:@"longitude"] respondsToSelector:@selector(doubleValue)]) {
                    newPhoto.longitude = [NSNumber numberWithDouble:[[dictPhoto valueForKey:@"longitude"] doubleValue]];
                }
                newPhoto.name = [dictPhoto valueForKey:@"name"];
                newPhoto.rating = [NSNumber numberWithFloat:[[dictPhoto valueForKey:@"rating"] floatValue]];
                newPhoto.shutter_speed = [[dictPhoto valueForKey:@"shutter_speed"] description];
                newPhoto.aperture = [[dictPhoto valueForKey:@"aperture"] description];

                //Check user
                NSString *userId = [NSString stringWithFormat:@"%ld",(long)[[[dictPhoto valueForKey:@"user"] valueForKey:@"id"] integerValue]];


                NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
                [userRequest setEntity:[NSEntityDescription entityForName: @"User"
                                                   inManagedObjectContext: temporaryContext]];
                NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"id=%@",userId];
                [userRequest setPredicate: userPredicate];
                NSArray *userArray = [temporaryContext executeFetchRequest: userRequest error:nil];
                if ([userArray count]) {
                    User *user = [userArray firstObject];
                    newPhoto.user = user;
                    //TODO: update user if something new
                } else {
                    //Create new user
                    User *newUser = [NSEntityDescription insertNewObjectForEntityForName: @"User"
                                                                  inManagedObjectContext: temporaryContext];

                    newUser.id = userId;
                    newUser.username = [[dictPhoto valueForKey:@"user"] valueForKey:@"username"];
                    newUser.userpic_url = [[dictPhoto valueForKey:@"user"] valueForKey:@"userpic_url"];
                    newUser.city = [[dictPhoto valueForKey:@"user"] valueForKey:@"city"];
                    newUser.country = [[dictPhoto valueForKey:@"user"] valueForKey:@"country"];
                    newUser.fullname = [[dictPhoto valueForKey:@"user"] valueForKey:@"fullname"];

                    newPhoto.user = newUser;
                }
                
            }

            if(counter % 5 == 0){
                // Save the context.
                NSError *error = nil;
                DLog(@"Saving to PSC, %u", counter);
                if (![temporaryContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    ELog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            counter++;
        }

        // Save the context.
        NSError *error = nil;
        DLog(@"Saving to PSC");
        if (![temporaryContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            ELog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        // save parent to disk asynchronously
        [[[RNKDataBaseEngine sharedInstance] getManagedObjectContext] performBlock:^{
            NSError *error;
            if (![[[RNKDataBaseEngine sharedInstance] getManagedObjectContext] save:&error])
            {
                ELog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }];
    }];


}



@end






