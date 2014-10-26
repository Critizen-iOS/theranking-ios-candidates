//
//  FHDDetailPresenter.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDDetailPresenter.h"
#import "FHDDetailItem.h"

@implementation FHDDetailPresenter

- (void)configureDetailInterfaceForItem:(NSNumber *)identifier
{
   [_detailInteractor getDetailForItem:identifier
                       completionBlock:^(FHDDetailItem *item) {
                           [_viewInterface setName:item.name];
                           [_viewInterface setDesc:item.desc];
                           [_viewInterface setUserAvatar:item.userAvatarUrl];
                           [_viewInterface setUserName:item.userName];
                           [_viewInterface setCamera:item.camera];
                           [_viewInterface setCoordinatesWithLatitude:item.latitude andLongitude:item.longitude];
                       }];
}

#pragma mark - FHDDetailPresenter protocol methods

- (void)userDidSelectBack
{
    // TODO: not used ?
}

@end
