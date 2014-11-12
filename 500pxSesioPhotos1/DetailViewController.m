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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    

}

#pragma mark CREACIÓN Y ACTUALIZACIÓN DE LA VISTA

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        //Actualizamos la Vista
        [self configureView];
    }
}

- (void)configureView
{
    //Actualizamos la vista
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
    
    if([NSNull null] != [[self.detailItem valueForKey:@"user"] objectForKey:@"firstname"]) {
        NSString *countryCapture = [[self.detailItem valueForKey:@"user"] objectForKey:@"firstname"];
        self.nameUser.text = countryCapture;
    }
    }

#pragma mark CREACIÓN DEL MAPA

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
        
        location.latitude = 0;
    

    }
    
    if([NSNull null] != [self.detailItem valueForKeyPath:@"longitude"]) {
        NSString *longitudeUser = [NSString stringWithFormat:@"%@",[self.detailItem valueForKeyPath:@"longitude"]];
        location.longitude = [longitudeUser floatValue];
    }else{
        
        location.longitude = 0;
    }
    
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

@end
