//
//  PXClient.m
//  CritizenTestApp
//
//  Created by Patricio on 17/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "PXClient.h"

#define kOAuthConsumerKey @"vW2Fcq9jbaoJnIw5YB1fna0WaZFGuZDRz4eQTfmy"

NSString *const PXClientBaseURL = @"https://api.500px.com/v1";

@implementation PXClient

#pragma mark - Class Methods

+ (PXClient *)sharedClient
{
    static PXClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PXClient alloc] init];
        sharedClient.clientQueue = [NSOperationQueue mainQueue];
    });
    
    return sharedClient;
}

+ (void)performRequestForPath:(NSString *)path
                       params:(NSDictionary *)params
              completionBlock:(PXClientCompletionBlock)block
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@?consumer_key=%@", PXClientBaseURL, path, kOAuthConsumerKey];
    for (NSString *key in [params allKeys]) {
        [urlString appendFormat:@"&%@=%@", key, [params valueForKey:key]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[PXClient sharedClient].clientQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            // Handle error
            if (block) {
                block(nil, error);
            }
        } else {
            // Successfull request
            if (block) {
                
                NSError *serializationError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
                
                if (serializationError) {
                    // Handle serialization error
                    block(nil, error);
                } else {
                    // Successfull serialization returning json
                    block(json, error);
                }
            }
        }
    }];
}

@end
