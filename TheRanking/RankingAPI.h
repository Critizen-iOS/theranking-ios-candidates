//
//  RankingAPI.h
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 26/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Picture.h"

typedef enum {
    RankingAPIErrorCodeUnknown,
    RankingAPIErrorCodeNotFound,
    RankingAPIErrorCodeBadResponse,
    RankingAPIErrorCodeCouldntContactServer,
} RankingAPIErrorCode;

@interface RankingAPI : NSObject

+ (instancetype) sharedInstance;

- (void) refreshPopularImagesOnError:(void(^)(RankingAPIErrorCode errorCode, NSError *error))errorBlock;

- (void) importDictArray:(NSArray *)dictArray usingConversionBlock:(void(^)(Picture *picture, NSDictionary *pictureDict))conversionBlock;

- (NSFetchedResultsController *) popularPictureFetchedResultsController;

- (void) saveCachedData;

/****
 * Implement the following methods in a subclass to configure data source
 ****/

// URL to fetch data from
- (NSURL *) popularPicturesURL;
// Called in a background thread to process the response
- (void) processPopularPicturesResponse: (NSData *)response onError:(void(^)(RankingAPIErrorCode errorCode, NSError *error))errorBlock;

@end
