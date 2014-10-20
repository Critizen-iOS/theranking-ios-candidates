//
//  TR500PxInfo+Extras.h
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TR500PxInfo.h"

@interface TR500PxInfo (Extras)

/**
 *  Helper to get string from TR500PxFeature
 *
 *  @param feature TR500PxFeature
 *
 *  @return valid feature string
 */
- (NSString *)stringFromFeature:(TR500PxFeature)feature;

/**
 *  Helper to get string from TR500PxSort
 *
 *  @param sort TR500PxSort
 *
 *  @return sort string
 */
- (NSString *)stringFromSort:(TR500PxSort)sort;

@end
