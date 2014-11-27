//
//  DetailView.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "DetailView.h"

#import <MapKit/MapKit.h>
#import "UIImageView+AsyncLoad.h"

#pragma mark - = DetailView () = -

@interface DetailView () {
    //! Origin center of animation.
    CGPoint sourceCenter;
    //! Origin scale for animation.
    CGPoint sourceScale;
    
    UIImageView *photoImageView;
}

#pragma mark - Outlets -

@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@property (nonatomic, weak) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic, strong) IBOutlet UIView *alphaView;

//! View containing photo info.
@property (nonatomic, weak) IBOutlet UIView *infoView;
@property (nonatomic, weak) IBOutlet UIButton *toggleInfoButton;

// photo
@property (nonatomic, weak) IBOutlet UILabel *photoNameLabel;
@property (nonatomic, weak) IBOutlet UITextView *photoDescriptionText;

// user
@property (nonatomic, weak) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;

// camera
@property (nonatomic, weak) IBOutlet UILabel *cameraLabel;
@property (nonatomic, weak) IBOutlet UILabel *lensLabel;
@property (nonatomic, weak) IBOutlet UILabel *focalLengthLabel;
@property (nonatomic, weak) IBOutlet UILabel *shutterSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *apertureLabel;
@property (nonatomic, weak) IBOutlet UILabel *isoLabel;

// location
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet MKMapView *locationMapView;


#pragma mark - Scroll -

- (void)setupScroll;
- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)view;


#pragma mark - Info view -

- (BOOL)isInfoVisible;
- (void)setInfoVisible:(BOOL)visible animate:(BOOL)animate;

#pragma mark - Actions -

- (IBAction)closeClick:(id)sender;
- (IBAction)toggleInfoClick:(id)sender;


@end



#pragma mark - = DetailView = -

@implementation DetailView


#pragma mark - Creation

+ (DetailView *)detailView
{
    return [[[UINib nibWithNibName:@"DetailView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
}


- (void)awakeFromNib
{
    _closeButton.layer.cornerRadius = _closeButton.frame.size.width / 2.0f;

    // user image style
    _userImageView.layer.borderWidth = 2;
    _userImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0f;
    
    [self addSubview:_infoView];
    [self bringSubviewToFront:_closeButton];
    
    photoImageView = [[UIImageView alloc] initWithFrame:_photoScrollView.bounds];
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_photoScrollView addSubview:photoImageView];
}

#pragma mark - Data -

- (void)setPhoto:(PXPhoto *)pxPhoto preview:(UIImage *)preview
{
    _photoScrollView.zoomScale = 1.0f;
    _photoScrollView.contentOffset = CGPointZero;
    _photoScrollView.contentSize = _photoScrollView.frame.size;
    photoImageView.frame = _photoScrollView.bounds;

    // photo info
    PXImage *pxImage = pxPhoto.images[1];
    __weak typeof(self) _self = self;
    [photoImageView setAsyncImageFromURL:pxImage.url forTag:pxPhoto.photoId loadingImage:preview completion:^(BOOL success) {
        [_self setupScroll];
    }];

    _photoNameLabel.text = pxPhoto.name;
    if( pxPhoto.photoDescription ) {
        NSData *data = [pxPhoto.photoDescription dataUsingEncoding:NSUnicodeStringEncoding];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:data
            options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
            documentAttributes:nil
            error:nil
        ];

        _photoDescriptionText.attributedText = attributedString;
    } else {
        _photoDescriptionText.text = nil;
    }

    // user info
    PXUser *pxUser = pxPhoto.user;
    [_userImageView setAsyncImageFromURL:pxUser.userPicUrl forTag:pxUser.userId];
    _userNameLabel.text = pxUser.fullName;
    
    // camera info
    _cameraLabel.text = pxPhoto.camera;
    _lensLabel.text = pxPhoto.lens;
    _focalLengthLabel.text = pxPhoto.focalLength;
    _shutterSpeedLabel.text = pxPhoto.shutterSpeed;
    _apertureLabel.text = pxPhoto.aperture;
    _isoLabel.text = pxPhoto.iso;
    
    // location info
    _locationLabel.text = pxPhoto.location;
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake( pxPhoto.latitude, pxPhoto.longitude );
    if( CLLocationCoordinate2DIsValid( coord ) ) {
        _locationMapView.alpha = 1;
        //_locationMapView.centerCoordinate = coord;
        
        MKCoordinateSpan span = MKCoordinateSpanMake( 0.030, 0.030 );
        MKCoordinateRegion region = MKCoordinateRegionMake( coord, span );
        [_locationMapView setRegion:region];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = coord;
    
        [_locationMapView removeAnnotations:_locationMapView.annotations];
        [_locationMapView addAnnotation:point];
    } else {
        _locationMapView.alpha = 0;
    }
}

#pragma mark - Show/hide -

- (void)openInView:(UIView *)parentView fromView:(UIView *)sourceView
{
    _infoView.frame = self.bounds;
    
    [self setInfoVisible:NO animate:NO];

    sourceCenter = [parentView convertPoint:sourceView.center fromView:sourceView.superview];
    CGRect r0 = sourceView.frame;
    CGRect r1 = self.frame;
    sourceScale = CGPointMake( r0.size.width/r1.size.width, r0.size.height/r1.size.height );

    //self.alpha = 0;
    self.center = sourceCenter;
    self.transform = CGAffineTransformMakeScale( sourceScale.x, sourceScale.y );

    [parentView addSubview:self];
    
    [UIView animateWithDuration:0.3f
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            //self.alpha = 1;
            self.center = CGPointMake( parentView.frame.size.width/2, parentView.frame.size.height/2 );
            self.transform = CGAffineTransformIdentity;
        }
        completion:nil
    ];
}

