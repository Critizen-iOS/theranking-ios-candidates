//
//  RNKPhotoParser.h
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface RNKPhotoParser : NSObject

- (void) addOrModifyPictureWithJSON: (NSDictionary*) pictureJSON inContext: (NSManagedObjectContext*) context;

@end
