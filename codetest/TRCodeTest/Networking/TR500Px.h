//
//  TR500Px.h
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TR500PxInfo.h"
#import "TR500PxPhoto.h"

/**
 *  Get photos response block
 *
 *  @param photos list of TR500PxPhoto's
 *  @param error  connection error
 */
typedef void (^getPhotosResponse)(NSArray *photos, NSError *error);

@interface TR500Px : NSObject

/**
 *  Shared TR500Px instance (Singleton pattern)
 *
 *  @return unique TR500Px instance
 */
+ (instancetype)sharedInstance;

/**
 *  Returns a listing of photos for a specified photo stream.
 *
 *  @param information TR500PxInfo object
 *  @param completion  getPhotosResponse completion block
 */
- (void)getPhotosWithInformation:(TR500PxInfo *)information completionBlock:(getPhotosResponse)completion;

@end
