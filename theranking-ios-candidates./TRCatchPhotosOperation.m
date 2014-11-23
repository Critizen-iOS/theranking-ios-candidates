//
//  TRCatchPhotosOperation.m
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import "TRCatchPhotosOperation.h"
#import "TRDataNetManager.h"
#import "Photo.h"
#import "User.h"

@interface TRCatchPhotosOperation ()

@property (nonatomic, strong) NSManagedObjectContext *childMOC;

@end

@implementation TRCatchPhotosOperation

-(void)main
{
    // El servicio está paginado, por ello en función del intervalo de llamada actualizamos o cargamos más paginas.
    // Aqui todo va a depender de como queremos que se comporte nuestra App. (Obviamente es mucho mejor cuando la Api es nuestra)...
    // en fin, filosofía para charlar.
    
    NSInteger nextPage;
    NSTimeInterval lastUpdate = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lastUpdate"];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ((now - lastUpdate) < (3600 * 12))
    {
        nextPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"nextPage"];
    }
    else
    {
        nextPage = 1;
       
    }
    
    self.childMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [self.childMOC setParentContext:self.fatherMOC];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.500px.com/v1/photos?feature=popular&consumer_key=YsURq8PuL1uuYZWOB8bwKq5d2jr4IALtvZTNV7iH&page=%ld",(long)nextPage];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (response.statusCode == 200)
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *photos = [jsonDict valueForKey:@"photos"];
        [self updatePhotosList:photos];
        NSInteger totalPages = [[jsonDict valueForKey:@"total_pages"] integerValue];
        if ((nextPage + 1) < totalPages) {
            [[NSUserDefaults standardUserDefaults] setInteger:(nextPage + 1) forKey:@"nextPage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"nextPage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
    
    
}
-(void)updatePhotosList:(NSArray *)photos
{
    for (NSDictionary *dictPhoto in photos)
    {
        // Comprobamos si existe
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.childMOC]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"resourceId=%@",[dictPhoto valueForKey:@"id"]];
        [request setPredicate:predicate];
        NSArray *photoArray = [self.childMOC executeFetchRequest:request error:nil];
        if ([photoArray count])
        {
            // Existe actualizamos el rating.
            Photo *photo = [photoArray firstObject];
            photo.rating = [NSNumber numberWithFloat:[[dictPhoto valueForKey:@"rating"] floatValue]];
        }
        else
        {
            // Lo creamos
            Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.childMOC];
            newPhoto.resourceId = [dictPhoto valueForKey:@"id"];
            newPhoto.name = [dictPhoto valueForKey:@"name"];
            newPhoto.itsDescription = [dictPhoto valueForKey:@"description"];
            newPhoto.camera = [dictPhoto valueForKey:@"camera"];
            newPhoto.shutter_speed = [dictPhoto valueForKey:@"shutter_speed"];
            newPhoto.focal_length = [dictPhoto valueForKey:@"focal_length"];
            newPhoto.rating = [NSNumber numberWithFloat:[[dictPhoto valueForKey:@"rating"] floatValue]];
            newPhoto.latitude = [NSNumber numberWithDouble:[[dictPhoto valueForKey:@"latitude"] doubleValue]];
            newPhoto.longitude = [NSNumber numberWithDouble:[[dictPhoto valueForKey:@"longitude"] doubleValue]];
            NSString *userId = [dictPhoto valueForKey:@"camera"];
            
            NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
            [userRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.childMOC]];
            NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"resourceId=%@",userId];
            [userRequest setPredicate:userPredicate];
            NSArray *userArray = [self.childMOC executeFetchRequest:userRequest error:nil];
            if ([userArray count])
            {
                User *user = [userArray firstObject];
                newPhoto.user = user;
            }
            else
            {
                User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.childMOC];
                newUser.username = [[dictPhoto valueForKey:@"user"] valueForKey:@"username"];
                newUser.userpic_url = [[dictPhoto valueForKey:@"user"] valueForKey:@"userpic_url"];
                newPhoto.user = newUser;
            }
            
        }
        [self saveObjectInStore];
    }
}




-(void)saveObjectInStore
{
    
    
    // We save the son
    
    NSError *error = nil;
    if (![self.childMOC save:&error])
    {
        NSLog(@"Failure: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    
    // We save the father
    
    [self.fatherMOC performBlock:^{
        
        NSError *error = nil;
        if (![self.fatherMOC save:&error]) {
            NSLog(@"Failure: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }];
    
}

@end
