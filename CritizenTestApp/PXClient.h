//
//  PXClient.h
//  CritizenTestApp
//
//  Created by Patricio on 17/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXClient : NSObject <NSURLConnectionDataDelegate>

typedef void (^PXClientCompletionBlock)(NSDictionary *dataDictionary, NSError *error);

@property (strong, nonatomic) NSOperationQueue *clientQueue;

+ (PXClient *)sharedClient;
+ (void)performRequestForPath:(NSString *)path
                       params:(NSDictionary *)params
              completionBlock:(PXClientCompletionBlock)block;

@end
