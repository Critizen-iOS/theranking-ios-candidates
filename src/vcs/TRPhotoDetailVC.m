#import "TRPhotoDetailVC.h"

#import "ELHASO.h"
#import "TRPhotoData.h"
#import "TRUserData.h"

#import <MapKit/MapKit.h>


@interface TRPhotoDetailVC ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *imageNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *cameraLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mapHeightConstraint;

@end

@implementation TRPhotoDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    LASSERT(self.photoData, @"Huh, loading view without required data?");

    self.title = NSLocalizedString(@"Photo detail", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:NSLocalizedString(@"Close", nil)
        style:UIBarButtonItemStylePlain target:self
        action:@selector(closeDetailVC)];

    self.imageNameLabel.text = self.photoData.photoName;
    self.imageDescriptionLabel.text = self.photoData.photoDesc;
    self.userNameLabel.text = self.photoData.user.combinedName;
    self.userDescriptionLabel.text = self.photoData.user.descriptionText;
    self.cameraLabel.text = @"TODO";

    if (self.photoData.location) {
        self.locationLabel.text = self.photoData.locationText;
        // Calculate a nice map region and add the pin to it.
        MKCoordinateRegion region = { { 0, 0 }, { 1, 1} };
        region.center.latitude = self.photoData.location.coordinate.latitude;
        region.center.longitude = self.photoData.location.coordinate.longitude;
        [self.mapView setRegion:region animated:NO];
        [self.mapView addAnnotations:@[self.photoData]];
    } else {
        // Hide the map if there is no location info.
        self.locationLabel.text =
            NSLocalizedString(@"No location available", nil);
        self.mapView.hidden = YES;
        self.mapHeightConstraint.constant = 0;
    }
}

/// The user got tired, bring them back to the thumbnail view.
- (void)closeDetailVC
{
    [self.navigationController dismissViewControllerAnimated:YES
        completion:nil];
}

@end
