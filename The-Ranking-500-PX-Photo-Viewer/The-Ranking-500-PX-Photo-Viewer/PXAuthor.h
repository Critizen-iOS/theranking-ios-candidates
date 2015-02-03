//
//  PXAuthor.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXAuthor : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *pictureURL;

@end
