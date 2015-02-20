//
//  LoadingCell.m
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "LoadingCell.h"

@implementation LoadingCell

@synthesize activityIndicator;

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 0.8f;
    self.layer.masksToBounds = NO;
}

@end
