//
//  CZ500Connector.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZ500Connector.h"
#import "CZCoreDataManager.h"
#import "CZ500Request.h"
#import "NSString+500Px.h"

@implementation CZ500Connector

#pragma mark - Class Methods

+ (CZ500Request *) requestForPhotoFeature:(CZ500PhotoFeature)photoFeature
                                     page:(NSInteger)page
                               photoSizes:(CZ500PhotoModelSize)photoSizesMask
                               completion:(CZFeaturedPhotosRequestCompletionBlock)completionBlock
{
    
    NSMutableDictionary *options = [@{@"feature" : [NSString stringForPhotoFeature:photoFeature],
                                      @"rpp" : @(kDefaultResultsPerPage),
                                      @"page" : @(page),
                                      @"sort": @"rating",
                                      @"image_size": @(photoSizesMask)
                                      } mutableCopy];
    
    CZ500Request *request = [CZ500Request createRequestForPath:@"/photos"
                                                        params:options
                                                    completion:^(NSDictionary *results, NSError *error) {

                                                        if(completionBlock){
                                                            
                                                            if (!error) {
                                                                
                                                                // Are there more photos
                                                                NSInteger totalPages  = [[results objectForKey:@"total_pages"] integerValue];
                                                                BOOL morePhotos       = (page < totalPages) ? YES:NO;
                                                                
                                                                NSArray * photosArray = [results objectForKey:@"photos"];
                                                                NSMutableArray * resultThumbs = [NSMutableArray array];
                                                                
                                                                for(NSDictionary * thumbData in photosArray)
                                                                {
                                                                    CZPhotoThumb * thumbObj = [[CZPhotoThumb alloc] initWithJSONData:thumbData];
                                                                    
                                                                    if (thumbObj)
                                                                        [resultThumbs addObject:thumbObj];
                                                                }
                                                                
                                                                completionBlock(resultThumbs, morePhotos, error);
                                                                
                                                            }else{
                                                                completionBlock(nil, NO, error);
                                                            }
                                                        }
                                                    }];
    return request;
}

+ (CZ500Request *) requestForPhotoID:(NSInteger)photoID
                          photoSizes:(CZ500PhotoModelSize)photoSizesMask
                          completion:(CZPhotoRequestCompletionBlock)completionBlock
{
    
    NSMutableDictionary *options = [@{@"image_size" : @(photoSizesMask),
                                      @"comments"   : @(-1)
                                      } mutableCopy];
    
    CZ500Request *request = [CZ500Request createRequestForPath:[NSString stringWithFormat:@"/photos/%ld", (long)photoID]
                                                        params:options
                                                    completion:^(NSDictionary *result, NSError *error) {
                                                        
                                                        if (completionBlock) {
                                                            
                                                            if (!error) {
                                                                
                                                                NSDictionary * photoData = [result objectForKey:@"photo"];
                                                                
                                                                CZPhoto * photo = [[CZCoreDataManager sharedSingleton] createPhotoWithData:photoData];
                                                                
                                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                        [[CZCoreDataManager sharedSingleton] saveContext];
                                                                    });
                                                                });
                                                                
                                                                
                                                                completionBlock(photo, error);

                                                            }else{
                                                                completionBlock(nil, error);
                                                            }
                                                        }
                                                    }];
    
    return request;
}


@end
