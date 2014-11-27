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
#import "RNKPhotoParser.h"
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
    DLog();
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
    DLog();

    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = [[RNKDataBaseEngine sharedInstance] getManagedObjectContext];

    [temporaryContext performBlock:^{

        RNKPhotoParser *photoParser = [[RNKPhotoParser alloc] init];

        for (NSDictionary *dictPhoto in arrayWithPictures) {

            int counter = 1;

            [photoParser addOrModifyPictureWithJSON: dictPhoto inContext: temporaryContext];

            if(counter % 10 == 0){
                // Save the context.
                [[RNKDataBaseEngine sharedInstance] saveContext: temporaryContext];            }

            counter++;
        }

        // Save temp context.
        [[RNKDataBaseEngine sharedInstance] saveContext: temporaryContext];

        // save parent context to disk asynchronously
        [[[RNKDataBaseEngine sharedInstance] getManagedObjectContext] performBlock:^{

            [[RNKDataBaseEngine sharedInstance] saveContext: [[RNKDataBaseEngine sharedInstance] getManagedObjectContext]];

        }];

    }];

}


@end






