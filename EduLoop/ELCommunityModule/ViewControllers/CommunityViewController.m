//
//  CommunityViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "CommunityViewController.h"
#import "UgcCard.h"
#import "UIColor+ELColor.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "UgcTextImgCard.h"
#import "UgcVoteCard.h"
#import "UgcCardTableViewCell.h"
#import "UgcDetailPageViewController.h"
#import "ELImageManager.h"
#import "UgcTextImgPublishViewController.h"
#import "UgcVotePublishViewController.h"
#import <MJRefresh.h>
#import "ELNetworkSessionManager.h"
#import "BasicInfo.h"
#import "GetMomentsResponse.h"
#import <RTRootNavigationController.h>
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,ELFloatingButtonDelegate,UgcCardDelegate>

@end

@implementation CommunityViewController
- (instancetype)initWithMode:(BOOL)isMine
{
    self = [super init];
    if (self) {
        _isMine = isMine;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    BOOL flag;
    if(self.isMine)
        flag = NO;
    else flag = YES;
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:flag animated:NO];
    [self loadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor elBackgroundColor];
    self.page=1;
    UIEdgeInsets insets = self.view.safeAreaInsets;
    [self setNavigation];
    [self setupSubviews];
//    [self loadData];
}

-(void)setNavigation{
    if(self.isMine)
        [self setTitle:@"我的动态"];
}

- (void)loadData{
    _models = @[].mutableCopy;
    [self getMomentsNetworkIsMine:self.isMine IsRefresh:YES];
    
}

