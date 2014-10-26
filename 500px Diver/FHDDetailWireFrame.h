//
//  FHDDetailWireFrame.h
//  500px Diver
//
//  Created by Jaime on 26/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FHDDetailViewInterface.h"
#import "FHDDetailPresenter.h"

// This class represents the Wireframe for the use case "Show item details"
// Manages the View
@interface FHDDetailWireframe : NSObject

// Used to communicate with the Presenter
@property (nonatomic, strong) FHDDetailPresenter *detailPresenter;

/**
 * Returns the FHDDetailViewInterface delegate to communicate with the View of this use case
 * @return current FHDDetailViewInterface delegate
 */
- (id<FHDDetailViewInterface>)getViewInterface;

/**
 * Shows the View used in this use case through the given navigation controller
 * @param navigationController navigation controller where push the View
 * @param identifier identifier identifier for the item to show in View
 */
- (void)showDetailInterfaceInNavigationController:(UINavigationController *)navigationController
                                          forItem:(NSNumber *)identifier;

@end
