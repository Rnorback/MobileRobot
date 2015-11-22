//
//  InfoTableVC.m
//  MobileRobot
//
//  Created by Rob Norback on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import "InfoTableVC.h"
#import "Route.h"
#import "Log.h"
#import "Location.h"
#import "WeighVC.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WebServices.h"
#import "SVProgressHUD.h"

@implementation UILabel (dynamicSizeMeWidth)

-(void)resizeToStretch{
    float width = [self expectedWidth];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self setFrame:newFrame];
}

-(float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, CGRectGetWidth(self.bounds) );
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize.width;
}

@end

@interface InfoTableVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *pickupLbl;
@property (weak, nonatomic) IBOutlet UITextView *notesTxtView;
@property (weak, nonatomic) IBOutlet UITableViewCell *notesCell;
@property (weak, nonatomic) IBOutlet UILabel *expectedWeightLbl;
@property (weak, nonatomic) IBOutlet UILabel *hillinessLbl;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLbl;

@property (weak, nonatomic) IBOutlet UILabel *pickupNameLbl;
@property (strong, nonatomic) IBOutlet UITextView *pickupAddressLbl;
@property (strong, nonatomic) IBOutlet UITextView *pickupEntryLbl;
@property (strong, nonatomic) IBOutlet UITextView *pickupEquipmentLbl;
@property (strong, nonatomic) IBOutlet UITextView *pickupFoodLbl;
@property (strong, nonatomic) IBOutlet UITextView *pickupContactLbl;
@property (strong, nonatomic) IBOutlet UITextView *pickupExitLbl;

@property (weak, nonatomic) IBOutlet UILabel *dropoffNameLbl;
@property (strong, nonatomic) IBOutlet UITextView *dropoffAddressLbl;
@property (strong, nonatomic) IBOutlet UITextView *dropoffEntryLbl;
@property (strong, nonatomic) IBOutlet UITextView *dropoffFoodLbl;
@property (strong, nonatomic) IBOutlet UITextView *dropoffContactLbl;
@property (strong, nonatomic) IBOutlet UITextView *dropoffExitLbl;

@end

@implementation InfoTableVC {
    UIButton *weighFoodButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-64,0,0,0)];
//    self.navigationController.navigationBarHidden = false;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
}
- (void)doneButtonPressed:(id)sender{
    Log * log = self.route.logs[0];
//    BOOL hasWeight = NO;
//    for (NSString* partKey in [log.rawDictionary[@"log_parts"] allKeys]){
//        if ([partKey containsString:@"new"]){
//            hasWeight = YES;
//        }
//    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Finish Trip" message:@"How long did this take?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // post log
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *n = [f numberFromString:[alert textFields][0].text];
        if (!n){
            [[alert textFields][0] becomeFirstResponder];
            return;
        }
        [log markHoursSpent:n];
        [WebServices postLog:log withCompletion:^(NSError *error) {
            if (error){
                [SVProgressHUD showErrorWithStatus:@"An error occured. Please try again later"];
            }
        }];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Hours spent";
        ok.enabled = NO;
        
        textField.bk_shouldChangeCharactersInRangeWithReplacementStringBlock = ^BOOL(UITextField *field, NSRange r, NSString *s){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *n = [f numberFromString:[field.text stringByReplacingCharactersInRange:r withString:s]];
            
            if (n){
                ok.enabled = YES;
            }
            else {
                ok.enabled = NO;
            }
            return YES;
        };
    }];
    
    [alert addAction:ok];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    Log* log = self.route.logs[0];
    
    self.titleLbl.text = [NSString stringWithFormat:self.titleLbl.text, self.route.recipients[0].name];
    self.titleLbl.numberOfLines = 2;
    //[self.titleLbl sizeToFit];

    self.pickupLbl.text = [NSString stringWithFormat:self.pickupLbl.text, log.pickupStartTime, log.pickupEndTime];
    
//    self.notesLbl.numberOfLines = 0;
    self.notesTxtView.text = log.notes;
    [self.notesTxtView sizeToFit];

    // calculate notes lbl height
//    [self.notesLbl resizeToStretch];
    self.expectedWeightLbl.text = [NSString stringWithFormat:@"%@", log.expectedWeight];
    self.hillinessLbl.text = log.hilliness;
    self.difficultyLbl.text = log.difficulty;
    
    Location *pickup = self.route.donors[0];
    self.pickupNameLbl.text = [NSString stringWithFormat:@"%@ (Donor)",pickup.name];
    [self.pickupNameLbl setFont:[UIFont boldSystemFontOfSize:16.0]];
    self.pickupAddressLbl.text = pickup.address;
    self.pickupEntryLbl.text = pickup.entryInfo;
    self.pickupEquipmentLbl.text = pickup.equiptmentStorageInfo;
    self.pickupFoodLbl.text = pickup.foodStorageInfo;
    self.pickupContactLbl.text = pickup.onsiteContactInfo;
    self.pickupExitLbl.text = pickup.exitInfo;
    
    Location *dropoff = self.route.recipients[0];
    self.dropoffNameLbl.text = [NSString stringWithFormat:@"%@ (Reciepient)",dropoff.name];
    [self.dropoffNameLbl setFont:[UIFont boldSystemFontOfSize:16.0]];
    self.dropoffAddressLbl.text = dropoff.address;
    self.dropoffEntryLbl.text = dropoff.entryInfo;
    self.dropoffFoodLbl.text = dropoff.foodStorageInfo;
    self.dropoffContactLbl.text = dropoff.onsiteContactInfo;
    self.dropoffExitLbl.text = dropoff.exitInfo;
}

- (IBAction)weighFoodButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"weighSegue" sender:self.route.logs[0]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((WeighVC*)segue.destinationViewController).log = sender;
}

@end


