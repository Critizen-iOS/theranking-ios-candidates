//
//  TRCatchPhotosOperation.h
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface TRCatchPhotosOperation : NSOperation

@property (nonatomic, strong) NSManagedObjectContext *fatherMOC;

@end
