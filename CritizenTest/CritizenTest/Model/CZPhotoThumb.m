//
//  CZPhotoThumb.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZPhotoThumb.h"
#import "NSObject+Null.h"

@implementation CZPhotoThumb

@synthesize id;
@synthesize name;
@synthesize url;

- (id) initWithJSONData:(NSDictionary *) jsonData{

    self = [super init];
    
    if (self) {
        
        //
        // Id
        //
        if ([[jsonData objectForKey:@"id"] isNotNull]) {
            self.id = [NSNumber numberWithInteger:[[jsonData objectForKey:@"id"] integerValue]];
        }
        
        //
        // Name
        //
        if ([[jsonData objectForKey:@"name"] isNotNull]) {
            self.name = [jsonData objectForKey:@"name"];
        }
        
        //
        // URL
        //
        if ([[jsonData objectForKey:@"image_url"] isNotNull]) {
            self.url = [jsonData objectForKey:@"image_url"];
        }
        
        //
        // rating
        //
        if ([[jsonData objectForKey:@"rating"] isNotNull]) {
            
            float rating    = [[jsonData objectForKey:@"rating"] floatValue];
            self.rating     = [NSNumber numberWithFloat:rating];
        }
        
    }
    
    return self;
}

@end
