//
//  FHDPopularInteractor.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDPopularDataManager.h"

// This class represents the Interactor for the use case "Show popular items"
// Gets and prepare data from data source and passes it to the Presenter
@interface FHDPopularInteractor : NSObject

// Data manager, used to retreive data from different sources
@property (nonatomic, strong) FHDPopularDataManager *dataManager;

/**
 * Get popular item from data source and passes it to the Presenter
 * @param page page number to retreive data
 * @param completion block to execute when data is ready; uses an array of FHDPopularItem objects
 */
- (void)getPopularFromPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion;

@end
