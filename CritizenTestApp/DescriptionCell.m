//
//  DescriptionCell.m
//  CritizenTestApp
//
//  Created by Patricio on 19/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "DescriptionCell.h"

@implementation DescriptionCell

- (void)awakeFromNib {
    // Initialization code
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.textLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
