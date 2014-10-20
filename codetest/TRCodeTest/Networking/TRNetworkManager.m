//
//  TRNetworkManager.m
//  TRCodeTest
//
//  Created by Oscar on 18/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "TRNetworkManager.h"

@implementation TRNetworkManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TRNetworkManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TRNetworkManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)GET:(NSURL *)url completionBlock:(NetworkResponseBlock)completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
 
        NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        completion(data, responseData, connectionError);
    }];
}

@end
