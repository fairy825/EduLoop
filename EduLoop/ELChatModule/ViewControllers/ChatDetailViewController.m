//
//  ChatDetailViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//
#import "ChatDetailViewController.h"
#import "UIColor+MyTheme.h"
#import "MessageBubble.h"
#import "MessageRecordTableViewCell.h"
#import "ELScreen.h"
#import "ELUserInfo.h"
#import <SocketRocket/SRWebSocket.h>
#import "BasicInfo.h"
#import "ELSocketManager.h"
#import "ELFormat.h"
@interface ChatDetailViewController ()<ChatBoardDelegate,UITextViewDelegate,UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic,strong) SRWebSocket *webSocket;
@end

@implementation ChatDetailViewController
static NSInteger interval = 300;
- (instancetype)initWithModel:(ContactPersonModel *)personModel{
    self = [super init];
    if (self) {
        _personModel = personModel;
        _messages = @[].mutableCopy;
        _timeTitles = @[].mutableCopy;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self initChatHistory];
    [self loadSectionContent];
    [self.tableView reloadData];
    [self scrollToDown];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavagationBar];
//    [self loadData];
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
    [self setTitle:self.personModel.nickname];
}

- (void)setupSubviews{
    [self.view addSubview:self.chatBoard];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT, self.view.bounds.size.width, self.chatBoard.frame.origin.y-(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
       //设置分割线(设置为无样式)
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 75.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor whiteColor];

}

- (ChatBoard *)chatBoard{
    if(!_chatBoard){
        _chatBoard = [ChatBoard sharedManager:CGRectMake(0, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-60, self.view.bounds.size.width, 60)];
        _chatBoard.textView.delegate = self;
        _chatBoard.delegate = self;
    }
    return _chatBoard;
}


