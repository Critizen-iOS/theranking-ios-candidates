//
//  PXPhotoDetailTableViewController.h
//  The-Ranking-500-PX-Photo-Viewer
//
//  Created by Ernesto Pino on 2/3/15.
//  Copyright (c) 2015 Ernesto Pino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PXPhoto;

@interface PXPhotoDetailTableViewController : UITableViewController

#pragma mark - Properties
@property (nonatomic, strong) PXPhoto *photo;

@end
