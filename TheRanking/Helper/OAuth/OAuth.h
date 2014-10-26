//
//  OAutHeader.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Build the oAuth header
 @returns the NSString with the oAuth header
 */
extern NSString *OAutHeader(NSURL *url, NSString *method, NSData *body, NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *oAuthConsumerKey, NSString *oAuthConsumerSecret);
