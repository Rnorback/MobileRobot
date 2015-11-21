//
//  WebServices.m
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import "WebServices.h"
#import "AFNetworking.h"

#import "Route.h"
#import "Log.h"
#import "Location.h"

static const NSString *baseURL = @"http://robot.boulderfoodrescue.org";
static  NSString *tokenDefaultsKey = @"com.BFR.logintokenkey";
static  NSString *currentUserDefaultsKey = @"com.BFR.loginuserkey";

@implementation WebServices

+ (void) loginWithUsername:(NSString*)username andPassword:(NSString*)password withCompletion:(void (^)(NSError *error))completion{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/volunteers/sign_in.json?email=%@&password=%@", baseURL, username, password];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"The response object:%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:currentUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"authentication_token"] forKey:tokenDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        completion(nil);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error);
    }];
}

+ (void) listRoutesForCurrentUserWithCompletion:(void(^)(NSError* error, NSArray *routes))completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserDefaultsKey];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:tokenDefaultsKey];
    NSString *url = [NSString stringWithFormat:@"%@/logs/mine_upcoming.json?volunteer_email=%@&volunteer_token=%@", baseURL, user, token];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]] && [responseObject[0] isKindOfClass:[NSArray class]]){
            
            NSMutableArray *toFetch = [NSMutableArray new];
            NSMutableArray *routes = [NSMutableArray new];
            
            for (NSArray *logList in responseObject){
                Route *r = [Route new];
                [routes addObject:r];
                for (NSDictionary *d in logList){
                    Log *l = [Log new];
                    l.logId = d[@"id"];
                    l.parentRoute = r;
                    [toFetch addObject:l];
                    [r.logs addObject:l];
                    
                    [self getLogDetailForLog:l withCompletion:^(NSError *error, Log *log) {
                        if (error){
                            completion(error, nil);
                        }
                        [toFetch removeObject:l];
                        if (toFetch.count == 0){
                            completion(nil, routes);
                        }
                    }];
                }
            }
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

+(void) getLogDetailForLog:(Log*)log withCompletion:(void (^)(NSError *error, Log* log))completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserDefaultsKey];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:tokenDefaultsKey];
    NSString *url = [NSString stringWithFormat:@"%@/logs/%@.json?volunteer_email=%@&volunteer_token=%@", baseURL, log.logId, user, token];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        Location *donor = [Location new];
        donor.locationId = responseObject[@"log"][@"donor_id"];
        [log.parentRoute.donors addObject:log];
        
        for (NSString *str in responseObject[@"log"][@"recipient_ids"]){
            Location *recipient = [Location new];
            recipient.locationId = str;
            [log.parentRoute.recipients addObject:recipient];
        }
        
        completion(nil, log);
        
        [log inflateWithDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

@end