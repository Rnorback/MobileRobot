//
//  LoginVC.m
//  MobileRobot
//
//  Created by Rob Norback on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import "LoginVC.h"
#import "WebServices.h"

#define kLostPasswordAlertTag 1

@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lostPasswordButtonPressed:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password"
                                                    message:@"Enter your email to reset your password"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Next", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = kLostPasswordAlertTag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kLostPasswordAlertTag) {
        if (buttonIndex == 1) {
            // The next button was pressed, send a password reset email
            NSString *email = [alertView textFieldAtIndex:0].text;
            [self emailSentAlert:email];
        }
    }
}

- (void)emailSentAlert:(NSString*)email {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Email Sent"
                                                    message:[NSString stringWithFormat:@"An email was sent to %@ with instructions for resetting your password", email]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    [WebServices loginWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text withCompletion:^(NSError *error) {
        [self.activityIndicator stopAnimating];
    }];
    [self.activityIndicator startAnimating];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
