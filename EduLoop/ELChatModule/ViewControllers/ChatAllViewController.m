//
//  ChatAllViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "ChatAllViewController.h"

#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "MessageSummaryCardTableViewCell.h"
#import "ChatDetailViewController.h"

@interface ChatAllViewController ()<UITableViewDelegate,UITableViewDataSource,MessageSummaryCardTableViewCellDelegate>

@end

@implementation ChatAllViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
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
        model.oppositeName = @"陈老师";
        model.dateStr = @"刚刚";
        model.avatar = @"avatar";
        model.unreadNum = @"2";
        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
        model;
    })];
    [_models addObject:({
        ChatAllModel *model = [ChatAllModel new];
        model.oppositeName = @"陈老师";
        model.dateStr = @"刚刚";
        model.avatar = @"avatar";
        model.unreadNum = @"2";
        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
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
    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
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
    [self.navigationController pushViewController:[[ChatDetailViewController alloc]init] animated:YES];
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
        cell.delegate = self;
    }
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
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    ChatAllModel *data = [_models objectAtIndex:idx];
    [self pushToDetailPageWithData:data];
}

- (void)pushToDetailPageWithData:(ChatAllModel *)data{
    [self.navigationController pushViewController:[[ChatDetailViewController alloc]initWithModel:data] animated:YES];
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
