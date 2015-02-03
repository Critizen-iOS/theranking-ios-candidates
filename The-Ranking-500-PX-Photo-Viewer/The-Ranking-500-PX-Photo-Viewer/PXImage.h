//
//  PXImage.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXImage : NSObject

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *httpsURL;
@property (nonatomic, strong) NSString *format;

@end
