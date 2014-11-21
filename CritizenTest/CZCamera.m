//
//  CZCamera.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZCamera.h"
#import "CZPhoto.h"
#import "NSObject+Null.h"

@implementation CZCamera

@dynamic lens;
@dynamic model;
@dynamic photos;

+ (CZCamera *) createCameraWithJSONData:(NSDictionary *) jsonData context:(NSManagedObjectContext *) context{
    
    CZCamera* camera = [NSEntityDescription insertNewObjectForEntityForName:@"CZCamera"
                                                     inManagedObjectContext:context];
    
    //
    // Lens
    //
    if ([[jsonData objectForKey:@"lens"] isNotNull]) {
        [camera setLens:[jsonData objectForKey:@"lens"]];
    }
    
    //
    // Model
    //
    if ([[jsonData objectForKey:@"camera"] isNotNull]) {
        [camera setModel:[jsonData objectForKey:@"camera"]];
    }
    
    return camera;
}

@end
