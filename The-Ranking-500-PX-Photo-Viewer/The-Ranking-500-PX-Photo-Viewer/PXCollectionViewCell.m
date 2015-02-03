//
//  PXCollectionViewCell.m
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/2/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import "PXCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PXCollectionViewCell

- (void)awakeFromNib
{
    self.ratingLabel.hidden = YES;
    self.nameLabel.hidden = YES;
    self.photoImageView.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)setPhoto:(PXPhoto *)photo
{
    // Check if the photo for this cell is not empty
    _photo = photo;
    
    __weak UIImageView *weakPhotoImageView = self.photoImageView;
    __weak UIActivityIndicatorView *weakActivityIndicator = self.activityIndicator;
    __weak UILabel *weakRatingLabel = self.ratingLabel;
    __weak UILabel *weakNameLabel = self.nameLabel;
    
    
    [self.photoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.photo.imageURL]]
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            
                                            // Configure cell
                                            
                                            weakNameLabel.hidden = NO;
                                            weakRatingLabel.hidden = NO;
                                            weakPhotoImageView.hidden = NO;
                                            weakActivityIndicator.hidden = YES;
                                            [weakActivityIndicator stopAnimating];
                                            
                                            
                                            // Set data to cell
                                            weakNameLabel.text = self.photo.name;
                                            weakRatingLabel.text = [NSString stringWithFormat:@"%.1f", [self.photo.rating doubleValue]];
                                            weakPhotoImageView.image = image;
                                            
                                            // Animation effect
                                            
                                            [weakPhotoImageView setAlpha:0.0];
                                            [UIView beginAnimations:nil context:NULL];
                                            [UIView setAnimationDuration:0.3];
                                            [weakPhotoImageView setAlpha:1.0];
                                            [UIView commitAnimations];
                                            
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            
                                            NSLog(@"Error trying to load image asynchronously...");
                                            
                                        }];
}

@end
