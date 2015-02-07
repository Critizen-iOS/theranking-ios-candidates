//
//  TR500PX.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TR500PX.h"
#import "OAuth.h"
#import "OAuth+Additions.h"
#import "NSString+URLEncoding.h"
#import "TRParseJSON.h"


@interface TR500PX ()
@property (nonatomic, strong) NSString *requestOauthToken;
@property (nonatomic, strong) NSString *requestOauthSecret;
@end

@implementation TR500PX



+ (TR500PX*)sharedInstance
{
    
    static TR500PX *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void) loadDataCompletionBlock:(void (^)(void))completionBlock
{
    [self requestTokenCompletionBlock:^ {
 
        [self downloadListCompletionBlock:completionBlock];

    }];
}


-(void) requestTokenCompletionBlock:(void (^)(void))completionBlock
{
    NSURL *requestURL = [NSURL URLWithString:@"https://api.500px.com/v1/oauth/request_token"];
    NSMutableURLRequest *requestTokenURLRequest = [NSMutableURLRequest requestWithURL:requestURL];
    [requestTokenURLRequest setHTTPMethod:@"POST"];
    
    NSString *requestTokenAuthorizationHeader = OAutHeader(requestURL, @"POST", nil, nil, nil, kConsumerKey, kConsumerSecret);
    
    [requestTokenURLRequest setHTTPMethod:@"POST"];
    [requestTokenURLRequest setValue:requestTokenAuthorizationHeader forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:requestTokenURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSString *returnedRequestTokenString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSDictionary *requestionTokenDictionary = [returnedRequestTokenString oa_parseURL];
             self.requestOauthToken=[requestionTokenDictionary valueForKey:@"oauth_token"];
             self.requestOauthSecret=[requestionTokenDictionary valueForKey:@"oauth_token_secret"];
             
            if (completionBlock)
                 completionBlock();
         }
     }];
}


-(NSURLRequest *)urlRequest
{
    NSMutableURLRequest *mutableRequest;

    NSString *urlString =@"https://api.500px.com/v1/photos";
    mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [mutableRequest setHTTPMethod:@"GET"];
    
    NSMutableString *params = [[NSMutableString alloc] init];
    
    [params appendFormat:@"image_size=%@&", @"1"];
    
    NSData *bodyData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *header = OAutHeader(mutableRequest.URL, @"GET", bodyData, self.requestOauthToken, self.requestOauthSecret, kConsumerKey, kConsumerSecret);
    
    [mutableRequest setValue:header forHTTPHeaderField:@"Authorization"];
    [mutableRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", urlString, params]]];
    
    return mutableRequest;
}



-(void) downloadListCompletionBlock:(void (^)(void))completionBlock
{
    NSURLRequest *req=[self urlRequest];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             parseJSONData(data);
             if (completionBlock)
                 completionBlock();
             
         }
     }];
    
}







@end
