//
//  TRParseJSON.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 07/02/15.
//  Copyright (c) 2015 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRParseJSON.h"
#import "AppDelegate.h"
#import "Photo.h"
#import "User.h"


void parseJSONData(NSData *data) {
    
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *results = [json objectForKey:@"photos"];
    for (NSDictionary *photoDict in results) {
        
        NSLog(@"photo=%@", [photoDict description]);
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@", [obj objectForKey:@"name"]]];
        [request setFetchLimit:1];
        NSError *error;
        NSUInteger count = [context countForFetchRequest:request error:&error];
        if (!error && count==0){
            Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            if (![[obj objectForKey:@"name"] isKindOfClass:[NSNull class]])photo.name = [obj objectForKey:@"name"];
            if (![[obj objectForKey:@"camera"] isKindOfClass:[NSNull class]]) photo.camera = [obj objectForKey:@"camera"];
            if (![[obj objectForKey:@"description"] isKindOfClass:[NSNull class]]) photo.description_ = [obj objectForKey:@"description"];
            if (![[obj objectForKey:@"image_url"] isKindOfClass:[NSNull class]])photo.image_url = [obj objectForKey:@"image_url"];
            
            if (![[obj objectForKey:@"latitude"] isKindOfClass:[NSNull class]])
                photo.latitude = [obj objectForKey:@"latitude"];
            if (![[obj objectForKey:@"longitude"] isKindOfClass:[NSNull class]])
                photo.longitude = [obj objectForKey:@"longitude"];
            
            photo.rating = [obj objectForKey:@"rating"];
            
            
            
            NSNumber *idUser=[[obj objectForKey:@"user"] objectForKey:@"id"];
            NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"id == %d", idUser];
            [fetchRequest setPredicate:predicateID];
            
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            
            
            User *user;
            if (![fetchedObjects count])
            {
                id userObj=[obj objectForKey:@"user"];
                user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                user.fullname = [userObj objectForKey:@"fullname"];
                user.id = [userObj objectForKey:@"id"];
                user.userpic_https_url = [userObj objectForKey:@"userpic_https_url"];
                user.photo = nil;
            }
            else
            {
                user=[fetchedObjects lastObject];
            }
            photo.user = user;
            
            
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        
        }
        
    }];
    
}

