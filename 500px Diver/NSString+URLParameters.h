//
//  NSDictionary+URLParameters.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This category adds methods to add parameters inside a given URL
@interface NSString (URLParameters)

/**
 * Scapes the given string to be used as a valid URL
 * @param unencodedString
 * @return escaped string
 */
+ (NSString*)urlEscapeString:(NSString *)unencodedString;

/**
 * Add the given parameters to the URL string
 * @param urlString original URL
 * @param dictionary parameters to be added
 * @return URL with parameters included
 */
+ (NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;

@end
