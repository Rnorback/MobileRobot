//
//  Log.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Route;

@interface Log : NSObject

@property NSString *logId;

@property (weak) Route *parentRoute;


- (void) inflateWithDictionary:(NSDictionary*)d;

@end
