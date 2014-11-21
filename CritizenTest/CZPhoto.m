//
//  CZPhoto.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZCoreDataManager.h"
#import "CZPhoto.h"
#import "NSObject+Null.h"

@implementation CZPhoto

@dynamic descrip;
@dynamic id;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic url;
@dynamic author;
@dynamic camera;

+ (CZPhoto *) createPhotoWithJSONData:(NSDictionary *) jsonData context:(NSManagedObjectContext *) context{

    CZPhoto* photo = [NSEntityDescription insertNewObjectForEntityForName:@"CZPhoto"
                                                   inManagedObjectContext:context];

    //
    // Id
    //
    if ([[jsonData objectForKey:@"id"] isNotNull]) {
        photo.id = [NSNumber numberWithInteger:[[jsonData objectForKey:@"id"] integerValue]];
    }
    
    //
    // Name
    //
    if ([[jsonData objectForKey:@"name"] isNotNull]) {
        photo.name = [jsonData objectForKey:@"name"];
    }
    
    //
    // URL
    //
    if ([[jsonData objectForKey:@"image_url"] isNotNull]) {
        photo.url = [jsonData objectForKey:@"image_url"];
    }
    
    //
    // Description
    //
    if ([[jsonData objectForKey:@"description"] isNotNull]) {
        
        photo.descrip = [jsonData objectForKey:@"description"];
    }
    
    //
    // Latitude
    //
    if ([[jsonData objectForKey:@"latitude"] isNotNull]) {
        
        photo.latitude = [NSNumber numberWithDouble:[[jsonData objectForKey:@"latitude"] doubleValue]];
    }
    
    //
    // Longitude
    //
    if ([[jsonData objectForKey:@"longitude"] isNotNull]) {
        
        photo.longitude = [NSNumber numberWithDouble:[[jsonData objectForKey:@"longitude"] doubleValue]];
    }
    
    //
    // Camera
    //
    if ([[jsonData objectForKey:@"camera"] isNotNull] || [[jsonData objectForKey:@"lens"] isNotNull]) {
        
        CZCamera * camera = [[CZCoreDataManager sharedSingleton] createCameraWithData:jsonData];
        
        if (camera) {
            photo.camera = camera;
        }
    }
    
    //
    // Author
    //
    if ([[jsonData objectForKey:@"user"] isNotNull]) {
        
        NSDictionary * userData = [jsonData objectForKey:@"user"];
        
        CZUser * user = [[CZCoreDataManager sharedSingleton] createUserWithData:userData];
        
        if (user) {
            photo.author = user;
        }
    }
    
    return photo;
}

@end
