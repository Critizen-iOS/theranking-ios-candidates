//
//  CZPhotoDetailsViewController.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZ500Connector.h"
#import "CZCoreDataManager.h"
#import "CZPhotoDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kInfoOffset 70.0f

@interface CZPhotoDetailsViewController ()
{
    NSInteger _photoID;
    
    BOOL _expanded;
    BOOL _showingInfo;
    
    CZ500Request * _request;
}

@property (strong, nonatomic) UITapGestureRecognizer * singleTap;
@property (strong, nonatomic) UITapGestureRecognizer * doubleTap;

- (void) _addTapGestures;
- (void) _centerMapInPhotoLocation;
- (void) _fillUIElements;
- (void) _handleTap:(UITapGestureRecognizer *) gesture;
- (void) _handleDoubleTap:(UITapGestureRecognizer *) gesture;
- (void) _hideAllElements;
- (void) _hideMoreInfoView;
- (void) _removeTapGestures;
- (void) _showAllElements;
- (void) _showMoreInfoView;

@end

@implementation CZPhotoDetailsViewController

#pragma mark - Init


- (id) initWithPhotoID:(NSInteger) photoID
{
    self = [super initWithNibName:@"CZPhotoDetails2ViewController" bundle:nil];
    if (self) {
        
        _photoID = photoID;
        
    }
    return self;
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _expanded       = NO;

    
    //
    // Tap to expanded mode
    //
    [self _addTapGestures];

    
    //
    // Request Photo cache or ws
    //
    CZPhoto * photoOnCache = [[CZCoreDataManager sharedSingleton] getPhotoFromDatabaseWithID:_photoID];
    
    if (photoOnCache) {
        
        //NSLog(@"Cache!");
        
        self.photoSelected = photoOnCache;
        
        [self _fillUIElements];
        
    }else{

        //NSLog(@"Request!");
        
        _request = [CZ500Connector requestForPhotoID:_photoID
                                          photoSizes:CZ500PhotoModelSizeExtraLarge
                                          completion:^(CZPhoto * photo, NSError * error){
                                              
                                              if (!error) {
                                                  
                                                  self.photoSelected = photo;
                                                  
                                                  [self _fillUIElements];
                                              }
                                          }];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_request && _request.requestStatus == CZ500RequestStatusStarted) {
        [_request cancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions 

- (IBAction) toggleMoreInfoViewTouchUpInside:(id)sender{

    if (_showingInfo) {
        [self _hideMoreInfoView];
    }else{
        [self _showMoreInfoView];
    }
}

#pragma mark - Private Methods 

- (void) _centerMapInPhotoLocation
{

    CLLocationCoordinate2D coordinate   = CLLocationCoordinate2DMake([self.photoSelected.latitude doubleValue], [self.photoSelected.longitude doubleValue]);
    
    MKCoordinateRegion viewRegion       = MKCoordinateRegionMakeWithDistance(coordinate, 6000, 6000);
    
    [self.mapView setRegion:viewRegion];
    
    
    CLLocation * photoLocation = [[CLLocation alloc] initWithLatitude:[self.photoSelected.latitude doubleValue]
                                                            longitude:[self.photoSelected.longitude doubleValue]];
    
    [self.mapView showAnnotations:@[photoLocation]
                         animated:NO];
     
}

- (void) _fillUIElements
{
    //
    // Name
    //
    [self setTitle:self.photoSelected.name];
    
    //
    // Preview
    //
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:self.photoSelected.url]];
    
    //
    // Description
    //
    if (self.photoSelected.descrip) {
        [self.descriptionLabel setText:self.photoSelected.descrip];
    }else{
        [self.descriptionLabel setText:@"No Description"];
    }
    
    //
    // User
    //
    CZUser * userObj = self.photoSelected.author;
    
    [self.avatarUserImgView sd_setImageWithURL:[NSURL URLWithString:userObj.avatarURL]];
    [self.usernameLabel setText:userObj.name];
    
    //
    // Camera
    //
    CZCamera * cameraObj = self.photoSelected.camera;
    
    if (cameraObj.model) {
        [self.cameraModelLabel setText:cameraObj.model];
    }else{
        [self.cameraModelLabel setText:@"No Info"];
    }
    
    if (cameraObj.lens) {
        [self.lensLabel setText:cameraObj.lens];
    }else{
        [self.lensLabel setText:@"No Info"];
    }
    
    //
    // Map
    //
    if ((self.photoSelected.latitude && self.photoSelected.latitude.floatValue != 0) && (self.photoSelected.longitude && self.photoSelected.longitude.floatValue != 0)) {
        
        [self _centerMapInPhotoLocation];
        
    }else{
        [self.mapView setHidden:YES];
    }
}

- (void) _handleTap:(UITapGestureRecognizer *) gesture{

    if(_expanded){
        
        [self _showAllElements];
        
    }else{
        
        [self _hideAllElements];
    }
}

- (void) _handleDoubleTap:(UITapGestureRecognizer *) gesture{
    
    if (!CGAffineTransformIsIdentity(self.photoImgView.transform)) {
        
        [self.photoImgView setTransform:CGAffineTransformIdentity];
        [self.zoomingContainer setContentSize:self.photoImgView.frame.size];
        
        if(_expanded){
            
            [self _showAllElements];
        }
    }
}

- (void) _hideAllElements{

    _expanded = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:_expanded
                                            withAnimation:(_expanded)?UIStatusBarAnimationNone:UIStatusBarAnimationFade];
    
    
    [self.navigationController setNavigationBarHidden:_expanded
                                             animated:YES];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         
                         CGRect nextFrame = CGRectMake(0.0f, self.view.frame.size.height, self.infoContainerView.frame.size.width, self.infoContainerView.frame.size.height);
                         
                         self.infoContainerView.frame = nextFrame;
                         
                     }completion:^(BOOL finished){
                     
                     }];
}

