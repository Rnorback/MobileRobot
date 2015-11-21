//
//  WebServices.m
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import "WebServices.h"
#import "AFNetworking.h"

static const NSString *baseURL = @"http://robot.boulderfoodrescue.org";
static const NSString *tokenDefaultsKey = @"com.BFR.logintokenkey";

@implementation WebServices

+ (void) loginWithUsername:(NSString*)username andPassword:(NSString*)password withCompletion:(void (^)(NSError *error))completion{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/volunteers/sign_in.json?email=%@&password=%@", baseURL, username, password];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

+ (void) listRoutesForCurrentUserWithCompletion{
    
}

@end