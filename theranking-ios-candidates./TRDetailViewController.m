//
//  TRDetailTableViewController.m
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import "TRDetailViewController.h"
#import <MapKit/MapKit.h>
#import "TRDataNetManager.h"
#import "Photo.h"
#import "User.h"

@interface TRDetailViewController ()

@end

@implementation TRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.photo.name;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    //User Info.
    UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(5, 70, 80, 80)];
    if (self.photo.user.userpic_data)
    {
        userPhoto.image = [UIImage imageWithData:self.photo.user.userpic_data];
    }
    else
    {
        dispatch_async(dispatch_queue_create("CatchUserPhoto", nil), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.photo.user.userpic_url]];
            
            if (data)
            {
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   userPhoto.image = [UIImage imageWithData:data];
                                   self.photo.user.userpic_data = data;
                                   [[TRDataNetManager sharedManager].managedObjectContext save:nil];
                                   
                               });
            }
            
        });
    }
    [self.view addSubview:userPhoto];
    CGFloat mapWidth;
    if (self.photo.longitude)
    {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(size.width-85, 70, 80, 80)];
        id location = [[CLLocation alloc] initWithLatitude:[self.photo.latitude doubleValue] longitude:[self.photo.longitude doubleValue]];
        [mapView addAnnotation:location];
        [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([self.photo.latitude doubleValue], [self.photo.longitude doubleValue]), MKCoordinateSpanMake(0.1, 0.1))];
        mapWidth = 90;
        [self.view addSubview:mapView];
        
    }
    else mapWidth = 0;
    
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(90, 70, size.width - 100 -mapWidth, 17)];
    userName.text = self.photo.user.username;
    
    [self.view addSubview:userName];
    
    UILabel *camera = [[UILabel alloc] initWithFrame:CGRectMake(90, 90, size.width - 100-mapWidth, 17)];
    camera.text = self.photo.camera;
    
    [self.view addSubview:camera];
    
    UILabel *shutter = [[UILabel alloc] initWithFrame:CGRectMake(90, 110, size.width - 100-mapWidth, 17)];
    shutter.text = self.photo.shutter_speed;
    
    [self.view addSubview:shutter];
    
    UILabel *focal = [[UILabel alloc] initWithFrame:CGRectMake(90, 130, size.width - 100-mapWidth, 17)];
    focal.text = self.photo.focal_length;
    
    [self.view addSubview:focal];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((size.width-200)/2, 160, 200, 200)];
    image.image = [UIImage imageWithData:self.photo.imageData];
    
    [self.view addSubview:image];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 370, size.width-20, size.height - 380)];
    textView.editable = NO;
    textView.text = self.photo.itsDescription;
    
    [self.view addSubview:textView];

}





@end
