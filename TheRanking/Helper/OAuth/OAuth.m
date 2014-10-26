//
//  OAutHeader.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//
#import "OAuth.h"
#import "OAuth+Additions.h"
#import "NSData+Base64.h"
#import "NSString+URLEncoding.h"
#import <CommonCrypto/CommonHMAC.h>



static NSData *HMAC_SHA1(NSString *data, NSString *key) {
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [key UTF8String], [key length], [data UTF8String], [data length], buf);
    return [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
}

NSString *OAutHeader(NSURL *url, NSString *method, NSData *body, NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *oAuthConsumerKey, NSString *oAuthConsumerSecret)
{
    NSMutableDictionary *oAuthParam = [NSMutableDictionary dictionary];
    [oAuthParam setObject:[NSString nonce] forKey:@"oauth_nonce"];
    [oAuthParam setObject:[NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]] forKey:@"oauth_timestamp"];
    [oAuthParam setObject:@"HMAC-SHA1" forKey:@"oauth_signature_method"];
    [oAuthParam setObject:@"1.0" forKey:@"oauth_version"];
    [oAuthParam setObject:oAuthConsumerKey forKey:@"oauth_consumer_key"];
    
    if(oAuthToken) [oAuthParam setObject:oAuthToken forKey:@"oauth_token"];

    NSDictionary *addQueryParams = [[url query] oa_parseURL];
    NSDictionary *addBodyParams = nil;
    if(body)
    {
        NSString *string = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
        if(string) addBodyParams = [string oa_parseURL];

    }

    NSMutableDictionary *parameters = [oAuthParam mutableCopy];
    if(addQueryParams) [parameters addEntriesFromDictionary:addQueryParams];
    if(addBodyParams) [parameters addEntriesFromDictionary:addBodyParams];
    NSMutableArray *encodedParameterStringArray = [NSMutableArray array];
    for(NSString *key in parameters)
    {
        NSString *value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
            [encodedParameterStringArray addObject:[NSString stringWithFormat:@"%@=%@", [key urlEncode], [value urlEncode]]];
        else if ([value isKindOfClass:[NSArray class]])
            for (id item in (NSArray *)value)
                [encodedParameterStringArray addObject:[NSString stringWithFormat:@"%@%%5B%%5D=%@", [key urlEncode], [item urlEncode]]];
    }
    NSArray *sortedParameterArray = [encodedParameterStringArray sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedParameterString = [sortedParameterArray componentsJoinedByString:@"&"];
    NSString *normalizedURLString = [NSString stringWithFormat:@"%@://%@%@", [url scheme], [url host], [url path]];
    NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@",
                                     [method urlEncode],
                                     [normalizedURLString urlEncode],
                                     [normalizedParameterString urlEncode]];
    NSString *key = [NSString stringWithFormat:@"%@&%@",
                     [oAuthConsumerSecret urlEncode],
                     (oAuthTokenSecret) ? [oAuthTokenSecret urlEncode] : @""];

    NSData *signature = HMAC_SHA1(signatureBaseString, key);
    NSString *base64Sig = [signature base64EncodedString];

    NSMutableDictionary *authHeaderDict = [oAuthParam mutableCopy];
    [authHeaderDict setObject:base64Sig forKey:@"oauth_signature"];

    NSMutableArray *authorizationHeaderItems = [NSMutableArray array];
    for(NSString *key in authHeaderDict) {
        NSString *value = [authHeaderDict objectForKey:key];
        [authorizationHeaderItems addObject:[NSString stringWithFormat:@"%@=\"%@\"",
                                             [key urlEncode],
                                             [value urlEncode]]];
    }

    NSString *authnHeaderString = [authorizationHeaderItems componentsJoinedByString:@", "];
    authnHeaderString = [NSString stringWithFormat:@"OAuth %@", authnHeaderString];
    return authnHeaderString;
}

