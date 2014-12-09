//
//  RNKConstants.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#ifndef RankTest_RNKConstants_h
#define RankTest_RNKConstants_h


#define RNK_DEBUG //if defined all logs activated


//*********************************
    #pragma mark LOGS
//*********************************

// DLog console log for debug
#ifdef RNK_DEBUG
#define DLog(fmt, ...) NSLog((@"%s[%d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

// ELog console log for errors
#define ELog(fmt, ...) NSLog((@"%s[%d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ALog (alert view)
#ifdef RNK_DEBUG
#define ALog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [%d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#define ALog(...)
#endif


//*********************************
#pragma mark KEYS
//*********************************

#define APIENGINE_BASEURL @"https://api.500px.com/v1/"
#define API_CONSUMER_KEY @"AVN1T2dh0PbZffBoLsQHlqToFUUUfptMhVM5whV8" //TODO: Not a good idea to have a key here, better in local keychain


#endif
