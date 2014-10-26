//
//  TRDetailViewController.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

/**
 Class to display photo properties (detailed view)
 */
@interface TRDetailViewController : UIViewController

/**
 Photo object to display properties
 */
@property (nonatomic, weak) Photo *photo;

@end
