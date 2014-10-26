//
//  FHDDetailViewInterface.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This protocol is used by the Presenter to send data to the View
// Must be implemented by the View
@protocol FHDDetailViewInterface <NSObject>

/**
 * Sets item name in View
 * @param name name for the current item
 */
- (void)setName:(NSString *)name;

/**
 * Sets item description in View
 * @param description description for the current item
 */
- (void)setDesc:(NSString *)description;

/**
 * Sets user name in View
 * @param userName name of the user owner for the current item
 */
- (void)setUserName:(NSString *)userName;

/**
 * Sets user avatar image in View
 * @param userAvatarUrl URL image for the avatar of the user owner for the current item
 */
- (void)setUserAvatar:(NSString *)userAvatarUrl;

/**
 * Sets item camera information in View
 * @param camera camera information for the current item
 */
- (void)setCamera:(NSString *)camera;

/**
 * Sets coordinates for the map in View
 * @param latitude latitude for the current item
 * @param longitude longitude for the current item
 */
- (void)setCoordinatesWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude;

@end