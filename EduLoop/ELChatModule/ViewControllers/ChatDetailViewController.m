//
//  ChatDetailViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//
#import "ChatDetailViewController.h"
#import "UIColor+EHTheme.h"
#import "MessageBubble.h"
#import "MessageRecordTableViewCell.h"
#import "ELScreen.h"
@interface ChatDetailViewController ()<ChatBoardDelegate,UITextViewDelegate,UITableViewDelegate,
UITableViewDataSource>

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
    self.view.backgroundColor = [UIColor whiteColor];
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
    _models = @[].mutableCopy;

    [_models addObject:({
        MessageModel *model = [MessageModel new];
        model.fromName = @"陈老师";
        model.toName = @"dd";
        model.avatar = @"avatar";
        model.isRead=YES;
        model.dateStr = @"刚刚";
        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
        model;
    })];
    [_models addObject:({
        MessageModel *model = [MessageModel new];
        model.fromName = @"dd";
        model.toName = @"陈老师";
        model.avatar = @"avatar";
        model.isRead=YES;
        model.dateStr = @"刚刚";
        model.messageStr = @"hi";
        model;
    })];
    
}

- (void)setupSubviews{
    [self.view addSubview:self.chatBoard];
    self.chatBoard.frame = CGRectMake(0, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-60, self.view.bounds.size.width, 60);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.chatBoard.frame.origin.y) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
       //设置分割线(设置为无样式)
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.showsVerticalScrollIndicator = NO;
       [self.view addSubview:self.tableView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
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
    if(text.length==0)
        return;
    [_models addObject:({
        MessageModel *model = [MessageModel new];
        model.fromName = @"dd";
        model.toName = @"陈老师";
        model.avatar = @"avatar";
        model.isRead=YES;
        model.dateStr = @"刚刚";
        model.messageStr = text;
        model;
    })];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_models.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadData];
    //滚动界面（随着消息发送上移）
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    textView.text = @"";
    [self pageResize:textView];
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
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height-offset);

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
        self.chatBoard.frame = CGRectMake(0.0f, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-height, self.chatBoard.frame.size.width, height);
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.chatBoard.frame.origin.y);

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
    [self pageResize:textView];
}

- (void)pageResize:(UITextView *)textView{
    CGRect frame = _chatBoard.textView.frame;
    CGFloat curHeight = _chatBoard.textView.contentSize.height;
    CGRect boardFrame = _chatBoard.frame;
    if(curHeight<=136&&curHeight!=frame.size.height){
        boardFrame.origin.y-=(curHeight-frame.size.height);
        boardFrame.size.height = curHeight+20;
        _chatBoard.frame = boardFrame;
        [_chatBoard resize];
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.chatBoard.frame.origin.y);
    }
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

//设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //将NSNumber型的height转换为CGFloat型
//    CGFloat height = [_rowHeightArr[indexPath.row] floatValue];
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *messageModel = [_models objectAtIndex:indexPath.row];
    
    static NSString *id = @"MessageRecordTableViewCell";
    MessageRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if(!cell){
        cell = [[MessageRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id frame:self.view.bounds data:messageModel];
    }
//    else {
//        //tableView的复用，如果不删除，会出现bug
//        //删除cell所有的子视图
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    
    cell.messageModel = messageModel;
    [cell loadData];
    return cell;
    return cell;
}

@end
