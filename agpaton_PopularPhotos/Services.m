//
//  Services.m
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 31/10/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import "Services.h"
#import "AppDelegate.h"

@implementation Services

static const NSString * CONSUMER_KEY = @"uT5uXXputN0AjUD1UUyfSCowsY5VK3PXwrZ5DEmT";

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (void)GetMostPopularPhotosWithPage:(NSNumber *)page completion:(void (^)(BOOL success))callback
{

    NSManagedObjectContext *mainMOC = [self appDelegate].managedObjectContext;
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.foodinterest.favouritesqueue", NULL);
    
    dispatch_async(downloadQueue, ^{
        
        NSManagedObjectContext *childMOC = [[self appDelegate] childMOCFromManagedObjectContext:mainMOC];
        
        NSDictionary *json = [self GetMostPopularPhotosWithPage:page];
        
        //Remove all data everytime app is launched
        if ([page integerValue] == 1) {
            [self deleteCoreData:childMOC];
        }
        
        NSArray *photos = [json objectForKey:@"photos"];
        
        [self UpdateCoreDataCacheWithJSON:photos andManagedObjectContext:childMOC];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (callback) {
                callback (YES);
            }
            
            if ([mainMOC hasChanges]) {
                [[self appDelegate] saveContext];
            }
        });
    });
}

+ (NSDictionary *)GetMostPopularPhotosWithPage:(NSNumber *)page
{
    @try
    {
        NSString *query = [NSString stringWithFormat:@"https://api.500px.com/v1/photos?feature=popular&page=%@&consumer_key=%@", page, CONSUMER_KEY];
        
        NSURL *url = [NSURL URLWithString:query];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSLog(@"url %@", url);
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:100];
        
        NSError *errorReturned = nil;
        
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
        
        if (!errorReturned)
        {
            NSError* error;
    
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (responseDict.count!=0) {
                return responseDict;
            }
        
        }
        return nil;
    }
    @catch (NSException *exception)
    {
        NSLog(@"ERROR Get Photo REQUEST SERVICE");
        return nil;
    }
}

+ (void) UpdateCoreDataCacheWithJSON:(NSArray*)photoList andManagedObjectContext:(NSManagedObjectContext *)childMOC;
{
    NSError *error;
    
    for (NSDictionary *photo in photoList) {
        
        NSNumber *ID = [photo objectForKey:@"id"];
        
        Photo *p = [self GetPhotoWithID:ID andManagedObjectContext:childMOC];
        
        if (!p) {
            p = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext: childMOC];
        }
        
        p.photo_id = ID;
        p.photo_name = ([photo objectForKey:@"name"] == [NSNull null]) ? @"" : [photo objectForKey:@"name"];
        p.photo_description = ([photo objectForKey:@"description"] == [NSNull null]) ? @"" : [photo objectForKey:@"description"];
        p.photo_rating = [photo objectForKey:@"rating"];
        p.photo_imageUrl = ([photo objectForKey:@"image_url"] == [NSNull null]) ? @"" : [photo objectForKey:@"image_url"];
        
        NSObject *latitude = [photo objectForKey:@"latitude"];
        
        if (latitude != [NSNull null]) {
            p.photo_latitude = (NSNumber *)latitude;
        }
        
        NSObject *longitude = [photo objectForKey:@"longitude"];
        
        if (longitude != [NSNull null]) {
            p.photo_longitude = (NSNumber *)longitude;
        }

        
        if (!p.photo_camera_info) {
            Camera *c = [NSEntityDescription insertNewObjectForEntityForName:@"Camera" inManagedObjectContext: childMOC];
            
            c.camera_name = ([photo objectForKey:@"camera"] == [NSNull null]) ? @"" : [photo objectForKey:@"camera"];
            c.camera_lens = ([photo objectForKey:@"lens"] == [NSNull null]) ? @"" : [photo objectForKey:@"lens"];
            c.camera_focal_length = ([photo objectForKey:@"focal_length"] == [NSNull null]) ? @"" : [photo objectForKey:@"focal_length"];
            c.camera_iso = ([photo objectForKey:@"iso"] == [NSNull null]) ? @"" : [photo objectForKey:@"iso"];
            c.camera_shutter_speed = ([photo objectForKey:@"shutter_speed"] == [NSNull null]) ? @"" : [photo objectForKey:@"shutter_speed"];
            c.camera_aperture = ([photo objectForKey:@"aperture"] == [NSNull null]) ? @"" : [photo objectForKey:@"aperture"];
            
            [p setPhoto_camera_info:c];
            [c setPhoto:p];

        }
        
        NSDictionary *userInfo = [photo objectForKey:@"user"];
        
        if (userInfo.count!=0) {
            
            NSNumber *uID = [userInfo objectForKey:@"id"];
            
            User *u = [self GetUserWithID:uID andManagedObjectContext:childMOC];
            
            if (!u) {
                u = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext: childMOC];
            }
            
            if (!p.photo_user_info) {
                [p setPhoto_user_info:u];
            }
            
            if (![u.photo containsObject:p]) {
                [u addPhotoObject:p];
            }
            
            u.user_id = uID;
            u.user_name = [userInfo objectForKey:@"fullname"];
            u.user_image = ([userInfo objectForKey:@"userpic_url"] == [NSNull null]) ? @"" : [userInfo objectForKey:@"userpic_url"];
        }
    }
    
    if ([childMOC hasChanges]) {
        [childMOC save:&error];
    }
}

+ (Photo *) GetPhotoWithID:(NSNumber*)ID andManagedObjectContext: (NSManagedObjectContext *)managedObjectContext
{
 
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext: managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(photo_id == %@)", ID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (error == nil) // error handling code
    {
        if ([results count] > 0)
            return [results objectAtIndex:0];
    }
    return nil;
}

+ (User *) GetUserWithID:(NSNumber*)ID andManagedObjectContext: (NSManagedObjectContext *)managedObjectContext
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext: managedObjectContext]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(user_id == %@)", ID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (error == nil) // error handling code
    {
        if ([results count] > 0)
            return [results objectAtIndex:0];
    }
    return nil;
}

+ (void)deleteCoreData:(NSManagedObjectContext *)managedObjectContext
{
    [self deleteAllObjects:@"Photo" andManagedObjectContext:managedObjectContext];
}

+ (void) deleteAllObjects: (NSString *) entityDescription andManagedObjectContext:(NSManagedObjectContext *)managedObjectContext  {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
}

@end
