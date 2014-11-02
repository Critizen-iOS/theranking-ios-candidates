//
//  PhotoViewCell.h
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 02/11/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UITableViewCell
@property (nonatomic, strong) NSNumber *imageId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *rating;
@end
