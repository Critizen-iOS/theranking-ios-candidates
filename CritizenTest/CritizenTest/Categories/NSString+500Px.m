//
//  NSString+500Px.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "NSString+500Px.h"

@implementation NSString (CZ500Px)

+ (NSString *) stringForPhotoFeature:(CZ500PhotoFeature) feature
{
    NSString *photoFeatureString;
    switch (feature)
    {
        case CZ500PhotoFeaturePopular:
            photoFeatureString = @"popular";
            break;
        case CZ500PhotoFeatureEditors:
            photoFeatureString = @"editors";
            break;
        case CZ500PhotoFeatureFreshToday:
            photoFeatureString = @"fresh_today";
            break;
        case CZ500PhotoFeatureFreshWeek:
            photoFeatureString = @"fresh_week";
            break;
        case CZ500PhotoFeatureFreshYesterday:
            photoFeatureString = @"fresh_yesterday";
            break;
        case CZ500PhotoFeatureUpcoming:
            photoFeatureString = @"upcoming";
            break;
    }
    
    return photoFeatureString;
}

@end
