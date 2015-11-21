//
//  Route.m
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import "Route.h"

@implementation Route

- (instancetype)init{
    self = [super init];
    _donors = [NSMutableArray new];
    _recipients = [NSMutableArray new];
    _logs = [NSMutableArray new];
    return self;
}

- (instancetype) initWithDict:(NSDictionary*)d{
    self = [super init];
    
    
    
    return self;
}

@end
