//
//  OAuth+Additions.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Helper to parse URL and get the nonce string.
 */
@interface NSString (OAuthAdditions)


/**
 Parse the URL query string
 @returns NSDictionary with the data parsed
 */
- (NSDictionary *)oa_parseURL;

/**
 Get the nonce to build the oAuth header
 @returns NSString with the nonce
 */
+ (NSString *)nonce;


@end
