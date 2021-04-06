//
//  ReviewViewController.m
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import "ReviewViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
#import "ELScreen.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "ELFormat.h"
#import "GetOneHomeworkResponse.h"
@interface ReviewViewController ()<UIScrollViewDelegate,ReviewCardDelegate,ELBottomViewDelegate>

@end

@implementation ReviewViewController
- (instancetype)initWithHomeworkModel:(HomeworkModel *)model
{
    self = [super init];
    if (self) {
        _homework = model;
        _review = model.reviewVO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavagationBar];
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


-(void)setNavagationBar{
    [self setTitle:@"教师点评"];
}

-(void)setupSubviews{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator=YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.homeworkCard];
    [self.homeworkCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.scrollView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.scrollView.mas_safeAreaLayoutGuideRight);
    }];
    
    [self.scrollView addSubview:self.separateView];
    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.homeworkCard.mas_bottom);
        make.height.equalTo(@20);
        make.left.equalTo(self.homeworkCard);
        make.right.equalTo(self.homeworkCard);
    }];
    [self.scrollView addSubview:self.reviewCard];
    [self.reviewCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separateView.mas_bottom);
        make.left.equalTo(self.homeworkCard);
        make.right.equalTo(self.homeworkCard);
    }];
    [self.scrollView addSubview:self.reviewBtn];
    [self.reviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.bottom.equalTo(self.scrollView.mas_safeAreaLayoutGuideBottom).offset(-10);
        make.left.equalTo(self.homeworkCard).offset(20);
        make.right.equalTo(self.homeworkCard).offset(-20);
    }];
    
}

-(void)loadData{
    [self.homeworkCard loadData:_homework];
    if(_review==nil){
        self.reviewCard.alpha=0;
        self.reviewBtn.alpha=1;
    }else{
        self.reviewBtn.alpha=0;
        self.reviewCard.alpha=1;
        [self.reviewCard loadData:_review];
    }
    CGFloat hi = 0;
    for(UIView *sub in [_scrollView subviews]){
        hi+=sub.frame.size.height;
    }
    [self.scrollView layoutIfNeeded];
    CGFloat h = 0;
    for(UIView *sub in [_scrollView subviews]){
        h+=sub.frame.size.height;
    }
    self.scrollView.contentSize =  CGSizeMake(self.view.bounds.size.width,h);
//
//    [self showReviewEditViewWithScore:[NSNumber numberWithInteger: reviewCard.data.score] Detail:reviewCard.data.detail];
    if(_review){
        NSLog(@"1");
    }else{
        NSLog(@"2");
    }
    self.scoreField.text = [ELFormat stringFromNSNumber:_review?[NSNumber numberWithInteger: _review.score]:nil];
    self.detailTextView.text = [ELFormat safeString:_review?_review.detail:nil];
}

