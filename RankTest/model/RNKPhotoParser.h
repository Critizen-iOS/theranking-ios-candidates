//
//  RNKPhotoParser.h
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

@import CoreData;

/**
 *  Parser for Photos and Users JSON objects.
 */

@interface RNKPhotoParser : NSObject

/**
 *  Insert or updates a picture and their user in a given context. Does NOT save the context
 *  @param pictureJSON NSDic with Picture
 *  @param context 
 */
- (void) addOrModifyPictureWithJSON: (NSDictionary*) pictureJSON inContext: (NSManagedObjectContext*) context;

@end
