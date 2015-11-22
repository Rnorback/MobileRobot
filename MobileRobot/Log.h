//
//  Log.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ReasonWhyNotZero) {
    ReasonWhyNotZeroNoFood = 1,
    ReasonWhyNotZeroShiftDidntHappen = 2,
};

@class Route;
@class FoodType;

@interface Log : NSObject

@property NSMutableDictionary *rawDictionary;

@property NSString *logId;

@property (weak) Route *parentRoute;

@property NSString* dayOfWeek;
@property NSString* frequency;
@property NSString* hilliness;
@property NSString* expectedWeight;
@property NSString* notes;
@property NSString* pickupStartTime;
@property NSString* pickupEndTime;
@property NSString* difficulty;

//@property BOOL irregular;


- (void) inflateWithDictionary:(NSDictionary*)d;
- (void) addQuantity:(NSString*)qty OfType:(FoodType*)type;
- (void) markHoursSpent:(NSNumber*)hoursSpent;
- (void) addWeighMethod:(NSNumber*)methodId;
- (void) addWhyZero:(ReasonWhyNotZero)explanation;
@end
