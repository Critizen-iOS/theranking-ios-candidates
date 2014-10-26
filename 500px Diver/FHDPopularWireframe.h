//
//  FHDPopularWireframe.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FHDPopularViewInterface.h"
#import "FHDDetailWireframe.h"

@class FHDPopularPresenter;

// This class represents the Wireframe for the use case "Show popular items"
// Manages the View
@interface FHDPopularWireframe : NSObject

// Used to communicate with the Wireframe for the use case "Show item details"
@property (nonatomic, strong) FHDDetailWireframe *detailWireframe;
// Used to communicate with the Presenter
@property (nonatomic, strong) FHDPopularPresenter *popularPresenter;

/**
 * Gets the FHDPopularViewInterface delegate to communicate with the View of this use case
 * @return current FHDPopularViewInterface delegate
 */
- (id<FHDPopularViewInterface>)getViewInterface;

/**
 * Gets the current view controller used in this use case
 * @param current view controller
 */
- (UIViewController *)getViewController;

/**
 * Calls a the Wireframe from "Show item details" to show an item details
 * @param identifier identifier from the item to show
 */
- (void)showDetailInterfaceWithIdentifier:(NSNumber *)identifier;

@end
