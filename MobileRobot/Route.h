//
//  Route.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;
@class Log;

@interface Route : NSObject

@property NSString* routeId; //schedule chain id... currently not>used beause it isn't exposed via the API

@property NSMutableArray <Location*> *donors;
@property NSMutableArray <Location*> *recipients;

@property NSMutableArray <Log*> *logs;


@end
