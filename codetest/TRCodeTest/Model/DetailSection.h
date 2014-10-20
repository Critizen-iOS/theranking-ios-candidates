//
//  DetailSection.h
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailSection : NSObject

@property (assign, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSArray *items;

/**
 *  Init object with name
 *
 *  @param name section name
 *
 *  @param items section items
 *
 *  @return DetailSection object
 */
- (instancetype)initWithName:(NSString *)name items:(NSArray *)items;

@end
