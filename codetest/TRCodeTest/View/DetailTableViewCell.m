//
//  DetailTableViewCell.m
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "DetailSectionItem.h"

@interface DetailTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end

@implementation DetailTableViewCell

- (void)drawCellWithItem:(DetailSectionItem *)item {
    _name.text = item.title;
    
    [_image sd_setImageWithURL:item.imageURL placeholderImage:[UIImage new]];
}

@end
