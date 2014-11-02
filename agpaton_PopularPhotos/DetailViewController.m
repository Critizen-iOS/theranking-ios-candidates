//
//  DetailViewController.m
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 02/11/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import "DetailViewController.h"

#import "Photo.h"
#import "Camera.h"
#import "User.h"

#import "ImageTools.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocation.h>

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel *cameraNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraISOLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraLensLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraFocusLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraShutterLabel;
@property (nonatomic, weak) IBOutlet UILabel *cameraApertureLabel;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameLabel.text = self.photo.photo_name;
    self.descriptionLabel.text = self.photo.photo_description;
    
    __weak UIImageView *safeUserImageView = self.userImageView;
    self.userImageView.backgroundColor = [UIColor lightGrayColor];
    
    [ImageTools GetPhotoFromURL:self.photo.photo_user_info.user_image andId:self.photo.photo_user_info.user_id completion:^(UIImage *image) {
        safeUserImageView.image = image;
    }];
    
    self.usernameLabel.text = self.photo.photo_user_info.user_name;
    
    self.cameraNameLabel.text = self.photo.photo_camera_info.camera_name;
    self.cameraApertureLabel.text = self.photo.photo_camera_info.camera_aperture;
    self.cameraFocusLabel.text = self.photo.photo_camera_info.camera_focal_length;
    self.cameraLensLabel.text = self.photo.photo_camera_info.camera_lens;
    self.cameraISOLabel.text = self.photo.photo_camera_info.camera_iso;
    self.cameraShutterLabel.text = self.photo.photo_camera_info.camera_shutter_speed;
    
    [self setupMap];
    
    [self adjutConstraints];
  
}

- (void)adjutConstraints
{
    if (self.descriptionLabel.text.length==0) {
        [self changeHeigthConstrain:0 inLabel:self.descriptionLabel];
        [self changeTopConstrain:0 inView:self.userImageView];
    } else {
        [self changeHeigthConstrain:[self getSizeOfLabel:self.descriptionLabel withMaxWidth:self.descriptionLabel.frame.size.width].height inLabel:self.descriptionLabel];
    }
    
    if (self.cameraNameLabel.text.length == 0) {
        [self changeHeigthConstrain:0 inLabel:self.cameraNameLabel];
        [self changeTopConstrain:0 inView:self.mapView];
    }
    
    if (self.cameraApertureLabel.text.length == 0) {
        [self changeHeigthConstrain:0 inLabel:self.cameraApertureLabel];
        [self changeTopConstrain:0 inView:self.cameraLensLabel];
    }
    
    if (self.cameraLensLabel.text.length == 0) {
        [self changeHeigthConstrain:0 inLabel:self.cameraLensLabel];
        [self changeTopConstrain:0 inView:self.cameraFocusLabel];
    }
    
    if (self.cameraFocusLabel.text.length == 0) {
        [self changeHeigthConstrain:0 inLabel:self.cameraFocusLabel];
        [self changeTopConstrain:0 inView:self.cameraShutterLabel];
    }
    
    if (self.cameraISOLabel.text.length == 0) {
        [self changeHeigthConstrain:0 inLabel:self.cameraISOLabel];
    }
    
    if (self.cameraShutterLabel.text.length == 0) {
        [self changeHeigthConstrain:0 inLabel:self.cameraShutterLabel];
        [self changeTopConstrain:0 inView:self.cameraISOLabel];
    }
}

- (CGSize)getSizeOfLabel :(UILabel *)label withMaxWidth:(CGFloat)width {
    CGSize maximumSize = CGSizeMake(width, 9999);
    
    if (!label) {
        return CGSizeMake(0, 0);
    }
    
    CGRect labelRect = [label.text boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
    
    //No more than three lines
    CGSize labelSize = CGSizeMake(labelRect.size.width, MIN(70, labelRect.size.height));
   
    return labelSize;
}

- (void)setupMap
{
    if ([self.photo.photo_longitude doubleValue] == 0 && [self.photo.photo_longitude doubleValue] == 0) {
        
        self.mapView.hidden = YES;
        return;
    }
    
    self.mapView.hidden = NO;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.photo.photo_latitude doubleValue], [self.photo.photo_longitude doubleValue]);
    [annotation setCoordinate:location];
    [annotation setTitle:@"Photo"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region = self.mapView.region;
    region.center = location;
    region.span.longitudeDelta = 0.05;
    region.span.latitudeDelta = 0.05;
    [self.mapView setRegion:region animated:YES];
}

- (void)changeHeigthConstrain:(CGFloat)newHeight inLabel:(UILabel *)label
{
    [label.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        
        if ((constraint.firstItem == label) && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = newHeight;
        }
    }];
}


- (void)changeTopConstrain:(CGFloat)newTop inView:(UIView *)view
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        
        if ((constraint.firstItem == view) && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = newTop;
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    self.userImageView.clipsToBounds = YES;
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
