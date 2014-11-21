//
//  CZ500Request.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultResultsPerPage 20

typedef void (^CZ500RequestCompletionBlock)(NSDictionary *results, NSError *error);

typedef NS_ENUM(NSInteger, CZ500RequestStatus) {
    CZ500RequestStatusNotStarted = 0,
    CZ500RequestStatusStarted,
    CZ500RequestStatusCompleted,
    CZ500RequestStatusFailed,
    CZ500RequestStatusCancelled
};

typedef NS_ENUM(NSInteger, CZ500PhotoFeature) {
    CZ500PhotoFeaturePopular = 0,
    CZ500PhotoFeatureUpcoming,
    CZ500PhotoFeatureEditors,
    CZ500PhotoFeatureFreshToday,
    CZ500PhotoFeatureFreshYesterday,
    CZ500PhotoFeatureFreshWeek,
};

typedef NS_OPTIONS(NSUInteger, CZ500PhotoModelSize) {
    CZ500PhotoModelSizeExtraSmallThumbnail = (1 << 0),
    CZ500PhotoModelSizeSmallThumbnail = (1 << 1),
    CZ500PhotoModelSizeThumbnail = (1 << 2),
    CZ500PhotoModelSizeLarge = (1 << 3),
    CZ500PhotoModelSizeExtraLarge = (1 << 4)
};


@interface CZ500Request : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, readonly, weak) NSURLRequest *urlRequest;
@property (nonatomic, readonly) CZ500RequestStatus requestStatus;

- (void) cancel;

+ (CZ500Request *) createRequestForPath:(NSString *)path
                                 params:(NSDictionary *) params
                             completion:(CZ500RequestCompletionBlock)completionBlock;

@end
