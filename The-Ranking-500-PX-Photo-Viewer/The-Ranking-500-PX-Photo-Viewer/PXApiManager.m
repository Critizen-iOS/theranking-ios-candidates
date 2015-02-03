//
//  PXApiManager.m
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import "PXApiManager.h"
#import "PXPhoto.h"
#import "PXAuthor.h"
#import "PXDataModel.h"

#define kPXAPIConsumerKey       @"HYjHuDSmeajzHh7hZchPTZYRbHdOqqABbLxHWEfX"
#define kPXAPIConsumerSecret    @"e8pglNlcfTXBu0scorqaqs63KXH7smuN7iqy3Bws"

@implementation PXApiManager

- (void)searchPhotos:(NSString *)searchString inPage:(NSNumber *)page withCompletionBlock:(PXSearchPhotosCompletionBlock)completionBlock
{
    if ([[[PXDataModel sharedInstance] pagesLoadedDict] objectForKey:[page stringValue]] != nil)
    {
        completionBlock(searchString, nil, nil);
    }
    
    // Customize the search string with consumer key
    searchString = [NSString stringWithFormat:searchString, page, kPXAPIConsumerKey];
    
    // Execute asynchronosly call
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchString]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error];
        // Check the execution
        if (error)
        {
            completionBlock(searchString, nil, error);
        }
        else
        {
            // If not have an error, parse the json response
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                             options:kNilOptions
                                                                               error:&error];
            
            // Chech error parsing data
            if (error)
            {
                completionBlock(searchString, nil, error);
            }
            else
            {
                NSLog(@"%@", searchResultDict);
                
                // Update model
                [[PXDataModel sharedInstance] setTotalPages:[self getNSNumberFromString:searchResultDict[@"current_page"]]];
                [[PXDataModel sharedInstance] setTotalPages:[self getNSNumberFromString:searchResultDict[@"total_pages"]]];
                [[PXDataModel sharedInstance] setTotalPages:[self getNSNumberFromString:searchResultDict[@"total_items"]]];
                
                // Obtain photos info from dictionary
                NSArray *photos = searchResultDict[@"photos"];
                
                // Create photo list (PXPhoto objects)
                NSMutableArray *photoList = [[NSMutableArray alloc] init];
                
                // Loop into photo list data
                for (NSMutableDictionary *photo in photos)
                {
                    // Create PXPhoto object
                    PXPhoto *pxPhoto = [[PXPhoto alloc] init];
                    
                    // Configure formatter
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                    
                    // Set the data from response
                    pxPhoto.photoId = [self getNSNumberFromString:photo[@"id"]];
                    pxPhoto.userId = [self getNSNumberFromString:photo[@"user_id"]];
                    pxPhoto.name = [self getNSStringFromString:photo[@"name"]];
                    pxPhoto.photoDescription = [self getNSStringFromString:photo[@"description"]];
                    pxPhoto.camera = [self getNSStringFromString:photo[@"camera"]];
                    pxPhoto.lens = [self getNSStringFromString:photo[@"lens"]];
                    pxPhoto.focalLength = [self getNSStringFromString:photo[@"focal_length"]];
                    pxPhoto.iso = [self getNSStringFromString:photo[@"iso"]];
                    pxPhoto.shutterSpeed = [self getNSStringFromString:photo[@"shutter_speed"]];
                    pxPhoto.aperture = [self getNSStringFromString:photo[@"aperture"]];
                    pxPhoto.rating = [self getNSNumberFromString:photo[@"rating"]];
                    pxPhoto.createdAt = [self getNSDateFromString:photo[@"created_at"]];
                    pxPhoto.location = [self getNSStringFromString:photo[@"location"]];
                    pxPhoto.coordinate = [self getCLLocationCoordinate2DFromString:photo[@"latitude"] andLongitude:photo[@"longitude"]];
                    pxPhoto.imageURL = [self getNSStringFromString:photo[@"image_url"]];
                    
                    // Get de user
                    NSMutableDictionary *author = photo[@"user"];
                    
                    // Set the author data
                    pxPhoto.author = [[PXAuthor alloc] init];
                    pxPhoto.author.userId = [self getNSNumberFromString:author[@"id"]];
                    pxPhoto.author.username = [self getNSStringFromString:author[@"username"]];
                    pxPhoto.author.firstname = [self getNSStringFromString:author[@"firstname"]];
                    pxPhoto.author.lastname = [self getNSStringFromString:author[@"lastname"]];
                    pxPhoto.author.fullname = [self getNSStringFromString:author[@"fullname"]];
                    pxPhoto.author.pictureURL = [self getNSStringFromString:author[@"userpic_url"]];
                    
                    // Add photo to the list
                    [photoList addObject:pxPhoto];
                }
                
                completionBlock(searchString, photoList, nil);
            }
        }
        
    });
}

#pragma mark - Helpers methods

- (NSString *)valueIsNotNil:(id)value
{
    return (value == [NSNull null]) ? nil : value;
}

- (NSString *)getNSStringFromString:(id)value
{
    return [self valueIsNotNil:value];
}

- (NSNumber *)getNSNumberFromString:(id)value
{
    return [self valueIsNotNil:value] ? value : nil;
}

- (NSDate *)getNSDateFromString:(id)value
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    return [self valueIsNotNil:value] ? [dateFormatter dateFromString:value] : nil;
}

- (CLLocationCoordinate2D)getCLLocationCoordinate2DFromString:(id)latitude andLongitude:(id)longitude
{
    return ([self valueIsNotNil:latitude] && [self valueIsNotNil:longitude]) ? CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]) : CLLocationCoordinate2DMake(0.0, 0.0);
}


@end














