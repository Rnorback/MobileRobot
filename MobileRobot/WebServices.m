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
#import "FoodType.h"

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

+ (void) listRoutesForCurrentUserWithCompletion:(void(^)(NSError* error, NSArray<Route*> *routes))completion{
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
        __block int reqs = 0;
        Location *donor = [Location new];
        donor.locationId = responseObject[@"log"][@"donor_id"];
        [log.parentRoute.donors addObject:donor];
        reqs ++;
        [self fillLocation:donor withCompletion:^(NSError *error, Location *location) {
            reqs--;
            if (reqs == 0) {
                completion(nil, log);
            }
        }];
        
        for (NSString *str in responseObject[@"log"][@"recipient_ids"]){
            Location *recipient = [Location new];
            recipient.locationId = str;
            
            [log.parentRoute.recipients addObject:recipient];
            reqs++;
            [self fillLocation:recipient withCompletion:^(NSError *error, Location *location) {
                reqs--;
                if (reqs==0){
                    completion(nil, log);
                }
            }];
        }
        
        [log inflateWithDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

+ (void) fillLocation:(Location *)location withCompletion:(void(^)(NSError *error, Location *location))completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserDefaultsKey];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:tokenDefaultsKey];
    NSString *url = [NSString stringWithFormat:@"%@/locations/%@.json?volunteer_email=%@&volunteer_token=%@", baseURL, location.locationId, user, token];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [location inflateWithDictionary:responseObject];
        completion(nil, location);
    }
    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

+ (void) postLog:(Log *)log withCompletion:(void(^)(NSError *error))completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserDefaultsKey];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:tokenDefaultsKey];
    NSString *url = [NSString stringWithFormat:@"%@/logs/%@.json?volunteer_email=%@&volunteer_token=%@", baseURL, log.logId, user, token];
    
    // some quick data cleanup:
    NSMutableDictionary *clean = [NSMutableDictionary dictionaryWithDictionary:log.rawDictionary[@"log_parts"]];
    for (NSString *key in [clean allKeys]){
        NSMutableDictionary *part = [NSMutableDictionary dictionaryWithDictionary:clean[key]];
        if ([part[@"weight"] isKindOfClass:[NSNull class]]){
            part[@"weight"] = @"";
        }
        if ([part[@"count"] isKindOfClass:[NSNull class]]){
            part[@"count"] = @"";
        }
        if ([part[@"description"] isKindOfClass:[NSNull class]]){
            part[@"description"] = @"";
        }
        clean[key] = part;
    }
    [log.rawDictionary[@"log"] removeObjectForKey:@"volunteer_names"];
    [log.rawDictionary setObject:clean forKey:@"log_parts"];
    
    NSData *d = [NSJSONSerialization dataWithJSONObject:log.rawDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"JSON:\n\n\n%@",  jsonStr);
    
    
    
    
    [manager PUT:url parameters:log.rawDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (![responseObject[@"error"] isEqualToNumber:@0]){
            completion([NSError errorWithDomain:@"asdfasdf" code:-1203 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"message"]}]);
            return;
        }
        completion(nil);
    }
    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSString *errorStr = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        NSLog(@"%@", errorStr);
        completion(error);
    }];
}

+ (void) getFoodTypesWithCompletion:(void(^)(NSError *error, NSArray *types))completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserDefaultsKey];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:tokenDefaultsKey];
    NSString *url = [NSString stringWithFormat:@"%@/food_types.json?volunteer_email=%@&volunteer_token=%@", baseURL, user, token];
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *types = [NSMutableArray new];
        for (NSDictionary *d in responseObject){
            [types addObject:[[FoodType alloc] initWithDictionary:d]];
        }
        completion(nil, types);
    }
    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(error, nil);
    }];
}

//+ (void) startLog:(Log *)log withCompletion:(void(^)(NSError *error))completion{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserDefaultsKey];
//    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:tokenDefaultsKey];
//    NSString *url = [NSString stringWithFormat:@"%@/logs/%@/take.json?volunteer_email=%@&volunteer_token=%@", baseURL, log.logId, user, token];
//    
//    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        completion(nil);
//    }
//    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        completion(error);
//    }];
//    
//}

@end