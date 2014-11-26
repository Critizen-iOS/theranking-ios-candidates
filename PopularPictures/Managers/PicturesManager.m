//
//  PicturesManager.m
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "PicturesManager.h"
#import "CoreDataManager.h"

#define k500pxConsumerKey               @"FMEvCvHM8Ask8kF1BzJa9yEvznnmpHwYxME3S3dh"
#define kPicturesManagerTimeOut         3000

@interface PicturesManager()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation PicturesManager

+(instancetype)sharedManager
{
    static PicturesManager *_sharedManager = nil;
    static dispatch_once_t dispatchOnce;
    
    dispatch_once(&dispatchOnce, ^{
        _sharedManager = [[PicturesManager alloc] init];
    });
    
    return _sharedManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)findPopularPicturesWithSuccessBlock:(void (^)(NSArray *photos))successBlock
                              failureBlock:(void (^)(NSError *error))failureBlock;
{
    NSURL *mostPopularPicturesURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.500px.com/v1/photos?feature=popular&sort=rating&sort_direction=desc&&image_size=3&consumer_key=%@", k500pxConsumerKey]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:mostPopularPicturesURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kPicturesManagerTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            if (failureBlock) {
                failureBlock(connectionError);
            }
            return;
        }

        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *photos = [responseObject objectForKey:@"photos"];
        
        NSLog(@"Photos: %@", photos);
        
        NSMutableArray *insertedPhotos = [NSMutableArray new];
        for (NSDictionary *dictionary in photos) {
            NSManagedObject *photoMO = [[CoreDataManager sharedManager] createPhotoManagedObjectWithDictionary:dictionary];
            [insertedPhotos addObject:photoMO];
        }
        
        if (insertedPhotos.count > 0) {
            [[CoreDataManager sharedManager] saveContext];
        }
        
        if (successBlock) {
            successBlock([NSArray arrayWithArray:insertedPhotos]);
        }
    }];
}

@end