-(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

-(NSDate *)dateFromString:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

-(void)loadSectionContent{
    int k=0;
    if(self.models.count>0){
        MessageModel *model = self.models[0];
        [self.timeTitles addObject:[self dateFromString:model.dateStr]];
        NSMutableArray *sortArray = [[NSMutableArray array]init];
        [sortArray addObject:model];
        [self.messages addObject:sortArray];
    }
    for(int i=1;i<self.models.count;i++){
        MessageModel *model = self.models[i];
        NSDate *date = [self dateFromString:model.dateStr];
        if(date.timeIntervalSince1970-self.timeTitles[k].timeIntervalSince1970<interval){
            [self.messages[k] addObject:model];
        }else{
            [self.timeTitles addObject:date];
            NSMutableArray *sortArray = [[NSMutableArray array]init];
            [sortArray addObject:model];
            [self.messages addObject:sortArray];
            k++;
        }
    }
}

-(void)initChatHistory{
    ELSocketManager *manager = [ELSocketManager sharedManager];
    NSMutableArray <ChatHistory *>*list = [manager getChatHistoryWithMyId:[ELUserInfo sharedUser].id FriendId:self.personModel.id.integerValue];
    NSMutableArray<MessageModel *>*ms = [[NSMutableArray alloc]init];

    for(ChatHistory *his in list){
        [ms addObject:({
            [self fromChatHistory:his];
        })];
    }
    self.models = ms;
}

- (MessageModel *)fromChatHistory:(ChatHistory *)his{
    MessageModel *model = [MessageModel new];
    model.messageStr = his.chatMsg.msg;
    model.dateStr = [his.chatMsg.createTime substringToIndex:his.chatMsg.createTime.length-3];

    if(his.flag.boolValue==YES){
        model.fromId = his.myId.integerValue;
        model.toId = his.friendId.integerValue;
        model.avatar = [ELUserInfo sharedUser].faceImage;
    }else{
        model.fromId = his.friendId.integerValue;
        model.toId = his.myId.integerValue;
        model.avatar = self.personModel.avatar;
    }
    model.isRead = YES;
    return model;
}

#pragma mark - ChatBoardDelegate
- (void)textView:(UITextView *)textView finalText:(NSString *)text{
    ChatMsg *chatMsg = [ChatMsg new];
    chatMsg.msg = text;
    chatMsg.senderId = [ELUserInfo sharedUser].id;
    chatMsg.receiverId = self.personModel.id.integerValue;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//    dateFormat.timeZone
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    chatMsg.createTime = currentDateStr;
    //消息渲染
    [self sendMsg:chatMsg];
    //清空文本框和按钮样式
    textView.text = @"";
    [self pageResize:textView];
    //发送消息到netty
    DataContent *dataContent = [DataContent new];
    dataContent.chatMsg = chatMsg;
    dataContent.action = CHAT;
    ELSocketManager *manager = [ELSocketManager sharedManager];
    [manager chat:dataContent];
    //保存聊天记录到本地缓存
    [manager saveChatHistory:chatMsg MyId:[ELUserInfo sharedUser].id FriendId:self.personModel.id.integerValue FromMe:YES];
    //保存聊天快照到本地缓存
//    [manager saveChatSnapshot:text MyId:[ELUserInfo sharedUser].id FriendId:self.personModel.id.integerValue isRead:YES createTime:currentDateStr];
    [manager saveChatSnapshot:chatMsg MyId:[ELUserInfo sharedUser].id FriendId:self.personModel.id.integerValue isRead:YES];
}

- (void)sendMsg:(ChatMsg *)chatMsg{
    NSString *msg = chatMsg.msg;
    NSLog(@"%@", [NSString stringWithFormat:@"%@", msg]);
    if(msg.length==0)
        return;
    [_models addObject:({
        MessageModel *model = [MessageModel new];
        model.fromId = chatMsg.senderId;
        model.toId = chatMsg.receiverId;
        model.avatar = [ELUserInfo sharedUser].faceImage;
        model.isRead=YES;
        model.dateStr = [self stringFromDate: [NSDate now]];
        model.messageStr = msg;
        model;
    })];
    [self scrollPage];
}

- (void)receiveMsg:(id)message{
    DataContent *dataContent = [[DataContent alloc]initWithString:message error:nil];
    ChatMsg *chatMsg = dataContent.chatMsg;
    NSString *msg = chatMsg.msg;
    [_models addObject:({
        MessageModel *model = [MessageModel new];
        model.fromId = chatMsg.senderId;
        model.toId = chatMsg.receiverId;
        model.avatar = self.personModel.avatar;
        model.isRead=YES;
        model.dateStr = chatMsg.createTime;
        model.messageStr = msg;
        model;
    })];
    [self scrollPage];
}

- (void)scrollPage{
    MessageModel *model = [self.models lastObject];
    NSDate *date = [self dateFromString:model.dateStr];
    if(date.timeIntervalSince1970-[self.timeTitles lastObject].timeIntervalSince1970<interval){
        [[self.messages lastObject] addObject:model];
    }else{
        [self.timeTitles addObject:date];
        NSMutableArray *sortArray = [[NSMutableArray array]init];
        [sortArray addObject:model];
        [self.messages addObject:sortArray];
    }
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages lastObject].count-1 inSection:self.timeTitles.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)scrollToDown{
    if(self.tableView.contentSize.height>self.tableView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height -self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
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
        [self scrollToDown];
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
    if(curHeight>136){
        curHeight=136;
    }
    if(curHeight!=frame.size.height){
        boardFrame.origin.y-=(curHeight-frame.size.height);
        boardFrame.size.height = curHeight+20;
        _chatBoard.frame = boardFrame;
        [_chatBoard resize];
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.chatBoard.frame.origin.y);
    }
    if(textView.text.length>0){
        [self.chatBoard toggleState:YES];
    }else{
        [self.chatBoard toggleState:NO];
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

- (NSString *)getTimeDesc:(NSString *)dateStr{
    NSDate *date = [self dateFromString:dateStr];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *compoents = [currentCalendar components:units fromDate:[NSDate now]];
    
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[compoents year]];
    [resultComps setMonth:[compoents month]];
    [resultComps setDay:[compoents day]];
    NSCalendar *todayCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [todayCalendar dateFromComponents:resultComps];
    NSDate *yesterday = [[NSDate alloc]initWithTimeIntervalSince1970: today.timeIntervalSince1970-24*60*60];
    NSString *result;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if(date.timeIntervalSince1970>=yesterday.timeIntervalSince1970){
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:date];
        if(date.timeIntervalSince1970<today.timeIntervalSince1970){
            result = [NSString stringWithFormat:@"%@%@",@"昨天 ",result];
        }
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        result = [dateFormatter stringFromDate:date];
    }
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.timeTitles.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC" size:12.f];
    timeLabel.textColor = [UIColor color999999];
    NSString *str = [self stringFromDate: self.timeTitles[section]];
    timeLabel.text = [self getTimeDesc:str];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [timeLabel sizeToFit];
    return timeLabel;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 20;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages[section].count;
}

//设置单元格高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //将NSNumber型的height转换为CGFloat型
////    CGFloat height = [_rowHeightArr[indexPath.row] floatValue];
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *messageModel = [self.messages[indexPath.section] objectAtIndex:indexPath.row];
    
    static NSString *id = @"MessageRecordTableViewCell";
    MessageRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if(!cell){
        cell = [[MessageRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id frame:self.view.bounds data:messageModel];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [[cell.contentView.subviews lastObject] performSelector:@selector(removeFromSuperview)];
        }
    }
    cell.messageModel = messageModel;
    [cell loadData];
    return cell;
}

@end
