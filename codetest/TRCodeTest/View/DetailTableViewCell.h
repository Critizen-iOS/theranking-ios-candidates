//
//  DetailTableViewCell.h
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class DetailSectionItem;

@interface DetailTableViewCell : UITableViewCell

- (void)drawCellWithItem:(DetailSectionItem *)item;

@end
