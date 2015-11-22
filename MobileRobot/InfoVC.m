//
//  InfoVC.m
//  MobileRobot
//
//  Created by Rob Norback on 11/22/15.
//  Copyright © 2015 Norback Solutions, LLC. All rights reserved.
//

#import "InfoVC.h"
#import "InfoTableVC.h"
#import "Route.h"
#import "WeighVC.h"

@interface InfoVC ()
@property (strong, nonatomic) IBOutlet UIButton *finishRouteButton;
@property (strong, nonatomic) IBOutlet UIButton *weighFoodButton;

@end

@implementation InfoVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = false;
    
    [self addButtonShadow:self.finishRouteButton];
    [self addButtonShadow:self.weighFoodButton];
}

- (void)addButtonShadow:(UIButton*)button {
    button.layer.cornerRadius = 8.0f;
    button.layer.masksToBounds = NO;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowRadius = 3;
    button.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishRouteTapped:(UIButton *)sender {
}

- (IBAction)weighFoodTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"weighSegue" sender:self.route.logs[0]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSString *segueName = segue.identifier;
    if ([segueName  isEqual: @"infoEmbed"]) {
        ((InfoVC*)segue.destinationViewController).route = self.route;
    } else if ([segueName isEqual: @"weighSegue"]) {
        ((WeighVC*)segue.destinationViewController).log = sender;
    }

}


@end
