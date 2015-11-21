//
//  Route.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject


@property NSString* routeId; //schedule chain id... currently not used beause it isn't exposed via the API

@property NSMutableArray *donors;
@property NSMutableArray *recipients;

@property NSMutableArray *logs;


@end
