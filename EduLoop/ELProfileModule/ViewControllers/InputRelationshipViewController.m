//
//  InputRelationshipViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import "InputRelationshipViewController.h"
#import "BasicInfo.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import <AFNetworking.h>
#import "ELOverlay.h"
#import <TZImagePickerController.h>
#import "ELNetworkSessionManager.h"
#import "SettingDataTableViewCell.h"
@interface InputRelationshipViewController ()<UITableViewDelegate,UITableViewDataSource,ELBottomSelectOverlayDelegate>

@end

@implementation InputRelationshipViewController

- (instancetype)initWithStudent:(NSInteger)studentId
{
    self = [super init];
    if (self) {
        _studentId = studentId;
        _relationshipIndex = -1;
    }
    return self;
}
-(void)bindStudentNetworkWithSuccess:(nullable void (^)())success{
    NSDictionary *paramDict =  @{
        @"studentId":[NSNumber numberWithInteger: self.studentId],
        @"relationship":[[self array] objectAtIndex:_relationshipIndex]
    };
    [BasicInfo POST: [BasicInfo url:@"/student/bind"] parameters:paramDict success:success];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadData{
    _models = @[].mutableCopy;
   
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Text;
        model.showArrow = YES;
        model.title =@"关系";
        _overlay = [[ELBottomSelectOverlay alloc]initWithFrame:self.view.bounds Title:@"关系"];
        _overlay.subTitles = [self array];
        _overlay.delegate = self;
        [_overlay reload];
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.overlay showHighlightView];
        };
        model;
    })];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
    [self loadData];
}

- (void)setNavagationBar{
    [self setTitle:@"绑定学生"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishPublish)];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:tapGesture];    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//            make.height.equalTo(@516);
        }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    SettingDataModel *model = self.models[idx];
    if (!cell) {
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
    }
    cell.data = model;
    [cell loadData];
    return cell;
}

#pragma mark - keyboard
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (NSArray <NSString *>*)array{
    return  @[@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"阿姨",@"叔叔",@"其他"];
}
#pragma mark - ELBottomSelectOverlayDelegate
-(void)ELBottomSelectOverlay:(ELBottomSelectOverlay*)overlay singleUpdateChosedTeams:(int)idx Add:(BOOL)isAdd{
    NSString *str;
    NSInteger k;
    if(isAdd){
        k = idx;
        str = [[self array] objectAtIndex:idx];
    }else{
        k = -1;
        str = @"";
    }
    _relationshipIndex = k;
    [self.models objectAtIndex:0].detailText = str;
    [self.tableView reloadData];
}
#pragma mark - action
- (BOOL)canFinish{
    NSString *str;
    if(_relationshipIndex==-1){
       str =@"未选择与孩子之间的关系";
    }else{
       return YES;
   }
    [BasicInfo showToastWithMsg:str];
    return NO;
}

- (void)finishPublish{
    if([self canFinish]){
        [self bindStudentNetworkWithSuccess:^{
            [BasicInfo showToastWithMsg:@"绑定成功"];
            NSArray <UIViewController *>*vcs =self.navigationController.viewControllers;
            [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-3] animated:YES];
        }];
    }
}

@end


