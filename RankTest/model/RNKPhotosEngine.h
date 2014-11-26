//
//  RNKPhotosEngine.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNKPhotosEngine : NSObject

/**
 *  Updates the DB with the lastets popular pictures
    @param competion block with result and error
 */
- (void) getPopularPicturesOnCompletion: (void(^)(BOOL result, NSError *error)) completionBlock;

@end
