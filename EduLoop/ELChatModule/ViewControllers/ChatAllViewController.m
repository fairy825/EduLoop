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
#import "ELSocketManager.h"
#import "ELUserInfo.h"
#import "ELNetworkSessionManager.h"
#import "BasicInfo.h"
#import "GetUnreadMsgResponse.h"

@interface ChatAllViewController ()<UITableViewDelegate,UITableViewDataSource,ELSocketManagerDelegate>

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
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    ELSocketManager *wsmanager = [ELSocketManager sharedManager];
    wsmanager.delegate = self;
    [wsmanager initSocket];
    [self setNavagationBar];
    [self setupSubviews];
}

- (void)setNavagationBar{
    self.tabBarController.navigationItem.title = @"消息";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_address_list"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAddressList)];
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}

- (void)loadData{
    _models = @[].mutableCopy;
    [self initChatSnapshot];
}

- (void)reloadDefaultView{
    if(self.models.count==0){
        self.defaultView.alpha=1;
    }else{
        self.defaultView.alpha=0;
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
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
}

- (void)jumpToAddressList{
    [self.navigationController pushViewController:[[AddressListViewController alloc]init] animated:YES];
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [UIView new];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"icon_chat_blue"];
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
            make.size.mas_equalTo(CGSizeMake(50, 50));
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
        ChatAllModel *model = self.models[index];
        [[ELSocketManager sharedManager]deleteChatHistoryWithMyId:[ELUserInfo sharedUser].id FriendId:model.personModel.id.integerValue];
        [[ELSocketManager sharedManager]deleteChatSnapshotWithMyId:[ELUserInfo sharedUser].id FriendId:model.personModel.id.integerValue];
        [self.models removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self reloadDefaultView];
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
    [[ELSocketManager sharedManager]readChatSnapshotWithMyId:[ELUserInfo sharedUser].id FriendId:data.personModel.id.integerValue];
}

-(void)getUnreadMessageNetwork{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET:
        [NSString stringWithFormat:@"%@%ld",[BasicInfo url:@"/getUnReadMsgList?acceptUserId="],[ELUserInfo sharedUser].id]
        parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                GetUnreadMsgResponse *resp = [[GetUnreadMsgResponse alloc]initWithDictionary:responseObject error:nil];
                NSArray <ChatMsgModel *>* msgs = resp.data;
                for(ChatMsgModel *model in msgs){
                    ChatMsg *chatMsg = [ChatMsg new];
                    chatMsg.createTime = model.createTime;
                    chatMsg.msg = model.msg;
                    chatMsg.msgId = model.id;
                    chatMsg.senderId = model.sendUserId;
                    chatMsg.receiverId = model.acceptUserId;
                    
                    [[ELSocketManager sharedManager] saveChatHistory:chatMsg MyId:[ELUserInfo sharedUser].id FriendId:model.sendUserId FromMe:NO];
//                    [[ELSocketManager sharedManager] saveChatSnapshot:msg MyId:model.acceptUserId FriendId:model.sendUserId isRead:NO createTime:model.createTime];
                    
                    [[ELSocketManager sharedManager]saveChatSnapshot:chatMsg MyId:chatMsg.receiverId FriendId:chatMsg.senderId isRead:NO];
                }
                [[ELSocketManager sharedManager] signMsgList:msgs];
                [self initChatSnapshot];
            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}
    
-(void)wsdidOpen:(SRWebSocket *)webSocket {
    [self getUnreadMessageNetwork];
}

- (void)ws:(SRWebSocket *)webSocket didReceive:(id)msg{
    
    NSArray< UIViewController *>*vcs = self.navigationController.viewControllers;
    UIViewController *vc = vcs[vcs.count-1];
    DataContent *dataContent = [[DataContent alloc]initWithString:msg error:nil];

    if([vc isKindOfClass:[ChatDetailViewController class]]){
//        [[ELSocketManager sharedManager] saveChatSnapshot:dataContent.chatMsg.msg MyId:[ELUserInfo sharedUser].id FriendId:dataContent.chatMsg.senderId isRead:YES createTime:dataContent.chatMsg.createTime];
        [[ELSocketManager sharedManager] saveChatSnapshot:dataContent.chatMsg MyId:[ELUserInfo sharedUser].id FriendId:dataContent.chatMsg.senderId isRead:YES];

        ChatDetailViewController *cvc = (ChatDetailViewController *)vc;
        [cvc receiveMsg:msg];
    }else{
//        [[ELSocketManager sharedManager] saveChatSnapshot:dataContent.chatMsg.msg MyId:[ELUserInfo sharedUser].id FriendId:dataContent.chatMsg.senderId isRead:NO createTime:dataContent.chatMsg.createTime];
        [[ELSocketManager sharedManager] saveChatSnapshot:dataContent.chatMsg MyId:[ELUserInfo sharedUser].id FriendId:dataContent.chatMsg.senderId isRead:NO];

        [self initChatSnapshot];
    }
}
    
- (void)initChatSnapshot{
    ELSocketManager *manager = [ELSocketManager sharedManager];
    NSMutableArray<ChatSnapshot *>*list = [manager getChatSnapshotWithMyId:[ELUserInfo sharedUser].id];
    NSMutableArray<ChatAllModel *>*models = [[NSMutableArray alloc]init];
    for(ChatSnapshot *cs in list){
        [models addObject:({
            [self fromChatSnapshot:cs];
        })];
    }
    self.models = models;
    [self.tableView reloadData];
    [self reloadDefaultView];
}

-(ChatAllModel *)fromChatSnapshot:(ChatSnapshot *)snapshot{
    ChatAllModel *model = [ChatAllModel new];
    if(snapshot.isRead.boolValue==YES)
        model.unreadNum=0;
    else model.unreadNum = snapshot.unreadNum.integerValue;
    model.messageStr=snapshot.chatMsg.msg;
    model.personModel = [self getFriendFromContacts: snapshot.friendId.integerValue];
    model.dateStr = snapshot.chatMsg.createTime;
    return model;
}

    
-(ContactPersonModel *)getFriendFromContacts:(NSInteger)fid{
    NSString *key = [NSString stringWithFormat:@"%@%ld",@"contacts-",[ELUserInfo sharedUser].id];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *contactsListStr = [userDefaults objectForKey:key];
    NSMutableArray <ContactPersonModel *>*contacts;
    if(contactsListStr.length!=0){
        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:contactsListStr];
        contacts = [NSMutableArray arrayWithArray:appArray];
        for(ContactPersonModel *p in contacts){
            if(p.id.integerValue==fid){
                return p;
            }
        }
    }
    return nil;
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
