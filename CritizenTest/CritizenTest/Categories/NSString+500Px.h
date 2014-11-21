//
//  NSString+500Px.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZ500Request.h"

@interface NSString (CZ500Px)

+ (NSString *) stringForPhotoFeature:(CZ500PhotoFeature) feature;

@end
