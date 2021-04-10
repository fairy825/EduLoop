//
//  ChatAllViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "ChatAllViewController.h"

#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "MessageSummaryCardTableViewCell.h"
#import "ChatDetailViewController.h"
#import "AddressListViewController.h"

@interface ChatAllViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChatAllViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self loadData];
    [self setupSubviews];
}

- (void)setNavagationBar{
    self.tabBarController.navigationItem.title = @"消息";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_address_list"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAddressList)];
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}

- (void)loadData{
    _models = @[].mutableCopy;
    
    [_models addObject:({
        ChatAllModel *model = [ChatAllModel new];
        ContactPersonModel *personModel = [ContactPersonModel new];
        personModel.name = @"陈老师";
        personModel.avatar = @"icon_teacher";
        model.personModel = personModel;
        model.dateStr = @"刚刚";
        model.unreadNum = 1;
        model.messageStr = @"你好，孩子最近成绩下降了，方便聊一下吗？";
        model;
    })];
    [_models addObject:({
        ChatAllModel *model = [ChatAllModel new];
        ContactPersonModel *personModel = [ContactPersonModel new];
        personModel.name = @"王老师";
        personModel.avatar = @"avatar-4";
        model.personModel = personModel;
        model.dateStr = @"3天前";
        model.unreadNum = 0;
        model.messageStr = @"孩子最近表现不错，家长可以适当表扬鼓励一下哦";
        model;
    })];
    
}

- (void)showDefaultView{
    if(self.models.count==0){
        [self.view addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200, 230));
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
           make.height.equalTo(@0);
        }];

    }
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
        
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
       
    }];
    [self showDefaultView];
}

- (void)jumpToAddressList{
    [self.navigationController pushViewController:[[AddressListViewController alloc]init] animated:YES];
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [UIView new];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"sample-1"];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.clipsToBounds = YES;
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:@"PingFangSC" size:18.f];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"还没有收到过聊天消息哦";
        [label sizeToFit];
        [_defaultView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_defaultView);
            make.centerX.equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        [_defaultView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(imgView);
        }];
    }
    return _defaultView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    ChatAllModel *data = [_models objectAtIndex:idx];
    NSString *id =@"MessageSummaryCardTableViewCell";
    MessageSummaryCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[MessageSummaryCardTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
    }
    cell.data = data;
    [cell loadData];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = [indexPath row];
        [self.models removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self showDefaultView];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    ChatAllModel *data = [_models objectAtIndex:idx];
    data.unreadNum = 0;
    [self pushToDetailPageWithData:data];
}

- (void)pushToDetailPageWithData:(ChatAllModel *)data{
    [self.navigationController pushViewController:[[ChatDetailViewController alloc]initWithModel:data.personModel] animated:YES];
}

#pragma mark - MessageSummaryCardTableViewCellDelegate
//-(void)clickCommentButtonTableViewCell:(UITableViewCell *)tableViewCell{
//    NSInteger idx = [[self.tableView indexPathForCell:tableViewCell]row];
//    UgcModel *data = [_models objectAtIndex:idx];
//    [self pushToDetailPageWithData:data];
//}
//
//- (void)clickTrashButtonTableViewCell:(UITableViewCell *)tableViewCell{
//        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
//        centerOverlayModel.title = @"确认删除此动态吗？";
//        centerOverlayModel.subTitle = @"删除后不可恢复";
//        centerOverlayModel.leftChoice = ({
//            ELOverlayItem *sureItem =[ELOverlayItem new];
//            sureItem.title = @"确认";
//            __weak typeof(self) wself = self;
//            sureItem.clickBlock = ^{
//                __strong typeof(self) sself = wself;
//                NSIndexPath *index = [sself.tableView indexPathForCell:tableViewCell];
//                [sself.models removeObjectAtIndex:[index row]];
//                [sself.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            };
//            sureItem;
//        });
//        ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
//        ];
//
//        [deleteAlertView showHighlightView];
//}

@end
