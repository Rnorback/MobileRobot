//
//  Location.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

typedef NS_ENUM(NSUInteger, LocationType) {
    LocationTypeDonor,
    LocationTypeRecipient,
};

@interface Location : NSObject

@property NSString* locationId;
@property LocationType locationType;
@property NSString *name;
@property NSString* address;
@property CLLocation* geoPoint;
@property NSString *website;
@property NSString *email;
@property NSString *phone;
@property NSString *equiptmentStorageInfo;
@property NSString *foodStorageInfo;
@property NSString *entryInfo;
@property NSString *exitInfo;
@property NSString *onsiteContactInfo;

- (void) inflateWithDictionary:(NSDictionary*)d;


@end
