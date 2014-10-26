//
//  FHDDetailViewController.h
//  500px Diver
//
//  Created by Jaime on 26/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "FHDDetailViewInterface.h"
#import "FHDDetailViewDelegate.h"

// This class represents the View Controller for the use case "Show item details"
// Shows the item details
// Uses the FHDDetailViewDelegate protocol to comunicate events to the Presenter
// Implements the FHDDetailViewInterface protocol to receive data from Presenter
@interface FHDDetailViewController : UIViewController <FHDDetailViewInterface>

// Name for the item
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
// Description for the item
@property (nonatomic, weak) IBOutlet UILabel *descLbl;
// Avatar for the user owner of this item
@property (nonatomic, weak) IBOutlet UIImageView *userAvatarView;
// Name for the user owner of this item
@property (nonatomic, weak) IBOutlet UILabel *userNameLbl;
// Information about the camera used in this item
@property (nonatomic, weak) IBOutlet UILabel *cameraLbl;
// Map view with the location where this item was created
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

// Delegate to send interface events to Presenter
@property (nonatomic, strong) id<FHDDetailViewDelegate> viewDelegate;

@end
