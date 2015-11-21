//
//  Location.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LocationType) {
    LocationTypeDonor,
    LocationTypeRecipient,
};

@interface Location : NSObject

@property NSString* locationId;
@property LocationType locationType;
@property NSString *name;

@end
