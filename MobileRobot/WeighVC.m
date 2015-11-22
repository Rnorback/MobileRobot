//
//  WeighVC.m
//  MobileRobot
//
//  Created by Rob Norback on 11/21/15.
//  Copyright © 2015 Adam Shiemke. All rights reserved.
//

#import "WeighVC.h"
#import "Log.h"
#import "FoodType.h"

@interface WeighVC ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UISegmentedControl *methodSelector;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WeighVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Weight Info";
    self.navigationController.navigationBarHidden = false;

    for (NSString *key in [self.log.rawDictionary[@"log_parts"] allKeys]){
        NSDictionary *part = self.log.rawDictionary[@"log_parts"][key];
        [self setText:part[@"weight"] forTypeId:part[@"food_type_id"]];
    }
    [self.scrollView setContentInset:UIEdgeInsetsMake(-104,0,0,0)];
}

- (void) setText:(NSString*)text forTypeId:(NSNumber*)type{
    NSArray *lookup = @[@98, @63, @61, @60, @59, @58];
    NSInteger i = [lookup indexOfObject:type];
    if (i!=NSNotFound){
        ((UITextField*)self.textFields[i]).text = text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/*
 [
 {
 "active": true,
 "created_at": "2013-05-16T15:17:07-06:00",
 "id": 58,
 "name": "Produce",
 "region_id": 1,
 "updated_at": "2013-05-16T15:17:07-06:00"
 },
 {
 "active": true,
 "created_at": "2013-05-16T15:17:07-06:00",
 "id": 59,
 "name": "Baked Goods",
 "region_id": 1,
 "updated_at": "2013-05-16T15:17:07-06:00"
 },
 {
 "active": true,
 "created_at": "2013-05-16T15:17:07-06:00",
 "id": 60,
 "name": "Frozen Prepared Food",
 "region_id": 1,
 "updated_at": "2013-05-16T15:17:07-06:00"
 },
 {
 "active": true,
 "created_at": "2013-05-16T15:17:07-06:00",
 "id": 61,
 "name": "Fresh Prepared Food",
 "region_id": 1,
 "updated_at": "2013-05-16T15:17:07-06:00"
 },
 {
 "active": true,
 "created_at": "2013-05-16T15:17:07-06:00",
 "id": 63,
 "name": "Dairy",
 "region_id": 1,
 "updated_at": "2013-05-16T15:17:07-06:00"
 },
 {
 "active": true,
 "created_at": "2014-11-14T18:25:08-07:00",
 "id": 98,
 "name": "Packaged or Bulk Foods",
 "region_id": 1,
 "updated_at": "2014-11-14T18:25:08-07:00"
 }
 ]*/

/*
 [
 {
 "active": true,
 "created_at": "2014-04-08T20:41:21-06:00",
 "id": 30,
 "name": "Bathroom Scale",
 "region_id": 1,
 "updated_at": "2014-04-08T20:41:21-06:00",
 "weight_unit": "lb"
 },
 {
 "active": true,
 "created_at": "2014-04-08T20:41:21-06:00",
 "id": 31,
 "name": "Floor Scale",
 "region_id": 1,
 "updated_at": "2014-04-08T20:41:21-06:00",
 "weight_unit": "lb"
 },
 {
 "active": true,
 "created_at": "2014-04-08T20:41:21-06:00",
 "id": 32,
 "name": "Guesstimate",
 "region_id": 1,
 "updated_at": "2014-04-08T20:41:21-06:00",
 "weight_unit": "lb"
 }
 ]
 */
- (IBAction)submitButtonPressed:(id)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSArray* typeIDs = @[@98, @63, @61, @60, @59, @58];
    for (int i = 0; i<self.textFields.count; i++){
        UITextField *field = self.textFields[i];
        if (field.text && field.text.length > 0 && ![[f numberFromString:field.text] isEqualToNumber:@0] ){
            FoodType *type = [FoodType new];
            type.foodTypeId = typeIDs[i];
//            NSNumber *n = [f numberFromString:field.text];
//            if (n){
                [self.log addQuantity:field.text OfType:type];
//            }
        }
    }
    
    [self.log addWeighMethod:@(self.methodSelector.selectedSegmentIndex+30)];
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
