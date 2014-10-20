//
//  TR500PxInfo+Extras.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TR500PxInfo+Extras.h"

@implementation TR500PxInfo (Extras)

- (NSString *)stringFromFeature:(TR500PxFeature)feature {
    switch (feature) {
        case POPULAR:
            return @"popular";
            break;
        case HIGHEST_RATED:
            return @"highest_rated";
            break;
        case UPCOMING:
            return @"upcoming";
            break;
        case EDITORS:
            return @"editors";
            break;
        case FRESH_TODAY:
            return @"fresh_today";
            break;
        case FRESH_YESTERDAY:
            return @"fresh_yesterday";
            break;
        case FRESH_WEEK:
            return @"fresh_week";
            break;
        default:
            return @"popular"; // Default
            break;
    }
    return @"";
}

- (NSString *)stringFromSort:(TR500PxSort)sort {
    switch (sort) {
        case CREATED_AT:
            return @"created_at";
            break;
        case RATING:
            return @"rating";
            break;
        case HIGHEST_RATING:
            return @"highest_rating";
            break;
        case TIMES_VIEWED:
            return @"times_viewed";
            break;
        case VOTES_COUNT:
            return @"votes_count";
            break;
        case FAVORITES_COUNT:
            return @"favorites_count";
            break;
        case COMMENT_COUNT:
            return @"comments_count";
            break;
        case TAKEN_AT:
            return @"taken_at";
            break;
        default:
            return @"rating"; // Default
            break;
    }
    return @"";
}

@end
