//
//  RoutesTableVC.m
//  MobileRobot
//
//  Created by Rob Norback on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import "RoutesTableVC.h"
#import "WebServices.h"

#import "Route.h"
#import "Location.h"
#import "InfoVC.h"
#import "InfoTableVC.h"

@interface RoutesTableVC ()
@property NSMutableArray *routes;
@end

@implementation RoutesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Food Routes";
    self.navigationItem.hidesBackButton = YES;
    
    [WebServices listRoutesForCurrentUserWithCompletion:^(NSError *error, NSArray *routes) {
        if (error){
            // TODO: show error
        }
        self.routes = [routes mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routes.count;
}

- (NSString *) textForRow:(int)row{
    Route *route = self.routes[row];
    Location *donor = route.donors[0];
    Location *recipient = route.recipients[0];
    return [NSString stringWithFormat:@"%@ to %@", donor.name, recipient.name];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [self textForRow:(int)indexPath.row];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font
                       constrainedToSize:CGSizeMake(cell.textLabel.bounds.size.width, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setFrame:CGRectMake(0 , 0 , size.width , size.height)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [self textForRow:(int)indexPath.row];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(self.view.bounds.size.width-50, 20000) lineBreakMode:NSLineBreakByWordWrapping];
    float heightToAdd = MIN(textSize.height+20, 100.0f); //Some fix height is returned if height is small or change it to MAX(textSize.height, 150.0f); // whatever best fits for you
    return heightToAdd;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"infoSegue" sender:self.routes[indexPath.row]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((InfoVC*)segue.destinationViewController).route = sender;
}

@end