- (void)close
{
    [UIView animateWithDuration:0.3f
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            //self.alpha = 0;
            self.center = sourceCenter;
            self.transform = CGAffineTransformMakeScale( sourceScale.x, sourceScale.y );
        }
        completion:^(BOOL finished) {
            if( finished ) {
                [self removeFromSuperview];

                //self.alpha = 1;
                self.transform = CGAffineTransformIdentity;
            }
        }
    ];
}

#pragma mark - Scroll -

- (void)setupScroll
{
    UIScrollView *scrollView = _photoScrollView;
    UIImage *img = photoImageView.image;
    UIImageView *imageView = photoImageView;
    
    scrollView.zoomScale = 1.0f;
    scrollView.contentOffset = CGPointZero;
    scrollView.contentSize = scrollView.frame.size;
    
    CGSize imageSize = img.size;

    imageView.frame = CGRectMake( 0, 0, imageSize.width, imageSize.height );

    // calcular la escala inicial de la imagen
    CGSize viewSize = scrollView.frame.size;
    CGFloat scx = viewSize.width / imageSize.width;
    CGFloat scy = viewSize.height / imageSize.height;
    CGFloat scale = MIN( scx, scy );

    scrollView.contentSize = imageView.frame.size;
    scrollView.minimumZoomScale = scale;
    scrollView.maximumZoomScale = 1.0;
    scrollView.zoomScale = MAX( scx, scy );
    
    CGRect r = photoImageView.frame;
    float originX = -(scrollView.frame.size.width - r.size.width) / 2;
    float originY = -(scrollView.frame.size.height - r.size.height) / 2;
    scrollView.contentOffset = CGPointMake( originX, originY );
    //photoImageView.frame = r;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)view
{
    CGSize viewSize = scroll.bounds.size;
    CGRect r = view.frame;

    // horizontal
    if (r.size.width < viewSize.width) {
        r.origin.x = (viewSize.width - r.size.width) / 2;
    } else {
        r.origin.x = 0;
    }

    // vertical
    if (r.size.height < viewSize.height) {
        r.origin.y = (viewSize.height - r.size.height) / 2;
    } else {
        r.origin.y = 0;
    }

    return r;
}


#pragma mark - Info view -

- (BOOL)isInfoVisible
{
    return _infoView.frame.origin.y == 0;
}

- (void)setInfoVisible:(BOOL)visible animate:(BOOL)animate
{
    if( visible == [self isInfoVisible] ) return;

    CGRect r = _infoView.frame;
    float imageAlpha = 0.0f;

    if( visible ) {
        r.origin.y = 0;
        imageAlpha = 0.6f;
    } else {
        r.origin.y = self.frame.size.height - 28;
        imageAlpha = 0.0f;
    }
    
    void (^anim)() = ^{
        _alphaView.alpha = imageAlpha;
        _infoView.frame = r;
    };
    
    if( animate ) {
        [UIView animateWithDuration:0.2f
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:anim
            completion:nil
        ];
    } else {
        anim();
    }
}


#pragma mark - Actions -

- (IBAction)closeClick:(id)sender
{
    [self close];
}

- (IBAction)toggleInfoClick:(id)sender
{
    [self setInfoVisible:![self isInfoVisible] animate:YES];
}


#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    photoImageView.frame = [self centeredFrameForScrollView:scrollView andUIView:photoImageView];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return photoImageView;
}


@end
