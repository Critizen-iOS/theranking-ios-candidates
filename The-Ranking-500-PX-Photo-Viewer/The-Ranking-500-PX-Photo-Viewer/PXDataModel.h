//
//  PXDataModel.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXDataModel : NSObject

@property (nonatomic, strong) NSNumber *currentPhotoPage;
@property (nonatomic, strong) NSNumber *totalPages;
@property (nonatomic, strong) NSNumber *totalItems;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableDictionary *pagesLoadedDict;

+ (id)sharedInstance;

@end
