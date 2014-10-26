//
//  FHDPopularViewControllerCollectionViewController.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FHDPopularViewInterface.h"
#import "FHDPopularViewDelegate.h"

// This class represents the View Controller for the use case "Show popular items"
// Shows items in a Collection View
// Uses the FHDPopularViewDelegate protocol to comunicate events to the Presenter
// Implements the FHDPopularViewInterface protocol to receive data from Presenter
@interface FHDPopularViewController : UICollectionViewController <FHDPopularViewInterface>

// Delegate to send interface events to Presenter
@property (nonatomic, strong) id<FHDPopularViewDelegate> viewDelegate;

@end