- (void) _showAllElements{

    _expanded = NO;
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         CGRect nextFrame = CGRectMake(0.0f, self.view.frame.size.height - kInfoOffset, self.infoContainerView.frame.size.width, self.infoContainerView.frame.size.height);
                         
                         self.infoContainerView.frame = nextFrame;
                         
                     }completion:^(BOOL finished){
                         
                     }];
    
    [[UIApplication sharedApplication] setStatusBarHidden:_expanded
                                            withAnimation:(_expanded)?UIStatusBarAnimationNone:UIStatusBarAnimationFade];
    
    [self.navigationController setNavigationBarHidden:_expanded
                                             animated:YES];
}

- (void) _addTapGestures{
    
    if (!self.singleTap) {
        
        self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(_handleTap:)];
        self.singleTap.numberOfTapsRequired = 1;
        
    }
    
    if (!self.doubleTap) {
        
        self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(_handleDoubleTap:)];
        self.doubleTap.numberOfTapsRequired = 2;
    }
    
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.view addGestureRecognizer:self.singleTap];
    [self.view addGestureRecognizer:self.doubleTap];
    
    [self.zoomingContainer setMaximumZoomScale:3.0f];
}

- (void) _removeTapGestures{

    [self.view removeGestureRecognizer:self.singleTap];
    [self.view removeGestureRecognizer:self.doubleTap];
    
    [self.zoomingContainer setMaximumZoomScale:1.0f];
    
}

- (void) _hideMoreInfoView{

    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         
                         [self.bgInfoContainerView setAlpha:0.1f];
                         
                         
                         CGRect nextFrame = CGRectMake(0.0f, self.view.frame.size.height - kInfoOffset, self.infoContainerView.frame.size.width, self.infoContainerView.frame.size.height);
                         
                         self.infoContainerView.frame = nextFrame;
                         
                     }completion:^(BOOL finished){
                         
                         _showingInfo = NO;
                         
                         [self _addTapGestures];
                         
                     }];
}

- (void) _showMoreInfoView{

    [self _removeTapGestures];
    
    CGFloat infoViewHeight = self.infoContainerView.frame.size.height;
    
    [UIView animateWithDuration:0.4f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         
                         [self.bgInfoContainerView setAlpha:0.7f];
                         
                         CGRect nextFrame = CGRectMake(0.0f, self.view.frame.size.height - (infoViewHeight), self.infoContainerView.frame.size.width, self.infoContainerView.frame.size.height);
                         
                         self.infoContainerView.frame = nextFrame;
                         
                     }completion:^(BOOL finished){
                         
                         _showingInfo = YES;
                         
                     }];
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.photoImgView;
}

@end
