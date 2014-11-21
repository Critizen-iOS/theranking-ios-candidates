//
//  CZPhotoDetailsViewController.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZPhoto.h"
#import "CZRoundedImageView.h"
#import <MapKit/MapKit.h>

@interface CZPhotoDetailsViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) CZPhoto * photoSelected;

// ---------------------------------------------------------
// | Init
// ---------------------------------------------------------
- (id) initWithPhotoID:(NSInteger) photoID;

// ---------------------------------------------------------
// | IBOutlets
// ---------------------------------------------------------
@property (strong, nonatomic) IBOutlet UIScrollView *zoomingContainer;
@property (nonatomic, strong) IBOutlet UIImageView * photoImgView;
@property (nonatomic, strong) IBOutlet UILabel * descriptionLabel;

@property (strong, nonatomic) IBOutlet UIView *infoContainerView;
@property (strong, nonatomic) IBOutlet UIView *bgInfoContainerView;
@property (nonatomic, strong) IBOutlet CZRoundedImageView * avatarUserImgView;
@property (nonatomic, strong) IBOutlet UILabel * usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel * cameraModelLabel;
@property (nonatomic, strong) IBOutlet UILabel * lensLabel;

@property (nonatomic, strong) IBOutlet  MKMapView * mapView;

// ---------------------------------------------------------
// | IBOutlets
// ---------------------------------------------------------
- (IBAction) toggleMoreInfoViewTouchUpInside:(id)sender;

@end
