//
//  Location.m
//  MobileRobot
//
//  Created by Adam Shiemke on 11/21/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import "Location.h"

@implementation Location

//- (instancetype) initWithDictionary:(NSDictionary*)d{
//    self = [super init];
//    
//    return self;
//}

/*
 "id": 245,
 "recip_category": "",
 "donor_type": "",
 "address": "3990 Broadway, Boulder, CO 80304",
 "name": "Lucky's Bakehouse",
 "lat": "40.0475991",
 "lng": "-105.2816644",
 "contact": "",
 "website": "http://www.luckysmarket.com/luckys-bakehouse/",
 "admin_notes": "",
 "public_notes": "",
 "hours": null,
 "created_at": "2014-06-24T12:46:05-06:00",
 "updated_at": "2015-11-04T11:05:50-07:00",
 "region_id": 1,
 "twitter_handle": "",
 "receipt_key": "blfybdhr",
 "detailed_hours_json": "{\"0\":{\"status\":\"0\",\"start\":\"Wed, 04 Nov 2015 00:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 00:00:00 -0700\"},\"1\":{\"status\":\"0\",\"start\":\"Wed, 04 Nov 2015 00:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 00:00:00 -0700\"},\"2\":{\"status\":\"0\",\"start\":\"Wed, 04 Nov 2015 00:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 00:00:00 -0700\"},\"3\":{\"status\":\"0\",\"start\":\"Wed, 04 Nov 2015 00:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 00:00:00 -0700\"},\"4\":{\"status\":\"0\",\"start\":\"Wed, 04 Nov 2015 00:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 00:00:00 -0700\"},\"5\":{\"status\":\"0\",\"start\":\"Wed, 04 Nov 2015 00:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 00:00:00 -0700\"},\"6\":{\"status\":\"1\",\"start\":\"Wed, 04 Nov 2015 17:00:00 -0700\",\"end\":\"Wed, 04 Nov 2015 18:00:00 -0700\"}}",
 "email": "jen@luckysbakehouse.com",
 "phone": "303-530-0782",
 "equipment_storage_info": "Use Lucky's trailer outside of Lucky's store on west side",
 "food_storage_info": "They should give you a few little bags of pastries; just make sure they don't fall off the trailer! PASTRY CATASTROPHES ARE TO BE AVOIDED.",
 "entry_info": "Go in front door of Lucky's Bakehouse",
 "exit_info": "",
 "onsite_contact_info": "Tell person at front desk you are with BFR",
 "active": true,
 "location_type": 1
 */
- (void) inflateWithDictionary:(NSDictionary*)d{
    self.name = d[@"name"];
    self.address = d[@"address"];
    self.geoPoint = [[CLLocation alloc] initWithLatitude:[d[@"lat"] doubleValue] longitude:[d[@"long"] doubleValue]];
    self.website = d[@"website"];
    self.email = d[@"email"];
    self.phone = d[@"phone"];
    self.equiptmentStorageInfo = d[@"equipment_storage_info"];
    self.foodStorageInfo = d[@"food_storage_info"];
    self.entryInfo = d[@"entry_info"];
    self.exitInfo = d[@"exit_info"];
    self.onsiteContactInfo = d[@"onsite_contact_info"];
}

@end
