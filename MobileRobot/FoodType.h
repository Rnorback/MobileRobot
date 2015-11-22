//
//  FoodType.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodType : NSObject
@property NSNumber *foodTypeId;
@property NSString *name;

- (instancetype) initWithDictionary:(NSDictionary*)d;
@end
