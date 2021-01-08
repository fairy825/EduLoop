//
//  ChatDetailViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "ChatDetailViewController.h"
#import "UIColor+EHTheme.h"

@interface ChatDetailViewController ()<ChatBoardDelegate,UITextViewDelegate>

@end

@implementation ChatDetailViewController

- (instancetype)initWithModel:(ContactPersonModel *)personModel{
    self = [super init];
    if (self) {
        _personModel = personModel;
    }
    return self;
}

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
    //键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil ];
    //键盘收回监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavagationBar{
    [self setTitle:self.personModel.name];
}

- (void)loadData{
//    _models = @[].mutableCopy;
//
//    [_models addObject:({
//        ChatAllModel *model = [ChatAllModel new];
//        ContactPersonModel *personModel = [ContactPersonModel new];
//        personModel.name = @"陈老师";
//        personModel.avatar = @"avatar";
//        model.personModel = personModel;
//        model.dateStr = @"刚刚";
//        model.unreadNum = @"2";
//        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
//        model;
//    })];
//    [_models addObject:({
//        ChatAllModel *model = [ChatAllModel new];
//        ContactPersonModel *personModel = [ContactPersonModel new];
//        personModel.name = @"陈老师";
//        personModel.avatar = @"avatar";
//        model.personModel = personModel;
//        model.dateStr = @"刚刚";
//        model.unreadNum = @"2";
//        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
//        model;
//    })];
    
}

- (void)setupSubviews{
    [self.view addSubview:self.chatBoard];
    self.chatBoard.frame = CGRectMake(0, self.view.bounds.size.height-34-60, self.view.bounds.size.width, 60);
//    self.tableView = [[UITableView alloc]init];
//    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 60.0;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//
//    }];
}

- (ChatBoard *)chatBoard{
    if(!_chatBoard){
        _chatBoard = [ChatBoard sharedManager];
        _chatBoard.textView.delegate = self;
        _chatBoard.delegate = self;
    }
    return _chatBoard;
}


#pragma mark - ChatBoardDelegate
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
    CGFloat height = self.chatBoard.frame.size.height;
    CGFloat offset = keyboardHeight+height;

    [UIView animateWithDuration:duration animations:^{
        self.chatBoard.frame = CGRectMake(0.0f, self.view.bounds.size.height-offset, self.chatBoard.frame.size.width, height);
//        self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88-offset);
//
//        self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];

    } completion:nil];
}

 
//键盘收回时会调用
-(void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];

    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = self.chatBoard.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.chatBoard.frame = CGRectMake(0.0f, self.view.bounds.size.height-34-height, self.chatBoard.frame.size.width, height);
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

-(void)dismissKeyboard{
    [self.view endEditing:YES];
//    [self.textView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    CGRect frame = _chatBoard.textView.frame;
    CGFloat curHeight = _chatBoard.textView.contentSize.height;
    CGRect boardFrame = _chatBoard.frame;
    if(curHeight<=136&&curHeight!=frame.size.height){
        boardFrame.origin.y-=(curHeight-frame.size.height);
        boardFrame.size.height = curHeight+20;
        _chatBoard.frame = boardFrame;
        [_chatBoard resize];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}
@end
