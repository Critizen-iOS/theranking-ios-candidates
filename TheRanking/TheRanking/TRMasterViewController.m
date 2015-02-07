//
//  TRMasterViewController.m
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 07/02/15.
//  Copyright (c) 2015 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "TRMasterViewController.h"
#import "TR500PX.h"

@interface TRMasterViewController ()

@end

@implementation TRMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}


-(void)loadData
{
    [[TR500PX sharedInstance] loadDataCompletionBlock:^{

    }];
}

@end
