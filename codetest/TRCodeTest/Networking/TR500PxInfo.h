//
//  TR500PxInfo.h
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TR500PxFeature) {
    POPULAR,                // Return photos in Popular. Default sort: rating.
    HIGHEST_RATED,          // Return photos that have been in Popular. Default sort: highest_rating.
    UPCOMING,               // Return photos in Upcoming. Default sort: time when Upcoming was reached.
    EDITORS,                // Return photos in Editors' Choice. Default sort: time when selected by an editor.
    FRESH_TODAY,            // Return photos in Fresh Today. Default sort: time when reached fresh.
    FRESH_YESTERDAY,        // Return photos in Fresh Yesterday. Default sort: same as 'fresh_today'.
    FRESH_WEEK              // Return photos in Fresh This Week. Default sort: same as 'fresh_today'.
};

typedef NS_ENUM(NSInteger, TR500PxSort) {
    CREATED_AT,            // Sort by time of upload
    RATING,                // Sort by rating
    HIGHEST_RATING,        // Sort by the highest rating the photo reached
    TIMES_VIEWED,          // Sort by view count
    VOTES_COUNT,           // Sort by votes count
    FAVORITES_COUNT,       // Sort by favorites count
    COMMENT_COUNT,         // Sort by comments count
    TAKEN_AT               // Sort by the original date of the image extracted from metadata (might not be available for all images)
};

@interface TR500PxInfo : NSObject

@property (nonatomic, readonly) NSNumber *page;
@property (nonatomic, readonly) NSNumber *photosPerPage;

@property (assign, readonly) TR500PxFeature feature;
@property (assign, readonly) TR500PxSort sort;

@property (copy, nonatomic) NSString *params;

/**
 *  Init TR500PxInfo
 *
 *  @param feature       Photo stream to be retrieved. Default fresh_today.
 *  @param sort          Sort photos in the specified order.
 *  @param page          Return a specific page in the photo stream. Page numbering is 1-based.
 *  @param photosPerPage The number of results to return. Can not be over 100, default 20.
 *
 *  @return TR500PxInfo object
 */
- (instancetype)initWithFeature:(TR500PxFeature)feature sort:(TR500PxSort)sort page:(NSNumber *)page photosPerPage:(NSNumber *)photosPerPage;

/**
 *  Init TR500PxInfo
 *
 *  @param feature       Photo stream to be retrieved. Default fresh_today.
 *  @param sort          Sort photos in the specified order.
 *  @param page          Return a specific page in the photo stream. Page numbering is 1-based.
 *
 *  @return TR500PxInfo object
 */
- (instancetype)initWithFeature:(TR500PxFeature)feature sort:(TR500PxSort)sort page:(NSNumber *)page;

/**
 *  Init TR500PxInfo
 *
 *  @param feature       Photo stream to be retrieved. Default fresh_today.
 *  @param sort          Sort photos in the specified order.
 *
 *  @return TR500PxInfo object
 */
- (instancetype)initWithFeature:(TR500PxFeature)feature sort:(TR500PxSort)sort;

@end
