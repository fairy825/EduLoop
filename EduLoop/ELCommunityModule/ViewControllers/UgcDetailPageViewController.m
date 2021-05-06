//
//  UgcDetailPageViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import "UgcDetailPageViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "UgcVoteCard.h"
#import "UgcTextImgCard.h"
#import "CommentCard.h"
#import "ELScreen.h"
#import "ELNetworkSessionManager.h"
#import <MJRefresh.h>
#import "BasicInfo.h"
#import "GetOneMomentsResponse.h"
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import "PublishCommentResponse.h"
@interface UgcDetailPageViewController ()<UITableViewDelegate,UITableViewDataSource,ChatBoardDelegate,CommentCardDelegate,UITextViewDelegate>

@end

@implementation UgcDetailPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (instancetype)initWithModel:(MomentsModel *)model
{
    self = [super init];
    if (self) {
        _ugcModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    [self loadData];

    //键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil ];
    //键盘收回监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)endRefresh{
    if (self.page == 1) {
           [self.commentTableView.mj_header endRefreshing];
    }
    [self.commentTableView.mj_footer endRefreshing];
}

- (void)getOneMomentsNetworkWithId:(NSInteger)momentsId isRefresh:(BOOL) isRefresh{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", start],@"size":[NSString stringWithFormat:@"%d", size]
    };
    [manager GET:[BasicInfo url:@"/moments" path:[NSString stringWithFormat:@"%ld",momentsId]] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [self.commentModels removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetOneMomentsResponse *model =[[GetOneMomentsResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.comments.total){
                [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [self.commentModels removeAllObjects];
            }
            [self.commentModels addObjectsFromArray: model.data.comments.rows];
            self.ugcModel = model.data;
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        self.summaryUgcCard.data = self.ugcModel;
        [self.summaryUgcCard reload];
        [self.commentTableView reloadData];
        self.commentNumLabel.text = [NSString stringWithFormat:@"%@%@%ld%@", @"评论 ",@"(",(long)self.commentModels.count,@")" ];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

- (void)loadData{
    _commentModels = @[].mutableCopy;
    [self getOneMomentsNetworkWithId:self.ugcModel.id isRefresh:YES];
}

- (void)setupSubviews{
//    [self.view addSubview:self.summaryUgcCard];
//    [self.summaryUgcCard mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.height.equalTo(@250);
//    }];
    self.commentTableView = [[UITableView alloc]init];
//    self.commentTableView.backgroundColor = [UIColor f6f6f6];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.commentTableView setTableHeaderView:
        ({
            UIView *header = [[UIView alloc]init];
            [header addSubview:self.summaryUgcCard];
        [self.summaryUgcCard mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
        }];
        [header addSubview:self.commentNumLabel];
        [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.summaryUgcCard.mas_bottom).offset(20);
            make.bottom.equalTo(header);
            make.left.equalTo(header).offset(20);
            make.height.equalTo(@30);
        }];
        [header layoutIfNeeded];
        UgcTextImgCard *card = (UgcTextImgCard *)self.summaryUgcCard;
        [card layoutIfNeeded];
        CGFloat a = card.imgStackView.frame.size.height;
        CGFloat b = card.detailLabel.frame.size.height;
        
        CGFloat h=180+a+b;
        if(self.ugcModel.imgs.count>0) h+=10;
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
        /**self.summaryUgcCard.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.summaryUgcCard.frame.size.height);
            
        [header addSubview:self.commentNumLabel];
        self.commentNumLabel.frame = CGRectMake(20, self.summaryUgcCard.frame.origin.y+self.summaryUgcCard.frame.size.height+20, 100, 30);

        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.summaryUgcCard.frame.size.height+50);*/
        
            header;
        })];
    UgcTextImgCard *card = (UgcTextImgCard *)self.summaryUgcCard;
    card.detailLabel.numberOfLines = 0;
    CGFloat height = [self.commentTableView.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    CGRect headerFrame = self.commentTableView.tableHeaderView.frame;
    headerFrame.size.height= height;
    self.commentTableView.tableHeaderView.frame= headerFrame;
    [self.commentTableView reloadData];
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 100.0;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     
     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self getOneMomentsNetworkWithId:self.ugcModel.id isRefresh:NO];
     }];
     footer.stateLabel.font = [UIFont systemFontOfSize:15];
     [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
     [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
     [footer setTitle:@"" forState:MJRefreshStateIdle];
     self.commentTableView.mj_footer = footer;

    [self.view addSubview:self.commentTableView];
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
    }];
    [self clickOutsideCommentEditView];
    
    [self.view addSubview:self.chatBoard];
