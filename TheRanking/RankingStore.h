//
//  RankingStore.h
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 26/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Picture.h"

@interface RankingStore : NSObject

- (NSManagedObjectContext *) newBackgroundObjectContext;
- (NSManagedObjectContext *) mainObjectContext;

- (void)saveContext;

@end
