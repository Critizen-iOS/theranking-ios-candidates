//
//  FHDDetailViewController.m
//  500px Diver
//
//  Created by Jaime on 26/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "FHDDetailViewController.h"

#define METERS_PER_MILE 1609.344

@interface FHDDetailViewController ()

@end

@implementation FHDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _descLbl.text = NSLocalizedString(@"No description provided", @"Shown when there is no description");
    _cameraLbl.text = NSLocalizedString(@"Camera unknown", @"Shown when there is no camera information");
    
    _userAvatarView.layer.cornerRadius = _userAvatarView.frame.size.width / 2;
    _userAvatarView.clipsToBounds = YES;
    _userAvatarView.layer.borderWidth = 3.0f;
    _userAvatarView.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FHDDetailViewInterface protocol methods

- (void)setName:(NSString *)name
{
    _nameLbl.text = name;
}

- (void)setDesc:(NSString *)description
{
    if (description) {
        _descLbl.text = description;
    }
}

- (void)setUserName:(NSString *)userName
{
    _userNameLbl.text = userName;
}

- (void)setUserAvatar:(NSString *)userAvatarUrl
{
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:userAvatarUrl]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                              }];
    

}

- (void)setCamera:(NSString *)camera
{
    if (_cameraLbl) {
        _cameraLbl.text = camera;
    }
}

- (void)setCoordinatesWithLatitude:(NSNumber *)latitude andLongitude:(NSNumber *)longitude
{
    if ((latitude) && (longitude)) {
    CLLocationCoordinate2D location;
    location.latitude = [latitude doubleValue];
    location.longitude = [longitude doubleValue];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    }
}

@end
