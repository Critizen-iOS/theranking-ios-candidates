//
//  RNKPhotosEngine.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPhotosEngine.h"
#import "RNKPhotosAPI.h"

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

- (void) parseAndSavePicturesBackgroud: (NSArray*) arrayWithFeeds completion:(void(^)(void))completion{


}



@end






