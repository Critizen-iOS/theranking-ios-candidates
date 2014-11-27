//
//  Picture.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "Picture.h"


@implementation Picture

@dynamic userFullname;
@dynamic userAvatarURL;
@dynamic pictureTitle;
@dynamic pictureDescription;
@dynamic cameraName;
@dynamic cameraISO;
@dynamic cameraShutterSpeed;
@dynamic cameraFocalLength;
@dynamic cameraLens;
@dynamic pictureLat;
@dynamic pictureLong;
@dynamic pictureRating;


- (NSString *)cameraDescription {
    NSMutableString *description = [NSMutableString new];
    
    if([self.cameraName length] > 0) {
        [description appendFormat:@"%@\n", self.cameraName];
    }
    
    if([self.cameraLens length] > 0) {
        [description appendFormat:@"%@: %@\n", NSLocalizedString(@"Lens", @"Camera Lens display name"),self.cameraLens];
    }
    
    if(self.cameraISO != nil) {
        [description appendFormat:@"ISO: %@\n", self.cameraISO];
    }

    if([self.cameraShutterSpeed length] > 0) {
        [description appendFormat:@"%@: %@\n", NSLocalizedString(@"Shutter Speed", @"Camera Shutter Speed display name"),self.cameraShutterSpeed];
    }
    
    if(self.cameraFocalLength != nil) {
        [description appendFormat:@"%@: %@\n", NSLocalizedString(@"Focal Length", @"Camera Focal Length display name"),self.cameraFocalLength];
    }
    
    return description;
}

@end
