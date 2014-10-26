//
//  TRCoreData.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRCoreData.h"

#import "Photo.h"
#import "User.h"

@implementation TRCoreData


+ (TRCoreData*)sharedInstance
{
    
    static TRCoreData *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (NSFetchedResultsController *)fetchedResultsControllerPhoto
{
    if (_fetchedResultsControllerPhoto != nil) {
        return _fetchedResultsControllerPhoto;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // We retrieve all rows.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsControllerPhoto = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsControllerPhoto performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsControllerPhoto;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
}


- (void)parseJSONData:(NSData *)data {
    
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *results = [json objectForKey:@"photos"];
    for (NSDictionary *photoDict in results) {
        
        NSLog(@"photo=%@", [photoDict description]);
    }
    NSManagedObjectContext *context=[[TRCoreData sharedInstance] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        if (![[obj objectForKey:@"name"] isKindOfClass:[NSNull class]])photo.name = [obj objectForKey:@"name"];
        if (![[obj objectForKey:@"camera"] isKindOfClass:[NSNull class]]) photo.camera = [obj objectForKey:@"camera"];
        if (![[obj objectForKey:@"description"] isKindOfClass:[NSNull class]]) photo.description_ = [obj objectForKey:@"description"];
        if (![[obj objectForKey:@"image_url"] isKindOfClass:[NSNull class]])photo.image_url = [obj objectForKey:@"image_url"];
        //NSLog(@"pepep=%f",[[obj objectForKey:@"latitude"] floatValue]  );
        if (![[obj objectForKey:@"latitude"] isKindOfClass:[NSNull class]])
            photo.latitude = [obj objectForKey:@"latitude"];
        if (![[obj objectForKey:@"longitude"] isKindOfClass:[NSNull class]])
            photo.longitude = [obj objectForKey:@"longitude"];
        NSLog(@"fkjdhvg=%@", [obj objectForKey:@"rating"]);
        photo.rating = [obj objectForKey:@"rating"];


        
        NSNumber *idUser=[[obj objectForKey:@"user"] objectForKey:@"id"];
        NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"id == %d", idUser];
        [fetchRequest setPredicate:predicateID];
        
        NSError* error=nil;
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
        
        NSLog(@"firstname=%@", [[obj objectForKey:@"user"] objectForKey:@"firstname"]);
        NSLog(@"camera=%@", [obj objectForKey:@"camera"]);
    }];
    
}





@end
