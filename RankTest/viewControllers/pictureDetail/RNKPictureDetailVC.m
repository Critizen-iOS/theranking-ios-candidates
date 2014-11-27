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

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

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

    self.userName.text = self.photo.user.username;
    self.fullName.text = self.photo.user.fullname;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString: self.photo.user.userpic_url]];
}


- (IBAction)closePressed:(id)sender {

    [self.navigationController popViewControllerAnimated: YES];
}

@end
