//
//  DetailVC.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 26/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "DetailVC.h"
#import <MapKit/MapKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailVC () {
    CGFloat _italicFontSize;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *cameraInfoTextView;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (weak, nonatomic) MKPointAnnotation *annotation;


@end

static CGFloat const kAuthorPreffixFontPointsReduction = 6.f;
static double const kMapLocationMetersAround = 5000;

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Photo Details", @"Photo Detailed Information view title");
    
    _italicFontSize = self.authorLabel.font.pointSize-kAuthorPreffixFontPointsReduction;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateInformation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.scrollView scrollRectToVisible:CGRectMake(0.f, 0.f, 10.f, 10.f) animated:NO];
}

- (void) updateInformation {
    self.titleLabel.text = self.selectedPicture.pictureTitle;
    self.descriptionTextView.text = self.selectedPicture.pictureDescription;
    
    
    NSString *authorPreffix = NSLocalizedString(@"by:", @"Author preffix in photo details.");
    NSString *authorText = [NSString stringWithFormat:@"%@ %@", authorPreffix, self.selectedPicture.userFullname];
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: self.authorLabel.textColor,
                              NSFontAttributeName: self.authorLabel.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:authorText
                                           attributes:attribs];
    
    UIFont *italicFont = [UIFont italicSystemFontOfSize:_italicFontSize];
    
    NSRange preffixRange;
    preffixRange.location = 0;
    preffixRange.length = [authorPreffix length];
    [attributedText setAttributes:@{NSFontAttributeName:italicFont}
                            range:preffixRange];
    
    self.authorLabel.attributedText = attributedText;
    [self.avatarImageView sd_cancelCurrentImageLoad];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.selectedPicture.userAvatarURL] placeholderImage:[UIImage imageNamed:@"avatar"]];

    self.cameraInfoTextView.text = self.selectedPicture.cameraDescription;
    
    if(self.selectedPicture.pictureLong != nil && self.selectedPicture.pictureLat != nil) {
        self.map.hidden = NO;
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.selectedPicture.pictureLat doubleValue], [self.selectedPicture.pictureLong doubleValue]);
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, kMapLocationMetersAround, kMapLocationMetersAround);
        MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
        [self.map setRegion:adjustedRegion animated:YES];
        
        // Add marker
        [self.map removeAnnotation: self.annotation];
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = location;
        [self.map addAnnotation:annotation];
        self.annotation = annotation;
        
    } else {
        self.map.hidden = YES;
    }
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
