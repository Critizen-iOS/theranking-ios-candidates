//
//  DetailViewController.h
//  agpaton_PopularPhotos
//
//  Created by Alejandro González Patón on 02/11/14.
//  Copyright (c) 2014 Alejandro González Patón. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface DetailViewController : UIViewController

@property (nonatomic, weak) Photo *photo;
@end
