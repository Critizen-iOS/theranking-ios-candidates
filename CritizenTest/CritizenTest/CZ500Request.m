//
//  CZ500Request.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZ500Request.h"
#import "NSString+500Px.h"

NSString *const CZ500Host = @"https://api.500px.com/v1";

#define k500PXConsumerKey @"K9AKCMYBWLydvE7Sv6btZSQydjCKc42vkhpyonQM"

@interface CZ500Request ()
{
    NSURLConnection * urlConnection;
    NSMutableData   * receivedData;
    
    CZ500RequestCompletionBlock requestCompletionBlock;
}
- (void) _start;
- (NSURLConnection *) _urlConnectionForURLRequest:(NSURLRequest *) request;

@end

@implementation CZ500Request

@synthesize urlRequest = _urlRequest;
@synthesize requestStatus = _requestStatus;


#pragma mark - Instance Methods

- (void) cancel
{
    [urlConnection cancel];
    
    _requestStatus = CZ500RequestStatusCancelled;
    
    if(requestCompletionBlock){
        
        NSError * error = [NSError errorWithDomain:@"Request Cancelled"
                                              code:CZ500RequestStatusCancelled
                                          userInfo:nil];
        
        requestCompletionBlock(nil, error);
    }
}

#pragma mark - Class Methods

+ (CZ500Request *) createRequestForPath:(NSString *)path
                                 params:(NSDictionary *) params
                             completion:(CZ500RequestCompletionBlock)completionBlock
{
    NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@/%@?consumer_key=%@", CZ500Host, path, k500PXConsumerKey];
    
    for (id key in params.allKeys)
    {
        [urlString appendFormat:@"&%@=%@", key, [params valueForKey:key]];
    }
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    CZ500Request *request = [[CZ500Request alloc] _initWithURLRequest:urlRequest
                                                           completion:^(NSDictionary *results, NSError *error) {
                                                               
                                                               if (completionBlock)
                                                               {
                                                                   completionBlock(results, error);
                                                               }
                                                           }];
    
    [request _start];
    
    return request;
}

#pragma mark - Private Methods

- (id) _initWithURLRequest:(NSURLRequest *)urlRequest
                completion:(CZ500RequestCompletionBlock)completion
{
    self = [super init];
    
    if (self) {
        
        _urlRequest     = urlRequest;
        _requestStatus  = CZ500RequestStatusNotStarted;
        
        requestCompletionBlock = [completion copy];
    }
    
    return self;
}

- (void) _start
{
    _requestStatus  = CZ500RequestStatusStarted;
    
    receivedData    = [NSMutableData data];
    urlConnection   = [self _urlConnectionForURLRequest:self.urlRequest];
    
    [urlConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [urlConnection start];
}

- (NSURLConnection *) _urlConnectionForURLRequest:(NSURLRequest *) request
{
    return [[NSURLConnection alloc] initWithRequest:request
                                           delegate:self];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Request to %@ failed with error: %@", self.urlRequest.URL, error);
    
    _requestStatus = CZ500RequestStatusFailed;
    
    if (requestCompletionBlock)
    {
        requestCompletionBlock(nil, error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;

    NSUInteger statusCode = httpResponse.statusCode;
    
    if (statusCode != 200)
    {
        [connection cancel];
        _requestStatus = CZ500RequestStatusFailed;
        
        if (requestCompletionBlock)
        {
            NSError *error = [NSError errorWithDomain:@"Request Error"
                                                 code:statusCode
                                             userInfo:@{ NSURLErrorKey : self.urlRequest.URL}];
            requestCompletionBlock(nil, error);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _requestStatus = CZ500RequestStatusCompleted;
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:receivedData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
    if (requestCompletionBlock)
    {
        requestCompletionBlock(responseDictionary, nil);
    }
}

@end
