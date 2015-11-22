//
//  FoodType.m
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import "FoodType.h"

@implementation FoodType

- (instancetype) initWithDictionary:(NSDictionary*)d{
    self=[super init];
    
    _name = d[@"name"];
    _foodTypeId = d[@"id"];
    
    return self;
}

@end
