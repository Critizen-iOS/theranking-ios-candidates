//
//  FHDDetailWireFrame.m
//  500px Diver
//
//  Created by Jaime on 26/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDDetailWireframe.h"
#import "FHDDetailViewController.h"

@interface FHDDetailWireframe()

@property (nonatomic, strong) FHDDetailViewController *detailViewController;

@end

@implementation FHDDetailWireframe

- (id)init
{
    self = [super init];
    if (self) {
        _detailViewController = [[FHDDetailViewController alloc] initWithNibName:@"FHDDetailViewController"
                                                                            bundle:[NSBundle mainBundle]];
    }
    
    return self;
}

- (void)setDetailPresenter:(FHDDetailPresenter *)detailPresenter
{
    _detailPresenter = detailPresenter;
    _detailViewController.viewDelegate = detailPresenter;
}

- (id<FHDDetailViewInterface>)getViewInterface
{
    return _detailViewController;
}

- (void)showDetailInterfaceInNavigationController:(UINavigationController *)navigationController forItem:(NSNumber *)identifier
{
    [navigationController pushViewController:_detailViewController animated:YES];
    [_detailPresenter configureDetailInterfaceForItem:identifier];
}

@end
