//
//  OAuth+Additions.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "OAuth+Additions.h"

@implementation NSString (OAuthAdditions)

- (NSDictionary *)oa_parseURL
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSArray *pairs = [self componentsSeparatedByString:@"&"];
	for(NSString *pair in pairs) {
		NSArray *keyValue = [pair componentsSeparatedByString:@"="];
		if([keyValue count] == 2) {
			NSString *key = [keyValue objectAtIndex:0];
			NSString *value = [keyValue objectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if(key && value)
                [dict setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}


+ (NSString *)nonce
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *uuidtmp=[[NSString alloc]initWithString:(__bridge NSString*) uuidStr];
    CFRelease(uuidStr);
    return (uuidtmp);
}

@end

