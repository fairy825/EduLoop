//
//  TestViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/17.
//

#import "TestViewController.h"
#import <PGDatePicker/PGDatePickManager.h>
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"date" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Bold" size:20]];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;
}
-(void)push{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyleAlertTopButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.showUnit = PGShowUnitTypeNone;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.datePickerMode = PGDatePickerModeYear;
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
NSLog(@"dateComponents = %@", dateComponents);
}
@end
