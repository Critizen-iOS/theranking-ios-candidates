//
//  Picture.h
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Picture : NSManagedObject

@property (nonatomic, retain) NSString * userFullname;
@property (nonatomic, retain) NSString * userAvatarURL;
@property (nonatomic, retain) NSString * pictureTitle;
@property (nonatomic, retain) NSString * pictureDescription;
@property (nonatomic, retain) NSString * cameraName;
@property (nonatomic, retain) NSNumber * cameraISO;
@property (nonatomic, retain) NSString * cameraShutterSpeed;
@property (nonatomic, retain) NSNumber * cameraFocalLength;
@property (nonatomic, retain) NSString * cameraLens;
@property (nonatomic, retain) NSNumber * pictureLat;
@property (nonatomic, retain) NSNumber * pictureLong;
@property (nonatomic, retain) NSNumber * pictureRating;

@end