- (UIButton *)reviewBtn{
    if(!_reviewBtn){
        _reviewBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _reviewBtn.backgroundColor = [UIColor color5bb2ff];
        [_reviewBtn setTitle:@"点评" forState:UIControlStateNormal];
        [_reviewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reviewBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
        _reviewBtn.layer.cornerRadius = 20;
        _reviewBtn.layer.masksToBounds = NO;
        _reviewBtn.layer.shadowColor = [UIColor grayColor].CGColor;
        _reviewBtn.layer.shadowOffset = CGSizeMake(5,5);
        _reviewBtn.layer.shadowOpacity = 0.7;
        _reviewBtn.layer.shadowRadius = 10;
        
        [_reviewBtn addTarget:self action:@selector(showReviewEditView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reviewBtn;
}

- (HomeworkCard *)homeworkCard{
    if(!_homeworkCard){
        _homeworkCard = [[HomeworkCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    }
    return _homeworkCard;
}

- (UIView *)separateView{
    if(!_separateView){
        _separateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 3)];
        _separateView.backgroundColor = [UIColor f6f6f6];
    }
    return _separateView;
}

- (ReviewCard *)reviewCard{
    if(!_reviewCard){
        _reviewCard = [[ReviewCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
        _reviewCard.delegate = self;
    }
    return _reviewCard;
}

- (UITextField *)scoreField{
    if(!_scoreField){
        _scoreField = [[UITextField alloc]initWithFrame:CGRectMake(80, 20, 60, 30)];
        _scoreField.keyboardType = UIKeyboardTypeNumberPad;
        _scoreField.textAlignment = NSTextAlignmentRight;
        _scoreField.backgroundColor = [UIColor clearColor];
        _scoreField.textColor = [UIColor color999999];
        _scoreField.font = [UIFont systemFontOfSize:18];
        _scoreField.borderStyle = UITextBorderStyleRoundedRect;
        _scoreField.layer.borderWidth = 0.5;
        _scoreField.layer.borderColor = [UIColor color999999].CGColor;
    }
    return _scoreField;
}

- (UITextView *)detailTextView{
    if(!_detailTextView){
        _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 90, self.view.bounds.size.width-40, 100)];
        _detailTextView.textAlignment = NSTextAlignmentLeft;
        _detailTextView.textColor = [UIColor color333333];
        _detailTextView.font = [UIFont systemFontOfSize:18];
        _detailTextView.layer.cornerRadius = 5;
        _detailTextView.layer.borderWidth = 0.5;
        _detailTextView.layer.borderColor = [UIColor color999999].CGColor;
    }
    return _detailTextView;
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
    CGFloat height = self.editView.frame.size.height;
    CGFloat offset = keyboardHeight+height;

    [UIView animateWithDuration:duration animations:^{
        self.editView.frame = CGRectMake(0.0f, self.view.bounds.size.height-offset-HOME_BUTTON_HEIGHT, self.editView.frame.size.width, height);

    } completion:nil];
}

 
//键盘收回时会调用
-(void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];

    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = self.editView.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.editView.frame = CGRectMake(0.0f, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-height, self.editView.frame.size.width, height);
    } completion:nil];
}

- (void)showReviewEditView{
    [self.editView showHighlightView];

//    [self showReviewEditViewWithScore:nil Detail:nil];
}

- (ELBottomView *)editView{
    if(!_editView){
        _editView = [[ELBottomView alloc]init];
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,SCREEN_HEIGHT/3)];
        contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *scoreLabel = [[UILabel alloc]init];
        scoreLabel.text = @"分数";
        scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        scoreLabel.textColor = [UIColor color333333];
        [scoreLabel sizeToFit];
        scoreLabel.frame = CGRectMake(20, 20, 60, 20);
        [contentView addSubview:scoreLabel];
        [contentView addSubview:self.scoreField];
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.text = @"评语";
        contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        contentLabel.textColor = [UIColor color333333];
        [contentLabel sizeToFit];
        contentLabel.frame = CGRectMake(20, 60, 60, 20);
        [contentView addSubview:contentLabel];
        [contentView addSubview:self.detailTextView];
        
        [_editView.rightButton setTitle:@"发送" forState:UIControlStateNormal];
        _editView.contentView = contentView;
        _editView.delegate = self;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
        [_editView addGestureRecognizer:recognizer];
    }
    return _editView;
}

-(void)dismissKeyboard{
    [self.editView endEditing:YES];
}

- (void)showReviewEditViewWithScore:(NSNumber *)score Detail:(NSString *)content{
    [self.editView showHighlightView];
}

#pragma mark ReviewCardDelegate
- (void)clickUpdateBtn:(ReviewCard *)reviewCard{
    [self.editView showHighlightView];
//
//    [self showReviewEditViewWithScore:[NSNumber numberWithInteger: reviewCard.data.score] Detail:reviewCard.data.detail];
}

#pragma mark ELBottomViewDelegate
- (void)clickRightLabel{
    if(_scoreField.text.length==0){
        [BasicInfo showToastWithMsg:@"分数不能为空"];
        return;
    }else if([ELFormat isNumber:_scoreField.text]==NO){
        [BasicInfo showToastWithMsg:@"分数必须为数字"];
        return;
    }
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    if(_review==nil){
        NSDictionary *paramDict =  @{
            @"homeworkId":[NSNumber numberWithInteger:_homework.id],
            @"score": [f numberFromString:_scoreField.text],
            @"detail": _detailTextView.text
        };
        [BasicInfo POST:[BasicInfo url:@"/homework/review"] parameters:paramDict success:^{
            [self reload];
        }];
    }else{
        NSDictionary *paramDict =  @{
            @"score": [f numberFromString:_scoreField.text],
            @"detail": _detailTextView.text
        };
        [BasicInfo PUT:[BasicInfo url:@"/homework/review" path:[ELFormat stringFromNSInteger:_review.id]] parameters:paramDict success:^{
            [self reload];
        }];
    }
}


#pragma mark - network
- (void)reload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[BasicInfo url:@"/homework" path:[NSString stringWithFormat:@"%ld",(long)_homework.id]] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetOneHomeworkResponse *resp = [[GetOneHomeworkResponse alloc]initWithDictionary:responseObject error:nil];
            
            self->_homework = resp.data;
            self->_review = resp.data.reviewVO;
            [self loadData];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}
@end
