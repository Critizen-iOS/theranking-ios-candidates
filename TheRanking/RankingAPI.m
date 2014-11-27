//
//  RankingAPI.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 26/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingAPI.h"
#import "RankingStore.h"

#define ASSERT_CONFIGURATION(x)     NSAssert([x.consumerKey length] > 0 && [x.apiEndpoint length] > 0, @"ConsumerKey and ApiEndpoint values needed")

static NSInteger const kHTTPStatusCodeOK = 200;

@interface RankingAPI()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, weak) NSURLSessionDataTask *popularImagesTask;
@property (nonatomic, strong) RankingStore *store;

@end

@implementation RankingAPI

+ (instancetype) sharedInstance {
    static RankingAPI *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.store = [[RankingStore alloc] init];
    }
    return self;
}

- (void) refreshPopularImagesOnError:(void(^)(RankingAPIErrorCode errorCode, NSError *error))errorBlock {

    if(self.popularImagesTask != nil) {
        return;
    }
    
    NSURL *requestURL = [self popularPicturesURL];
    
    __weak typeof(self) wSelf = self;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:requestURL
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
                                                
                                                if (!error) {
                                                    NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
                                                    if (statusCode == kHTTPStatusCodeOK) {
                                                        [wSelf processPopularPicturesResponse: data onError:errorBlock];
                                                    } else {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            errorBlock(RankingAPIErrorCodeCouldntContactServer, nil);
                                                        });
                                                    }
                                                } else {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        errorBlock(RankingAPIErrorCodeUnknown, error);
                                                    });
                                                }
                                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
                                            }];
    [task resume];
    self.popularImagesTask = task;

        
}


- (void) importDictArray:(NSArray *)dictArray usingConversionBlock:(void(^)(Picture *picture, NSDictionary *pictureDict))conversionBlock {
    NSManagedObjectContext *bgContext = [self.store newBackgroundObjectContext];
    
    [bgContext performBlock:^{
        
        // Delete previous stuff
        NSFetchRequest * allPicIds = [[NSFetchRequest alloc] init];
        allPicIds.entity = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:bgContext];
        allPicIds.includesPropertyValues = NO;
        
        NSError * error = nil;
        NSArray * oldPicturesIds = [bgContext executeFetchRequest:allPicIds error:&error];
        for (NSManagedObject * picture in oldPicturesIds) {
            [bgContext deleteObject:picture];
        }
        
        // Create the new stuff
        for(NSDictionary *picDict in dictArray) {
            Picture *newPicture = [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:bgContext];
            conversionBlock(newPicture, picDict);
        }
        
        [bgContext save:&error];
        
    }];
}

- (void) saveCachedData {
    [self.store saveContext];
}

- (NSFetchedResultsController *) popularPictureFetchedResultsController {
    NSManagedObjectContext *moc = [self.store mainObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:10];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"pictureRating" ascending:NO]]];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:moc
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    return fetchedResultsController;

}

#pragma mark NSURLSession stuff

- (NSURLSession *) session {
    if(_session == nil) {
        NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json"} ];
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 120.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 1;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    }
    return _session;
}

#pragma mark Dummy methods that should be implemented in the subclass

- (NSURL *) popularPicturesURL {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (void) processPopularPicturesResponse: (NSData *)response onError:(void(^)(RankingAPIErrorCode errorCode, NSError *error))errorBlock {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
