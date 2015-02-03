//
//  PXDataModel.m
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import "PXDataModel.h"

@implementation PXDataModel

+ (id)sharedInstance
{
    static PXDataModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
        sharedInstance.currentPhotoPage = [NSNumber numberWithInt:1];
        sharedInstance.photos = [[NSMutableArray alloc] init];
        sharedInstance.pagesLoadedDict = [[NSMutableDictionary alloc] init];
        
    });
    
    return sharedInstance;
}

@end
