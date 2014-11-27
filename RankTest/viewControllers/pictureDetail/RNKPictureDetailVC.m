//
//  RNKPictureDetailVC.m
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPictureDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"

@interface RNKPictureDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *pictureDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;

@property (weak, nonatomic) IBOutlet UILabel *camera;
@property (weak, nonatomic) IBOutlet UILabel *aperture;
@property (weak, nonatomic) IBOutlet UILabel *focalLenght;
@property (weak, nonatomic) IBOutlet UILabel *shutterSpeed;



@end

@implementation RNKPictureDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 2;
    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];

    [self loadFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) loadFields {
    self.name.text = self.photo.name;
    self.pictureDescription.text = self.photo.photoDescription;
    [self.image sd_setImageWithURL:[NSURL URLWithString: self.photo.image_url]];

    self.rating.text = [self.photo.rating stringValue];

    self.userName.text = self.photo.user.username;
    self.fullName.text = self.photo.user.fullname;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString: self.photo.user.userpic_url]];

    if ((![self.photo.latitude isEqual: @0])  || (![self.photo.longitude isEqual: @0])) {

        self.mapLabel.hidden = true;
        CLLocation *location = [[CLLocation alloc] initWithLatitude: [self.photo.latitude doubleValue]
                                                          longitude: [self.photo.longitude doubleValue]];
        [self.mapView addAnnotation: (id<MKAnnotation>)location];
        [self.mapView setRegion: MKCoordinateRegionMake( CLLocationCoordinate2DMake([self.photo.latitude doubleValue],
                                                                                    [self.photo.longitude doubleValue]),
                                                        MKCoordinateSpanMake(0.1, 0.1))];

    } else {
        self.mapLabel.hidden = false;
        self.mapView.zoomEnabled = NO;
        self.mapView.scrollEnabled = NO;
        self.mapView.userInteractionEnabled = NO;
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.frame = self.mapView.bounds;
        shadowLayer.backgroundColor = [[UIColor blackColor] CGColor];
        shadowLayer.opacity = .4;
        [self.mapView.layer addSublayer: shadowLayer];
    }

    if (self.photo.camera) {
        self.camera.text = self.photo.camera;
    } else {
        self.camera.text = @"--";
    }


    if (self.photo.aperture) {
        self.aperture.text = self.photo.aperture;
    } else {
        self.aperture.text = @"--";
    }

    if (self.photo.focal_length) {
        self.focalLenght.text = self.photo.focal_length;
    } else {
        self.focalLenght.text = @"--";
    }

    if (self.photo.shutter_speed) {
        self.shutterSpeed.text = self.photo.shutter_speed;
    } else {
        self.shutterSpeed.text = @"--";
    }


}


- (IBAction)closePressed:(id)sender {

    [self.navigationController popViewControllerAnimated: YES];
}

@end
