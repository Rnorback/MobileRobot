
//
//  WebService.h
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject
    + (void) loginWithUsername:(NSString*)username andPassword:(NSString*)password withCompletion:(void (^)(NSError *error))completion;
@end