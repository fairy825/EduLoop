//
//  UgcVotePublishViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/3.
//

#import "UgcVotePublishViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "SettingDataTableViewCell.h"
@interface UgcVotePublishViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@end

@implementation UgcVotePublishViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadData{
    _models = @[].mutableCopy;
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"讨论标题";
        model.detailDefaultText = @"请输入标题";
        model.maxLength = 12;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_BigTextField;
        model.showArrow = NO;
        model.title =@"具体描述";
        model.detailDefaultText = @"请输入具体描述";
        model.maxLength = 50;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Choices;
        model.title =@"讨论选项";
        model;
    })];
    
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"可见范围";
        model;
    })];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
    [self loadData];
}

- (void)setNavagationBar{
    [self setTitle:@"发起讨论"];
    NSLog(@"%@", self.navigationItem);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(publishUgc)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancel)];

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
    if(section==0) return 3;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        NSUInteger idx = [indexPath section]*3+[indexPath row];
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:self.models[idx]];
        cell.detailTextView.tag = 3000+idx;
        cell.detailTextfield.tag = 4000+idx;
        cell.detailTextView.delegate = self;
        cell.detailTextfield.delegate = self;
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
    NSUInteger row = [indexPath section]*3+[indexPath row];
    if(self.models[row].accessoryType==SettingTableViewCellType_BigTextField||self.models[row].accessoryType==SettingTableViewCellType_Choices)
        return 216;
    return 56;
}

#pragma mark - action
- (void)publishUgc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCancel{
    ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
    centerOverlayModel.title = @"确认退出？";
    centerOverlayModel.subTitle = @"退出后当前草稿不会保存";
    centerOverlayModel.leftChoice = ({
        ELOverlayItem *sureItem =[ELOverlayItem new];
        sureItem.title = @"确认";
        __weak typeof(self) wself = self;
        sureItem.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController popViewControllerAnimated:YES];
        };
        sureItem;
    });
    ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
    ];
    [deleteAlertView showHighlightView];
}

//- (void)textViewDidChange:(UITextView *)textView {
//    int len =10;
//    if (textView.text.length > len) {
//        textView.text = [textView.text substringWithRange:NSMakeRange(0, len)];
//    }
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int kLimitNumber = [self.models objectAtIndex:textField.tag-4000].maxLength;
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger res = kLimitNumber-[str length];
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int kLimitNumber = [self.models objectAtIndex:textView.tag-3000].maxLength;
    long t = textView.tag-3000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:t%3 inSection:t/3];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    SettingDataTableViewCell *scell = (SettingDataTableViewCell *)cell;
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger res = kLimitNumber-[str length];
    if(res >= 0){
        scell.detailTextViewLengthLabel.text = [NSString stringWithFormat:@"%ld/%d", (unsigned long)str.length, kLimitNumber];
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        scell.detailTextViewLengthLabel.text = [NSString stringWithFormat:@"%ld/%d", (unsigned long)kLimitNumber, kLimitNumber];
        return NO;
    }
}
@end
