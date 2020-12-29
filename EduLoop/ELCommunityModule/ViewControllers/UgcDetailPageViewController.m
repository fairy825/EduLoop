//
//  UgcDetailPageViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import "UgcDetailPageViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "UgcVoteCard.h"
#import "UgcTextImgCard.h"
#import "CommentCard.h"

@interface UgcDetailPageViewController ()<UITableViewDelegate,UITableViewDataSource,CommentEditViewDelegate>

@end

@implementation UgcDetailPageViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (instancetype)initWithModel:(UgcModel *)model
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
    [self loadData];
    [self setupSubviews];
    
       //键盘弹出监听
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil ];
       //键盘收回监听
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData{
    _commentModels = @[].mutableCopy;
    
    [_commentModels addObject:({
        CommentModel *model = [CommentModel new];
        model.authorName = @"abc";
        model.detail =@"我认为有必要";
        model.thumbNum = 4;
        model.dateStr = @"刚刚";
        model.hasClickedThumb = YES;
        model.chooseFirst = YES;
        model.choiceStr = @"有必要";
        model;
    })];
    [_commentModels addObject:({
        CommentModel *model = [CommentModel new];
        model.authorName = @"abc";
        model.detail =@"我认为没有必要";
        model.thumbNum = 3;
        model.dateStr = @"刚刚";
        model.hasClickedThumb = NO;
        model.chooseFirst = NO;
        model.choiceStr = @"没必要";
        model;
    })];
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
//    self.commentTableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
//    self.commentTableView.estimatedRowHeight = 44.0;
//    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.commentTableView];
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
    }];
    [self clickOutsideCommentEditView];
    
    [self.view addSubview:self.commentEditView];
    [self.commentEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTableView.mas_bottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}
- (CommentEditView *)commentEditView{
    if(!_commentEditView){
        _commentEditView = [CommentEditView sharedManager];
        _commentEditView.detailTextView.delegate = self;
        _commentEditView.delegate = self;
    }
    return _commentEditView;
}
- (UgcCard *)summaryUgcCard{
    if(!_summaryUgcCard){
        if(self.ugcModel.ugcType==UgcType_vote)
            _summaryUgcCard = [[UgcVoteCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250) Data:self.ugcModel];
        else
            _summaryUgcCard = [[UgcTextImgCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250) Data:self.ugcModel];
    }
    [_summaryUgcCard hideBtns];
    [_summaryUgcCard reload];
    return _summaryUgcCard;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentModels.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UgcCard *summaryUgcCard = [[UgcVoteCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250) Data:self.ugcModel];
    UIView *header = [UIView new];
    [header addSubview:self.summaryUgcCard];
    [self.summaryUgcCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header);
        make.left.equalTo(header);
        make.right.equalTo(header);
        make.height.equalTo(@250);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    label.text = [NSString stringWithFormat:@"%@%@%ld%@", @"评论 ",@"(",(long)self.ugcModel.commentNum,@")" ];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryUgcCard.mas_bottom).offset(20);
        make.left.equalTo(header).offset(20);
        make.right.equalTo(header).offset(-20);
        make.height.equalTo(@30);
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    CommentModel *data = [_commentModels objectAtIndex:idx];
    NSString *id =@"CommentCard";
    CommentCard *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[CommentCard alloc]                    initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 256;
}

#pragma mark - CommentEditViewDelegate
- (void)textView:(UITextView *)textView finalText:(NSString *)text{
    NSLog(@"%@", [NSString stringWithFormat:@"%@", text]);
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
      
    CGFloat currentHeight = 120;
    CGFloat offset = keyboardHeight;
    [UIView animateWithDuration:duration animations:^{
        [self.commentEditView expandInputArea];
        [self.commentEditView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentTableView.mas_bottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.height.equalTo([NSNumber numberWithFloat:currentHeight]);
        }];
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);

    } completion:nil];
}

 
//键盘收回时会调用
-(void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
 
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.commentEditView resumeInputArea];
        [self.commentEditView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentTableView.mas_bottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.height.equalTo(@60);
        }];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (void)clickOutsideCommentEditView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    [self.summaryUgcCard addGestureRecognizer:tap];
    [self.commentTableView addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.commentEditView.detailTextView resignFirstResponder];
}
@end
