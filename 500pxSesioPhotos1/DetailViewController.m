//
//  DetailViewController.m
//  500pxSesioPhotos1
//
//  Created by Sergio Becerril on 12/11/14.
//  Copyright (c) 2014 Sergio Becerril. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize detailImage;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    self.detailImage.image = nil;
    self.detailImage.clipsToBounds = YES;
    
    self.navigationItem.title = [self.detailItem valueForKeyPath:@"name"];
    
    if (self.detailItem) {
        
        if([NSNull null] != [[[self.detailItem valueForKey:@"images"] lastObject] valueForKey:@"url"]) {
        NSString *itemURLString = [[[self.detailItem valueForKey:@"images"] lastObject] valueForKey:@"url"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemURLString]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailImage.image = image;
                
            });
        });
        }
        }
    
    if([NSNull null] != [self.detailItem valueForKeyPath:@"name"]) {
        NSString *namePhoto = [self.detailItem valueForKeyPath:@"name"];
        self.photoName.text = namePhoto;
    }
    
     if([NSNull null] != [self.detailItem valueForKeyPath:@"description"]) {
        NSString *descriptionPhoto = [self.detailItem valueForKeyPath:@"description"];
        self.photoDescription.text = descriptionPhoto;
     }
    
        if([NSNull null] != [[self.detailItem valueForKey:@"user"] objectForKey:@"userpic_url"]) {
            
            NSString *itemURLStringUser = [[self.detailItem valueForKey:@"user"] objectForKey:@"userpic_url"];
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *imageUser = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemURLStringUser]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userPicture.image = imageUser;
                    self.userPicture.layer.cornerRadius = self.userPicture.frame.size.width / 2;
                    self.userPicture.clipsToBounds = YES;
                    
                });
            });
        }
    
    if([NSNull null] != [self.detailItem valueForKeyPath:@"camera"]) {
        NSString *descriptionCamera = [self.detailItem valueForKeyPath:@"camera"];
        self.infoCamera.text = descriptionCamera;
    }
    
    if([NSNull null] != [[self.detailItem valueForKey:@"user"] objectForKey:@"country"]) {
        NSString *countryCapture = [[self.detailItem valueForKey:@"user"] objectForKey:@"country"];
        self.infoCountry.text = countryCapture;
    }
    
    
    }


-(void)viewDidAppear:(BOOL)animated{
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D location;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    
    if([NSNull null] != [self.detailItem valueForKeyPath:@"latitude"]) {
        
        NSString *latitudUser = [NSString stringWithFormat:@"%@",[self.detailItem valueForKeyPath:@"latitude"]];
        
        location.latitude = [latitudUser floatValue];
    }else{
        
        location.latitude = 40.476724;
    

    }
    
    if([NSNull null] != [self.detailItem valueForKeyPath:@"longitude"]) {
        NSString *longitudeUser = [NSString stringWithFormat:@"%@",[self.detailItem valueForKeyPath:@"longitude"]];
        location.longitude = [longitudeUser floatValue];
    }else{
        
        location.longitude = -3.685765;
    }
    
    //location.latitude = 40.436659;
    //location.longitude = -3.668805;
    
    region.span = span;
    
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
    
    [self.mapView regionThatFits:region];
    
    CLLocationCoordinate2D pin = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    
    //Pone una anotación en el mapa
    MKPointAnnotation *marca = [[MKPointAnnotation alloc]init];
    
    [marca setCoordinate:pin];
    
        
    [marca setTitle:@"¡Patata!"];

    [marca setSubtitle:@"Una foto genial"];
    
    [self.mapView addAnnotation:marca];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
