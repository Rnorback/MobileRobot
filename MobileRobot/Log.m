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

- (void) addQuantity:(NSNumber*)qty OType:(FoodType*)type{
    NSMutableDictionary * parts = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"logParts"]];
    [parts setObject:@{@"food_type_id":type.foodTypeId, @"description":@"", @"weight":qty, @"count":@""}  forKey:[NSString stringWithFormat:@"new%ld", (long)[[NSDate date] timeIntervalSince1970]]];
    [_rawDictionary setObject:parts forKey:@"logParts"];
}

- (void) markHoursSpent:(NSNumber*)hoursSpent{
    NSMutableDictionary *log = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"log"]];
    [log setObject:hoursSpent forKey:@"hours_spent"];
    [_rawDictionary setObject:log forKey:@"log"];
}

- (void) addWhyZero:(ReasonWhyNotZero)explanation{
    NSMutableDictionary *log = [NSMutableDictionary dictionaryWithDictionary:self.rawDictionary[@"log"]];
    [log setObject:@(explanation) forKey:@"why_zero"];
    [_rawDictionary setObject:log forKey:@"log"];
}

@end
