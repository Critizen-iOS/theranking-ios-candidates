//
//  FHDDetailInteractor.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDDetailItem.h"
#import "FHDDetailDataManager.h"

// This class represents the Interactor for the use case "Show item details"
// Gets and prepare data from data source and passes it to the Presenter
@interface FHDDetailInteractor : NSObject

// Data manager, used to retreive data from source
@property (nonatomic, strong) FHDDetailDataManager *dataManager;

/**
 * Gets item details from data source and passes it to the Presenter
 * @param identifier item identifier to get its details
 * @param completion block to execute when data is ready; uses an FHDDetailItem object
 */
- (void)getDetailForItem:(NSNumber *)identifier completionBlock:(void(^)(FHDDetailItem *item))completion;

@end
