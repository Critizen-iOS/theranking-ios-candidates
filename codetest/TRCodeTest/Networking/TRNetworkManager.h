//
//  TRNetworkManager.h
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NetworkResponseBlock response block
 *
 *  @param responseData raw response data
 *  @param response     converted response string
 *  @param error        connection error
 */
typedef void (^NetworkResponseBlock)(NSData *responseData, NSString *response, NSError *error);

@interface TRNetworkManager : NSObject

/**
 *  Shared TRNetworkManager instance (Singleton pattern)
 *
 *  @return unique TRNetworkManager instance
 */
+ (instancetype)sharedInstance;

/**
 *  Performs an asynchronous load of the given
 *  request. When the request has completed or failed,
 *  the block will be executed.
 *
 *  @param url        remote url
 *  @param completion NetworkResponseBlock
 */
- (void)GET:(NSURL *)url completionBlock:(NetworkResponseBlock)completion;

@end
