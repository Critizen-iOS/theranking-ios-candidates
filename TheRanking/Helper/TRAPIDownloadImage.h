//
//  TRAPIDownloadImage.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Helper class to download images
 */
@interface TRAPIDownloadImage : NSObject

/**
 Get the shared instance of the TRAPIDownloadImage class
 @returns the instance of TRAPIDownloadImage
 */
+ (TRAPIDownloadImage*)sharedInstance;

@end
