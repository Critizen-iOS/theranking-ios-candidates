//
//  DetailViewController.h
//  500pxSesioPhotos1
//
//  Created by Sergio Becerril on 12/11/14.
//  Copyright (c) 2014 Sergio Becerril. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (strong,nonatomic) IBOutlet UIImageView *detailImage;

@property (strong,nonatomic) IBOutlet UILabel *photoName;

@property (strong,nonatomic) IBOutlet UITextView *photoDescription;

@property (strong,nonatomic) IBOutlet UIImageView *userPicture;

@property (strong,nonatomic) IBOutlet UILabel *infoCamera;

@property (strong,nonatomic) IBOutlet UILabel *infoCountry;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) id detailItem;

@end