//    [self.chatBoard mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.commentTableView.mas_bottom);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//    }];
}
- (UILabel *)commentNumLabel{
    if(!_commentNumLabel){
        _commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
        _commentNumLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _commentNumLabel.textColor = [UIColor blackColor];
        _commentNumLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _commentNumLabel;
}

- (ChatBoard *)chatBoard{
    if(!_chatBoard){
        _chatBoard = [ChatBoard sharedManager:CGRectMake(0, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-60, self.view.bounds.size.width, 60)];
        _chatBoard.textView.delegate = self;
        _chatBoard.delegate = self;
    }
    return _chatBoard;
}
//- (CommentEditView *)commentEditView{
//    if(!_commentEditView){
//        _commentEditView = [CommentEditView sharedManager];
//        _commentEditView.detailTextView.delegate = self;
//        _commentEditView.delegate = self;
//    }
//    return _commentEditView;
//}

- (UgcCard *)summaryUgcCard{
    if(!_summaryUgcCard){
//        if(self.ugcModel.ugcType==UgcType_vote)
//            _summaryUgcCard = [[UgcVoteCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250) Data:self.ugcModel];
//        else
            _summaryUgcCard = [[UgcTextImgCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250) Data:self.ugcModel];
        [_summaryUgcCard reload];
        [_summaryUgcCard hideBtns];
    }
    //确定size
    return _summaryUgcCard;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentModels.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    UgcCard *summaryUgcCard = [[UgcVoteCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250) Data:self.ugcModel];
//    UIView *header = [UIView new];
//    [header addSubview:self.summaryUgcCard];
//    [self.summaryUgcCard mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(header);
//        make.left.equalTo(header);
//        make.right.equalTo(header);
//        make.height.equalTo(@250);
//    }];
//
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
//    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
//    label.text = [NSString stringWithFormat:@"%@%@%ld%@", @"评论 ",@"(",(long)self.ugcModel.commentNum,@")" ];
//    label.textColor = [UIColor blackColor];
//    label.textAlignment = NSTextAlignmentLeft;
//
//    [header addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.summaryUgcCard.mas_bottom).offset(20);
//        make.left.equalTo(header).offset(20);
//        make.right.equalTo(header).offset(-20);
//        make.height.equalTo(@30);
//    }];
//    return header;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 300;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    CommentModel *data = [_commentModels objectAtIndex:idx];
    NSString *id =@"CommentCard";
    CommentCard *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[CommentCard alloc]                    initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
    }
    cell.data = data;
    cell.delegate = self;
    [cell loadData];
    return cell;
}
- (void)clickCommentCard:(CommentCard *)card{
    NSIndexPath *indexPath = [self.commentTableView indexPathForCell:card];
    CommentModel *comment = card.data;
    NSMutableArray<ELOverlayItem *> *arr = [[NSMutableArray alloc]init];
    [arr addObject:({
            ELOverlayItem *item = [ELOverlayItem new];
            item.title =@"回复";
            __weak typeof(self) wself = self;
            item.clickBlock=^{
                __strong typeof(self) sself = wself;
                [sself.chatBoard.textView becomeFirstResponder];
                sself.chatBoard.commentMode = YES;
                sself.commentId = comment.id;
            };
            item;
    })];
    if(comment.profileId==[ELUserInfo sharedUser].id){
        [arr addObject:({
                    ELOverlayItem *item = [ELOverlayItem new];
                    __weak typeof(self) wself = self;
                    item.title =@"删除";
                    item.clickBlock=^{
                        __strong typeof(self) sself = wself;
                        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
                        centerOverlayModel.title = @"确认删除该评论？";
                        centerOverlayModel.leftChoice = ({
                            ELOverlayItem *sureItem =[ELOverlayItem new];
                            sureItem.title = @"确认";
                            __weak typeof(self) wwself = sself;
                            sureItem.clickBlock = ^{
                                __strong typeof(self) ssself = wwself;
                                [ssself deleteCommentNetworkWithId:comment.id Success:^{
                                    [ssself.commentModels removeObject:comment];
                                    [ssself.commentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                    ssself.commentNumLabel.text = [NSString stringWithFormat:@"%@%@%ld%@", @"评论 ",@"(",(long)ssself.commentModels.count,@")" ];
                                    ssself.ugcModel.commentNum--;
                                    [ssself.summaryUgcCard reload];

                                }];

                            };
                            sureItem;
                        });
                        ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
                        ];
                        
                        [deleteAlertView showHighlightView];
                    };
                    item;
        })];
    }
    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:arr];
    [overlay showHighlightView];
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 256;
//}

#pragma mark - CommentCardDelegate
- (void)clickThumbCommentCard:(CommentCard *)card{
    CommentModel *comment = card.data;
    NSInteger cid = comment.id;
    if(comment.myThumb==YES){
        [self dethumbCommentNetworkWithId:cid Success:^{
            [card toggleThumb];
        }];
    }else{
        [self thumbCommentNetworkWithId:cid Success:^{
            [card toggleThumb];
        }];
    }
}

-(void)thumbCommentNetworkWithId:(NSInteger)commentId Success:(nullable void (^)())succes{
    [BasicInfo POST:[BasicInfo url:@"/comment/thumb/" path:[NSString stringWithFormat:@"%ld",commentId]] parameters:nil success:succes];
}

-(void)dethumbCommentNetworkWithId:(NSInteger)commentId Success:(nullable void (^)())succes{
    [BasicInfo DELETE:[BasicInfo url:@"/comment/thumb/" path:[NSString stringWithFormat:@"%ld",commentId]] success:succes];
}

