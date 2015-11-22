//
//  InfoTableVC.h
//  MobileRobot
//
//  Created by Rob Norback on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Route;

@interface InfoTableVC: UITableViewController
@property Route* route;

- (void)doneButtonPressed:(id)sender;
@end
