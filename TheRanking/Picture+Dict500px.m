//
//  Picture+Dict500px.m
//  TheRanking
//
//  Created by Luis Sanchez Garcia on 27/11/14.
//  Copyright (c) 2014 Luis Sánchez García. All rights reserved.
//

#import "Picture+Dict500px.h"

@implementation Picture (Dict500px)

- (void) importFrom500pxDictionary: (NSDictionary *)pictureDictionary {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSDictionary *userDictionary = pictureDictionary[@"user"];
    if(userDictionary) {
        self.userFullname = objectFromDictionaryValue(userDictionary[@"fullname"]);
        self.userAvatarURL = objectFromDictionaryValue(userDictionary[@"userpic_url"]);
    }
    
    self.pictureTitle = objectFromDictionaryValue(pictureDictionary[@"name"]);
    self.pictureDescription = objectFromDictionaryValue(pictureDictionary[@"description"]);
    self.cameraName = objectFromDictionaryValue(pictureDictionary[@"camera"]);
    self.cameraLens = objectFromDictionaryValue(pictureDictionary[@"lens"]);
    self.cameraISO = [formatter numberFromString: objectFromDictionaryValue(pictureDictionary[@"iso"])];
    self.cameraShutterSpeed = objectFromDictionaryValue(pictureDictionary[@"shutter_speed"]);
    self.cameraFocalLength = [formatter numberFromString:objectFromDictionaryValue(pictureDictionary[@"focal_length"])];
    
    self.pictureLat = objectFromDictionaryValue(pictureDictionary[@"latitude"]);
    self.pictureLong = objectFromDictionaryValue(pictureDictionary[@"longitude"]);
    
    self.pictureRating = objectFromDictionaryValue(pictureDictionary[@"rating"]);
}

static inline id objectFromDictionaryValue(id value) {
    if(value == nil || [value isEqual:[NSNull null]]){
        return nil;
    }
    return value;
}

@end
