//
//  PhotoCell.m
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 0.8f;
    self.layer.masksToBounds = NO;
    
    self.scoreOverlay.layer.cornerRadius = self.scoreOverlay.frame.size.height / 2;
    self.scoreOverlay.layer.masksToBounds = YES;
}

- (void)prepareForReuse
{
    self.thumbImage.image = nil;
    self.nameLabel.text = @"";
    self.scoreLabel.text = @"";
}

@end
