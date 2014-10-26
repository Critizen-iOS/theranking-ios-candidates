//
//  FHDDataConnectionAvailability.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>

#import "FHDDataConnectionAvailability.h"

@implementation FHDDataConnectionAvailability

+ (BOOL)isDataSourceAvailable
{
    const char *host_name = "twitter.com"; // your data source host name
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    BOOL isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);

    return isDataSourceAvailable;
}

@end
