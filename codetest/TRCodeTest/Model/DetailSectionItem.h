//
//  DetailSectionItem.h
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailSectionItem : NSObject

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *subtitle;
@property (strong, nonatomic, readonly) NSURL *imageURL;

@property (assign, nonatomic, getter=isUser) BOOL user;

/**
 *  Init object with details
 *
 *  @param title    item title
 *  @param subtitle item subtitle
 *
 *  @return DetailSectionItem instance
 */
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

/**
 *  Init object with basic details + user image url
 *
 *  @param title    item title
 *  @param subtitle item subtitle
 *  @param imageURL user image url
 *
 *  @return DetailSectionItem instance
 */
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(NSURL *)imageURL;

@end
