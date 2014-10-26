//
//  FHDDataWebService.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represents the API for web services
@interface FHDWebService : NSObject <NSURLSessionDataDelegate>

/**
 * Gets the popular items for the given page from web services
 * @param page number page to get popular items
 * @param completion block to execute when web service response is ready; uses an array of JSON popular items
 */
- (void)getPopularRequestFromPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion;

@end