- (void)endRefresh{
    if (self.page == 1) {
           [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
}

- (void)getMomentsNetworkIsMine:(BOOL) isMine IsRefresh:(BOOL)isRefresh{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    NSString *url;
    if(isMine==YES)
        url = @"/moments/mine";
    else url = @"/moments/discovery";
    [manager GET:[BasicInfo url:url Start:start AndSize:size] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [self.models removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetMomentsResponse *model =[[GetMomentsResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.total){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [self.models removeAllObjects];
            }
            [self.models addObjectsFromArray: model.data.rows];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        
        [self reloadDefaultView];
        [self.tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor elBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 244.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self getMomentsNetworkIsMine:self.isMine IsRefresh:YES];
     }];
     header.lastUpdatedTimeLabel.hidden = YES;
     //文字颜色
     header.stateLabel.textColor = [UIColor lightGrayColor];
     header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
     //字体
     header.stateLabel.font = [UIFont systemFontOfSize:15];
     header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
     //普通
     [header setTitle:@"" forState:MJRefreshStateIdle];
     //松开可以刷新
     [header setTitle:@"松开加载数据" forState:MJRefreshStatePulling];
     //正在刷新
     [header setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
     //文字慢慢的显现
     header.automaticallyChangeAlpha = YES;
     
     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self getMomentsNetworkIsMine:self.isMine IsRefresh:NO];
     }];
     footer.stateLabel.font = [UIFont systemFontOfSize:15];
     //正在刷新
     [header setTitle:@"" forState:MJRefreshStateIdle];
     [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
     [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
     [footer setTitle:@"" forState:MJRefreshStateIdle];
     self.tableView.mj_header = header;
     self.tableView.mj_footer = footer;

    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    
    [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-100);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
}

- (void)reloadDefaultView{
    if(self.models.count==0){
        self.defaultView.alpha=1;
    }else{
        self.defaultView.alpha=0;
    }
}

- (ELFloatingButton *)addBtn{
    if(!_addBtn){
        _addBtn = [[ELFloatingButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) Image: [UIImage imageNamed:@"icon_add"]];
        _addBtn.delegate = self;
    }
    return _addBtn;
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [UIView new];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"icon_empty"];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.clipsToBounds = YES;
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:@"PingFangSC" size:18.f];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"还没有发布过动态";
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
#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
    [self.navigationController  pushViewController:[[UgcTextImgPublishViewController alloc]init] animated:YES];
    /**
    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[
        ({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title = @"发送图文";
        __weak typeof(self) wself = self;
        item.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController pushViewController:[[UgcTextImgPublishViewController alloc]init] animated:YES];
        };
        item;
    }),({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title = @"发起讨论";
        __weak typeof(self) wself = self;
        item.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController pushViewController:[[UgcVotePublishViewController alloc]init] animated:YES];
        };
        item;
    })]];
    [overlay showHighlightView];
     */
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    MomentsModel *data = [_models objectAtIndex:idx];
    NSString *id =@"UgcCardTableViewCell";
    UgcCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[UgcCardTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    cell.ugcCard.delegate = self;
    [cell loadData:data];
//    [cell layoutIfNeeded];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 356;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    MomentsModel *data = [_models objectAtIndex:idx];
    [self pushToDetailPageWithData:data];

}
- (void)pushToDetailPageWithData:(MomentsModel *)data{
    
    [self.navigationController pushViewController:[[UgcDetailPageViewController alloc]initWithModel:data] animated:YES];
}

#pragma mark - UgcCardDelegate
-(void)clickThumbButtonTableViewCell:(UITableViewCell *)tableViewCell ugcTextImgCard:(UIView *)ugcTextImgCard{
    NSIndexPath *index = [self.tableView indexPathForCell:tableViewCell];
    MomentsModel *moments = self.models[[index row] ];
    NSInteger mid = moments.id;
    UgcCard *card = (UgcCard *)ugcTextImgCard;
    UgcTextImgCard *tiCard = (UgcTextImgCard *)ugcTextImgCard;
    if(card.data.myThumb==YES){
        [self dethumbMomentsNetworkWithId:mid Success:^{
            [tiCard toggleThumb];
        }];
    }else{
        [self thumbMomentsNetworkWithId:mid Success:^{
            [tiCard toggleThumb];
        }];
    }
}

-(void)clickCommentButtonTableViewCell:(UITableViewCell *)tableViewCell{
    NSInteger idx = [[self.tableView indexPathForCell:tableViewCell]row];
    MomentsModel *data = [_models objectAtIndex:idx];
    [self pushToDetailPageWithData:data];
}

- (void)clickTrashButtonTableViewCell:(UITableViewCell *)tableViewCell{
        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
        centerOverlayModel.title = @"确认删除此动态吗？";
        centerOverlayModel.subTitle = @"删除后不可恢复";
        centerOverlayModel.leftChoice = ({
            ELOverlayItem *sureItem =[ELOverlayItem new];
            sureItem.title = @"确认";
            __weak typeof(self) wself = self;
            sureItem.clickBlock = ^{
                __strong typeof(self) sself = wself;
                NSIndexPath *index = [sself.tableView indexPathForCell:tableViewCell];
                MomentsModel *moments = sself.models[[index row] ];
                [sself deleteMomentsNetworkWithId:moments.id Success:^{
                    [sself.models removeObject:moments];
                    [sself.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }];
            };
            sureItem;
        });
        ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
        ];
        
        [deleteAlertView showHighlightView];
}

- (void)clickPhoto:(NSString *)url TableViewCell:(UITableViewCell *)tableViewCell{
    [[ELImageManager sharedManager]showImageView:url];
}

-(void)deleteMomentsNetworkWithId:(NSInteger)momentsId Success:(nullable void (^)())success{
    [BasicInfo DELETE:[BasicInfo url:@"/moments" path:[NSString stringWithFormat:@"%ld",momentsId]] success:success];
}

-(void)thumbMomentsNetworkWithId:(NSInteger)momentsId Success:(nullable void (^)())succes{
    [BasicInfo POST:[BasicInfo url:@"/moments/thumb/" path:[NSString stringWithFormat:@"%ld",momentsId]] parameters:nil success:succes];
}

-(void)dethumbMomentsNetworkWithId:(NSInteger)momentsId Success:(nullable void (^)())succes{
    [BasicInfo DELETE:[BasicInfo url:@"/moments/thumb/" path:[NSString stringWithFormat:@"%ld",momentsId]] success:succes];
}
@end