-(void)deleteCommentNetworkWithId:(NSInteger)commentId Success:(nullable void (^)())success{
    [BasicInfo DELETE:[BasicInfo url:@"/comment" path:[NSString stringWithFormat:@"%ld",commentId]] success:success];
}

#pragma mark - ChatBoardDelegate
- (void)textView:(UITextView *)textView finalText:(NSString *)text{
    NSLog(@"%@", [NSString stringWithFormat:@"%@", text]);
    if(self.chatBoard.commentMode==YES)
        [self postCommentOfCommentNetworkWithId:self.commentId];
    else [self postCommentOfMomentsNetwork];
    //清空文本框和按钮样式
    textView.text = @"";
    [self pageResize:textView];
}

-(void)dismissKeyboard{
    [self.view endEditing:YES];
//    [self.textView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self pageResize:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self dismissKeyboard];
        return NO;
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)pageResize:(UITextView *)textView{
    CGRect frame = _chatBoard.textView.frame;
    CGFloat curHeight = _chatBoard.textView.contentSize.height;
    CGRect boardFrame = _chatBoard.frame;
    if(curHeight>136){
        curHeight=136;
    }
    if(curHeight!=frame.size.height){
        boardFrame.origin.y-=(curHeight-frame.size.height);
        boardFrame.size.height = curHeight+20;
        _chatBoard.frame = boardFrame;
        [_chatBoard resize];
        self.commentTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.chatBoard.frame.origin.y);
    }
    if(textView.text.length>0){
        [self.chatBoard toggleState:YES];
    }else{
        [self.chatBoard toggleState:NO];
    }
}

-(void)postCommentOfMomentsNetwork{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    NSDictionary *params = @{
        @"content":self.chatBoard.textView.text
    };
    [manager POST:[NSString stringWithFormat:@"%@%ld%@", [BasicInfo url:@"/moments/"],self.ugcModel.id, @"/comment"] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{//login
            PublishCommentResponse *resp = [[PublishCommentResponse alloc]initWithDictionary:responseObject error:nil];
            CommentModel *comment = resp.data;
            [self.commentModels addObject:comment];
            [self.commentTableView reloadData];
            self.commentNumLabel.text = [NSString stringWithFormat:@"%@%@%ld%@", @"评论 ",@"(",(long)self.commentModels.count,@")" ];
            self.ugcModel.commentNum++;
            [self.summaryUgcCard reload];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
    
}

-(void)postCommentOfCommentNetworkWithId:(NSInteger)cid{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    NSDictionary *params = @{
        @"content":self.chatBoard.textView.text
    };
    [manager POST: [BasicInfo url:@"/comment" path:[NSString stringWithFormat:@"%ld",cid]] parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{//login
            PublishCommentResponse *resp = [[PublishCommentResponse alloc]initWithDictionary:responseObject error:nil];
            CommentModel *comment = resp.data;
            [self.commentModels addObject:comment];
            [self.commentTableView reloadData];
            self.commentNumLabel.text = [NSString stringWithFormat:@"%@%@%ld%@", @"评论 ",@"(",(long)self.commentModels.count,@")" ];
            self.ugcModel.commentNum++;
            [self.summaryUgcCard reload];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
    
}

#pragma mark - Keyboard
//键盘弹出时会调用
-(void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的基本信息
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = rect.size.height;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = self.chatBoard.frame.size.height;
    CGFloat offset = keyboardHeight+height;

    [UIView animateWithDuration:duration animations:^{
        self.chatBoard.frame = CGRectMake(0.0f, self.view.bounds.size.height-offset, self.chatBoard.frame.size.width, height);
        self.commentTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-offset);
        [self scrollToDown];
//        self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88-offset);
//
//        self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];

    } completion:nil];
}

- (void)scrollToDown{
    if(self.commentTableView.contentSize.height>self.commentTableView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.commentTableView.contentSize.height -self.commentTableView.frame.size.height);
        [self.commentTableView setContentOffset:offset animated:YES];
    }
}
 
//键盘收回时会调用
-(void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];

    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = self.chatBoard.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        
        self.chatBoard.frame = CGRectMake(0.0f, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-height, self.chatBoard.frame.size.width, height);
        self.commentTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.chatBoard.frame.origin.y);

//        CGFloat imgWidth = (self.view.bounds.size.width-40-15*2)/3;
//        CGFloat bgHeight = self.view.bounds.size.height-88-34-height;
//        CGFloat offset = bgHeight;
//        if([self.data.imgs count]>0){
//            offset=bgHeight-(imgWidth+10);
//        }
//
//        self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width,bgHeight);
//        self.textView.frame = [self.view convertRect:CGRectInset(CGRectMake(0, 88, self.view.bounds.size.width, offset), 20, 20) toView:self.bgView];
    } completion:nil];
}

- (void)clickOutsideCommentEditView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.summaryUgcCard addGestureRecognizer:tap];
    [self.commentTableView addGestureRecognizer:tap];
}

@end
