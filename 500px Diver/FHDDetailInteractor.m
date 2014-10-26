//
//  FHDDetailInteractor.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDDetailInteractor.h"
#import "FHDItem.h"

@implementation FHDDetailInteractor

- (void)getDetailForItem:(NSNumber *)identifier completionBlock:(void(^)(FHDDetailItem *item))completion
{
    [_dataManager getDetailDataForItem:identifier completionBlock:^(FHDItem *item) {
        
        FHDDetailItem *detailItem = [[FHDDetailItem alloc] init];
        detailItem.name = item.name;
        detailItem.desc = item.desc;
        detailItem.userName = item.userName;
        detailItem.userAvatarUrl = item.userAvatarUrl;
        detailItem.camera = item.camera;
        detailItem.latitude = item.latitude;
        detailItem.longitude = item.longitude;
        
        completion(detailItem);
    }];
}

@end
