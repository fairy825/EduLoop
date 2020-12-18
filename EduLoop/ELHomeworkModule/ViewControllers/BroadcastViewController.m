//
//  BroadcastViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "BroadcastViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import <PGDatePicker/PGDatePickManager.h>
#import "HomeworkModel.h"
#import "HomeworkShowViewController.h"
#import "ELBottomStackOverlay.h"
@interface BroadcastViewController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>

@end

@implementation BroadcastViewController

- (instancetype)initWithHomeworkData:(HomeworkModel *)data
{
    self = [super init];
    if (self) {
        [self loadData:data];
    }
    return self;
}

- (void)loadData:(HomeworkModel *)data{
    _models = @[].mutableCopy;
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"作业名称";
        model.detailText = data?data.title:[[NSString alloc] initWithFormat:@"%@%@", [self todayString], @"作业"];
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_BigTextField;
        model.title =@"作业内容";
        model.detailText = data?data.detail:@"";
        model.detailDefaultText = @"请输入内容";
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Switch;
        model.title =@"在线提交";
        model.switchOpen = data.submitOnline;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"班级";
        model.clickBlock=^{
            NSDictionary *dic = @{ @"key1":@[@"one",@"1"], @"key2":@[@"two"]};
            NSArray *array = @[@"key1",@"key2"];
            ELBottomStackOverlay *overlay = [[ELBottomStackOverlay alloc]initWithFrame:self.view.bounds Data:dic SubTitles:array];
            [overlay showHighlightView];
        };
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"截止时间";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
        model.detailText = [dateFormat stringFromDate:[self defaultEndTime]];
        
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself pushDatePicker];
        };
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Switch;
        model.title =@"允许补交";
        model.switchOpen = data.allowSubmitAfter;
        model;
    })];
}

-(void)pushDatePicker{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyleAlertTopButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    [datePicker setDate:[self defaultEndTime]];
    datePicker.showUnit = PGShowUnitTypeNone;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData:nil];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
}
- (void)setNavagationBar{
    [self setTitle:@"作业"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(publishHomework)];
 
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.height.equalTo(@516);
        }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0) return 2;
    else return 4;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @" ";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        NSUInteger idx = [indexPath section]*2+[indexPath row];
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:self.models[idx]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        view.backgroundColor = [UIColor eh_f6f6f6];
        return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
       return 20;
    }
   return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath section]*2+[indexPath row];
    if(self.models[row].accessoryType==SettingTableViewCellType_BigTextField)
        return 216;
    return 56;
}

#pragma mark - action
- (void)publishHomework{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)todayString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    return currentDateStr;
}

- (NSDate *)defaultEndTime{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:currentDate];
    NSInteger y = [components year]; // year
    NSInteger m = [components month]; // month
    NSInteger d = [components day]; // day
    NSInteger h = [components hour]; // hour
    NSDate *endDate;
    if(h>21){
        endDate = [NSDate setYear:y month:m day:d+1 hour:22 minute:0];
    }else{
        endDate = [NSDate setYear:y month:m day:d hour:22 minute:0];
    }
    return endDate;
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    [_models objectAtIndex:4].detailText = [dateFormat stringFromDate:[NSDate dateFromComponents:dateComponents]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
