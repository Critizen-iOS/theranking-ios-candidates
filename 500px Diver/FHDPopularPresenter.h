//
//  FHDPopularPresenter.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDPopularViewDelegate.h"
#import "FHDPopularViewInterface.h"
#import "FHDPopularInteractor.h"
#import "FHDPopularWireframe.h"

// This class represents the Presenter for the use case "Show popular items"
// Gets curated data from Interactor and shows it in the View using the Wireframe
// Implements the FHDPopularViewDelegate protocol to receive events from the View
// Uses the FHDPopularViewInterface protocol to send data to the View
@interface FHDPopularPresenter : NSObject <FHDPopularViewDelegate>

// Interactor, to request curated data
@property (nonatomic, strong) FHDPopularInteractor *popularInteractor;
// Wireframe, to show View
@property (nonatomic, strong) FHDPopularWireframe *popularWireframe;
// Used to send data to View
@property (nonatomic, strong) id<FHDPopularViewInterface> viewInterface;

/**
 * Gets data from Interactor and send it to the View in order to show it
 */
- (void)configureViewInterface;

@end
