//
//  FHDDataWebService.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDWebService.h"

#import "NSString+URLParameters.h"

#define kBaseUrl "https://api.500px.com/v1"
#define kPhotosService "photos"

@implementation FHDWebService

- (void)sendGetRequestToService:(NSString *)service
                 withParameters:(NSDictionary *)params
                   completionBlock:(void(^)(NSArray *items))completion
{

    // Add consumer key
    NSMutableDictionary *paramsAuth = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsAuth setObject:@"Tqft8c4pqAZtsERZxlXtxEXbNda8pRPBv7ht8IJF" forKey:@"consumer_key"];
    
    // Build final URL
    NSString *baseUrl= [NSString stringWithFormat:@"%s/%@", kBaseUrl, service];
    NSURL *completeUrl = [NSURL URLWithString: [NSString addQueryStringToUrlString:baseUrl withDictionary:paramsAuth]];

    // Configure session with "Accept" header and MIME type "application/json"
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Accept" : @"application/json"};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];

    NSURLSessionDataTask *downloadTask = [session
                                          dataTaskWithURL:completeUrl
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSError *localError = nil;
                                              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                   options:0
                                                                                                     error:&localError];
                                              
                                              completion([json objectForKey:@"photos"]);
                                          }];
    [downloadTask resume];
    
}

- (void)getPopularRequestFromPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion
{
    NSDictionary *params = @{@"feature" : @"popular", @"page" : [NSString stringWithFormat:@"%ld", page]};
    [self sendGetRequestToService:@kPhotosService withParameters:params completionBlock:completion];
    
}

@end
