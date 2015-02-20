//
//  DetailViewController.h
//  CritizenTestApp
//
//  Created by Patricio on 17/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXFetchManager.h"

@class Photo, User, Camera;

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) NSNumber *photoId;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *infoTable;


@end
