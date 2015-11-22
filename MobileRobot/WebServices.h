
//
//  WebService.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Route;
@class Log;

@interface WebServices : NSObject
+ (void) loginWithUsername:(NSString*)username andPassword:(NSString*)password withCompletion:(void (^)(NSError *error))completion;

+ (void) listRoutesForCurrentUserWithCompletion:(void(^)(NSError* error, NSArray<Route*> *routes))completion;
+ (void) postLog:(Log *)log withCompletion:(void(^)(NSError *error))completion;


@end