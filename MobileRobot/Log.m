//
//  Log.m
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import "Log.h"
#import "FoodType.h"

#define dayOfWeekLookup @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"]
#define hillinessLookup @[@"Flat", @"Some Small Hills", @"Hilly", @"Hilly fo Reals"]
#define difficultyLookup @[@"Easiest", @"Typical", @"Chalenging", @"Most Difficult"]


@interface Log ()
@end


/*
 
 {
 "log": {
 "id": 31058,
 "when": "2015-11-22",
 "notes": "",
 "num_reminders": null,
 "flag_for_admin": false,
 "created_at": "2015-11-19T19:00:25-07:00",
 "updated_at": "2015-11-20T10:07:16-07:00",
 "donor_id": 4,
 "transport_type_id": null,
 "region_id": 1,
 "complete": false,
 "scale_type_id": null,
 "weight_unit": null,
 "schedule_chain_id": 89,
 "num_volunteers": 1,
 "why_zero": null,
 "hours_spent": null,
 "recipient_ids": [
 20
 ],
 "volunteer_ids": [
 993
 ],
 "volunteer_names": [
 "Lindsey Loberg"
 ]
 },
 "schedule": {
 "id": 89,
 "detailed_start_time": "2000-01-01T09:30:00Z",
 "detailed_stop_time": "2000-01-01T10:00:00Z",
 "detailed_date": "2013-09-15",
 "transport_type_id": 1,
 "backup": false,
 "temporary": false,
 "irregular": false,
 "difficulty_rating": 0,
 "hilliness": 0,
 "scale_type_id": null,
 "region_id": 1,
 "frequency": "weekly",
 "day_of_week": 0,
 "expected_weight": 80,
 "public_notes": "Please Contact:\r\nCloud Dunn – apt. 111, 720-982-0565 and let him know that you are coming before you leave the store. ",
 "admin_notes": "",
 "num_volunteers": 1,
 "active": true
 },
 "log_parts": {
 "38399": {
 "id": 38399,
 "log_id": 31058,
 "food_type_id": 58,
 "required": null,
 "weight": "0.0",
 "created_at": "2015-11-19T19:00:25-07:00",
 "updated_at": "2015-11-20T10:07:16-07:00",
 "count": null,
 "description": ""
 }
 }
 }
 
 */


@implementation Log

- (void) inflateWithDictionary:(NSDictionary*)d{
    _rawDictionary = [NSMutableDictionary dictionaryWithDictionary:d];

    int dayOfWeek = [d[@"schedule"][@"day_of_week"] intValue];
    _dayOfWeek = dayOfWeekLookup[dayOfWeek];
    
    int hilliness = [d[@"schedule"][@"hilliness"] intValue];
    _hilliness = hillinessLookup[hilliness];
    
    _frequency = d[@"schedule"][@"frequency"];
    _expectedWeight = d[@"schedule"][@"expected_weight"];
    _notes = d[@"schedule"][@"public_notes"];
    
    NSDateFormatter *inFmt = [[NSDateFormatter alloc] init];
//    2000-01-01T09:30:00Z
    [inFmt setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDateFormatter *outFmt = [[NSDateFormatter alloc] init];
    [outFmt setDateFormat:@"HH:mm a"];
    _pickupStartTime = [outFmt stringFromDate:[inFmt dateFromString:d[@"schedule"][@"detailed_start_time"]]];
    _pickupEndTime = [outFmt stringFromDate:[inFmt dateFromString:d[@"schedule"][@"detailed_stop_time"]]];
    
    int difficulty = [d[@"schedule"][@"difficulty_rating"] intValue];
    _difficulty = difficultyLookup[difficulty];
    
}

- (void) addQuantity:(NSString*)qty OfType:(FoodType*)type{
    NSMutableDictionary * parts = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"log_parts"]];
    [parts setObject:@{@"food_type_id":type.foodTypeId, @"description":@"", @"weight":qty, @"count":@""}  forKey:[NSString stringWithFormat:@"new%ld", (long)[[NSDate date] timeIntervalSince1970]]];
    [_rawDictionary setObject:parts forKey:@"log_parts"];
}

- (void) markHoursSpent:(NSNumber*)hoursSpent{
    NSMutableDictionary *log = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"log"]];
    [log setObject:hoursSpent forKey:@"hours_spent"];
    [_rawDictionary setObject:log forKey:@"log"];
}

- (void) addWeighMethod:(NSNumber*)methodId{
    NSMutableDictionary *log = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"log"]];
    [log setObject:methodId forKey:@"scale_type_id"];
    [log setObject:@1 forKey:@"transport_type_id"];
    [_rawDictionary setObject:log forKey:@"log"];
    
    NSMutableDictionary *schedule = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"schedule"]];
    [schedule setObject:methodId forKey:@"scale_type_id"];
    [schedule setObject:methodId forKey:@"transport_type_id"];
    [_rawDictionary setObject:schedule forKey:@"schedule"];
}

- (void) addWhyZero:(ReasonWhyNotZero)explanation{
    NSMutableDictionary *log = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"log"]];
    [log setObject:@(explanation) forKey:@"why_zero"];
    [_rawDictionary setObject:log forKey:@"log"];
}

@end
