//
//  RNKPhotosAPI.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

@import Foundation;

/**
 *  Object in manage of all API calls for Pictures
 */

@interface RNKPhotosAPI : NSObject

/**
 *  Returns JSON array with popular pictures
 */

- (void) getPopularPicturesJSON: (void(^)(NSArray *picturesJSON, NSError *error)) completionBlock;


@end
