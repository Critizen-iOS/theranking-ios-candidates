//
//  PXFetchManager.h
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Photo.h"
#import "Camera.h"
#import "User.h"

@interface PXFetchManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *moc;

+ (PXFetchManager *)sharedManager;

- (void)requestPhotos:(NSString *)feature
                 page:(NSNumber *)page
                 sort:(NSString *)sort
        sortDirection:(NSString *)sortDirection
            imageSize:(NSNumber *)size
             callback:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock;

- (void)requestPhotoId:(NSNumber *)photoId
             imageSize:(NSNumber *)size
         callbackBlock:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock;

- (Photo *)fetchPhotoById:(NSNumber *)photoId;

@end
