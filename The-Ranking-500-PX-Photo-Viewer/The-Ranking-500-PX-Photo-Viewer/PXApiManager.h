//
//  PXApiManager.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PXPhoto;

typedef void (^PXSearchPhotosCompletionBlock)(NSString *searchString, NSArray *results, NSError *error);

@interface PXApiManager : NSObject

- (void)searchPhotos:(NSString *)searchString inPage:(NSNumber *)page withCompletionBlock:(PXSearchPhotosCompletionBlock)completionBlock;

@end
