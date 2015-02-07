//
//  TR500PX.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConsumerKey       @"zL9BobNimITtAIopwW9EnJxvW6wq8z5XnmPyrZRG"
#define kConsumerSecret    @"revgBekKazqEyc1iuG2PRHiUPYhjrHf6rYg802xS"

/**
 Helper class to connet and get data from 500PX
 */
@interface TR500PX : NSObject


/**
 Get the shared instance of the TR500PX class
 @returns the instance of TR500PX
 */
+ (TR500PX*)sharedInstance;

/**
 Rquest token and get data from 500px
 */
- (void) loadDataCompletionBlock:(void (^)(void))completionBlock;
@end
