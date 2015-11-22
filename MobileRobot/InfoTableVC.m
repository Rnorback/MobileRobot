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

@implementation UILabel (dynamicSizeMeWidth)

-(void)resizeToStretch{
    float width = [self expectedWidth];
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    [self setFrame:newFrame];
}

-(float)expectedWidth{
    [self setNumberOfLines:1];
    
    CGSize maximumLabelSize = CGSizeMake( CGFLOAT_MAX, CGRectGetWidth(self.bounds) );
    
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
@property (weak, nonatomic) IBOutlet UIButton *weighFoodButton;


@property (weak, nonatomic) IBOutlet UILabel *dropoffNameLbl;

@end

@implementation InfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    Log* log = self.route.logs[0];
    
    self.titleLbl.text = [NSString stringWithFormat:self.titleLbl.text, self.route.recipients[0].name];
    self.titleLbl.numberOfLines = 0;
    [self.titleLbl sizeToFit];

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
    self.pickupNameLbl.text = pickup.name;
    
    Location *dropoff = self.route.recipients[0];
    self.dropoffNameLbl.text = dropoff.name;
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


