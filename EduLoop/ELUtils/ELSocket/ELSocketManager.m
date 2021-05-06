//
//  ELSocketManager.m
//  EduLoop
//
//  Created by mijika on 2021/4/28.
//

#import "ELSocketManager.h"
#import "BasicInfo.h"
#import "ELNetworkSessionManager.h"
#import "ELNetworkSessionManager.h"
#import "BasicInfo.h"
#import "GetUnreadMsgResponse.h"
@interface ELSocketManager ()<SRWebSocketDelegate>
@property(nonatomic,strong) SRWebSocket *webSocket;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation ELSocketManager
static ELSocketManager *instance;
static dispatch_once_t once;

+(ELSocketManager *)sharedManager{
    dispatch_once(&once, ^{
        if(instance==nil)
            instance = [[ELSocketManager alloc]init];
    });
    return instance;
}


- (void)initSocket{
    if(self.webSocket!=nil && self.webSocket.readyState == SR_OPEN){
        return ;
    }
    self.webSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: [BasicInfo wsAppendix]]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)chat:(DataContent *)msg{
    if(self.webSocket!=nil && self.webSocket.readyState == SR_OPEN){
        NSString *str = [msg toJSONString];
        [self.webSocket send:str];
    }else{
        //重连websocket
        [self initSocket];
        [self performSelector:@selector(rechat:) withObject:msg afterDelay:0.5];
    }
}

- (void)rechat:(DataContent *)msg{
    NSLog(@"socket-rechat");
    NSString *str = [msg toJSONString];
    [self.webSocket send:str];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"socket-open");
    //netty连接请求
    ChatMsg *chatMsg = [ChatMsg new];
    chatMsg.senderId = [ELUserInfo sharedUser].id;
    DataContent *dataContent = [DataContent new];
    dataContent.chatMsg = chatMsg;
    dataContent.action = CONNECT;
    [self chat:dataContent];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(wsdidOpen:)]){
        [self.delegate wsdidOpen:webSocket ];
    }
    //定时发送心跳
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(keepalive) userInfo:nil repeats:YES];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"socket-error");
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSLog(@"socket-pong");
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"%@%@",@"socket-message:",message);
    DataContent *dataContent = [[DataContent alloc]initWithString:message error:nil];
    //签收消息
    DataContent *signedDC = [DataContent new];
    signedDC.action = SIGNED;
    signedDC.extand = [NSString stringWithFormat:@"%ld", dataContent.chatMsg.msgId];
    ELSocketManager *manager = [ELSocketManager sharedManager];
    [manager chat:signedDC];
    //保存聊天记录到本地缓存
    [manager saveChatHistory:dataContent.chatMsg MyId:[ELUserInfo sharedUser].id FriendId:dataContent.chatMsg.senderId FromMe:NO];
    //保存聊天快照到本地缓存
//    [manager saveChatSnapshot:dataContent.chatMsg.msg MyId:[ELUserInfo sharedUser].id FriendId:dataContent.chatMsg.senderId isRead:YES];

    //渲染接收到的消息
    if(self.delegate&&[self.delegate respondsToSelector:@selector(ws:didReceive:)]){
        [self.delegate ws:webSocket didReceive:message];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"socket-close");
    [self.timer invalidate];
    self.timer = nil;

}
//
//- (void)saveChatHistory:(NSString *)msg MyId:(NSInteger)myId FriendId:(NSInteger)friendId FromMe:(BOOL)flag{
//    NSString *key = [NSString stringWithFormat:@"%@%ld%@%ld",@"chat-",myId,@"-",friendId];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *chatHistoryListStr = [userDefaults objectForKey:key];
//    NSMutableArray <ChatHistory *>*chatHistoryList;
//    if(chatHistoryListStr.length==0)
//        chatHistoryList = @[].mutableCopy;
//    else{
//        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatHistoryListStr];
//        chatHistoryList = [NSMutableArray arrayWithArray:appArray];
//    }
//    ChatHistory *history = [ChatHistory new];
//    history.msg = msg;
//    history.myId = [NSNumber numberWithInteger: myId];
//    history.friendId =[NSNumber numberWithInteger: friendId];
//    history.flag = [NSNumber numberWithBool: flag];
//    [chatHistoryList addObject:history];
//    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[chatHistoryList mutableCopy]];
//    [userDefaults setObject:jsonData forKey:key];
//    [userDefaults synchronize];
//}

- (void)saveChatHistory:(ChatMsg *)chatMsg MyId:(NSInteger)myId FriendId:(NSInteger)friendId FromMe:(BOOL)flag{
    NSString *key = [NSString stringWithFormat:@"%@%ld%@%ld",@"chat-",myId,@"-",friendId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *chatHistoryListStr = [userDefaults objectForKey:key];
    NSMutableArray <ChatHistory *>*chatHistoryList;
    if(chatHistoryListStr.length==0)
        chatHistoryList = @[].mutableCopy;
    else{
        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatHistoryListStr];
        chatHistoryList = [NSMutableArray arrayWithArray:appArray];
    }
    ChatHistory *history = [ChatHistory new];
    history.chatMsg = chatMsg;
    history.myId = [NSNumber numberWithInteger: myId];
    history.friendId =[NSNumber numberWithInteger: friendId];
    history.flag = [NSNumber numberWithBool: flag];
    
    [chatHistoryList addObject:history];
    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[chatHistoryList mutableCopy]];
    [userDefaults setObject:jsonData forKey:key];
    [userDefaults synchronize];
}

- (NSMutableArray <ChatHistory *>*)getChatHistoryWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId{
    NSString *key = [NSString stringWithFormat:@"%@%ld%@%ld",@"chat-",myId,@"-",friendId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *chatHistoryListStr = [userDefaults objectForKey:key];
    NSMutableArray <ChatHistory *>*chatHistoryList;
    if(chatHistoryListStr.length==0)
        chatHistoryList = @[].mutableCopy;
    else{
        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatHistoryListStr];
        chatHistoryList = [NSMutableArray arrayWithArray:appArray];
    }
    return chatHistoryList;
}

- (void)deleteChatHistoryWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId{
    NSString *key = [NSString stringWithFormat:@"%@%ld%@%ld",@"chat-",myId,@"-",friendId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:key];
    [userDefaults synchronize];
}

//- (void)saveChatSnapshot:(NSString *)msg MyId:(NSInteger)myId FriendId:(NSInteger)friendId isRead:(BOOL)flag createTime:(NSString *)createTime{
//    NSString *key = [NSString stringWithFormat:@"%@%ld",@"snapshot-",myId];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *chatSnapshotListStr = [userDefaults objectForKey:key];
//    NSInteger k = 0;
//    NSMutableArray <ChatSnapshot *>*chatSnapshotList;
//    if(chatSnapshotListStr.length==0)
//        chatSnapshotList = @[].mutableCopy;
//    else{
//        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatSnapshotListStr];
//        chatSnapshotList = [NSMutableArray arrayWithArray:appArray];
//        for(ChatSnapshot *ss in chatSnapshotList){
//            if(ss.friendId.integerValue== friendId){
//                k=ss.unreadNum.integerValue;
//                [chatSnapshotList removeObject:ss];
//                break;
//            }
//        }
//    }
//    ChatSnapshot *snapshot = [ChatSnapshot new];
//    snapshot.msg = msg;
//    snapshot.myId = [NSNumber numberWithInteger: myId];
//    snapshot.friendId =[NSNumber numberWithInteger: friendId];
//    snapshot.isRead = [NSNumber numberWithBool: flag];
//    snapshot.createTime = createTime;
//    if(flag==YES)
//        snapshot.unreadNum =[NSNumber numberWithInteger:0];
//    else snapshot.unreadNum =[NSNumber numberWithInteger:k+1];
//    [chatSnapshotList insertObject:snapshot atIndex:0];
//    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[chatSnapshotList mutableCopy]];
//    [userDefaults setObject:jsonData forKey:key];
//    [userDefaults synchronize];
//}
- (void)saveChatSnapshot:(ChatMsg *)chatMsg MyId:(NSInteger)myId FriendId:(NSInteger)friendId isRead:(BOOL)flag{
        NSString *key = [NSString stringWithFormat:@"%@%ld",@"snapshot-",myId];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *chatSnapshotListStr = [userDefaults objectForKey:key];
        NSInteger k = 0;
        NSMutableArray <ChatSnapshot *>*chatSnapshotList;
        if(chatSnapshotListStr.length==0)
            chatSnapshotList = @[].mutableCopy;
        else{
            NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatSnapshotListStr];
            chatSnapshotList = [NSMutableArray arrayWithArray:appArray];
            for(ChatSnapshot *ss in chatSnapshotList){
                if(ss.friendId.integerValue== friendId){
                    k=ss.unreadNum.integerValue;
                    [chatSnapshotList removeObject:ss];
                    break;
                }
            }
        }
        ChatSnapshot *snapshot = [ChatSnapshot new];
        snapshot.chatMsg = chatMsg;
        snapshot.myId = [NSNumber numberWithInteger: myId];
        snapshot.friendId =[NSNumber numberWithInteger: friendId];
        snapshot.isRead = [NSNumber numberWithBool: flag];
        if(flag==YES)
            snapshot.unreadNum =[NSNumber numberWithInteger:0];
        else snapshot.unreadNum =[NSNumber numberWithInteger:k+1];
        [chatSnapshotList insertObject:snapshot atIndex:0];
        NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[chatSnapshotList mutableCopy]];
        [userDefaults setObject:jsonData forKey:key];
        [userDefaults synchronize];
}
- (void)readChatSnapshotWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId{
    NSString *key = [NSString stringWithFormat:@"%@%ld",@"snapshot-",myId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *chatSnapshotListStr = [userDefaults objectForKey:key];
    NSMutableArray <ChatSnapshot *>*chatSnapshotList;
    if(chatSnapshotListStr.length!=0){
        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatSnapshotListStr];
        chatSnapshotList = [NSMutableArray arrayWithArray:appArray];
        NSInteger k=0;
        for(ChatSnapshot *ss in chatSnapshotList){
            if(ss.friendId.integerValue== friendId){
                ss.isRead = [NSNumber numberWithBool: YES];
                ss.unreadNum = [NSNumber numberWithInt:0];
                [chatSnapshotList replaceObjectAtIndex:k withObject:ss];
                break;
            }
            k++;
        }
    }
    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[chatSnapshotList mutableCopy]];
    [userDefaults setObject:jsonData forKey:key];
    [userDefaults synchronize];
}

- (NSMutableArray <ChatSnapshot *>*)getChatSnapshotWithMyId:(NSInteger)myId{
    NSString *key = [NSString stringWithFormat:@"%@%ld",@"snapshot-",myId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *chatSnapshotListStr = [userDefaults objectForKey:key];
    NSMutableArray <ChatSnapshot *>*chatSnapshotList;
    if(chatSnapshotListStr.length==0)
        chatSnapshotList = @[].mutableCopy;
    else{
        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatSnapshotListStr];
        chatSnapshotList = [NSMutableArray arrayWithArray:appArray];
    }
    return chatSnapshotList;
}

- (void)deleteChatSnapshotWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId{
    NSString *key = [NSString stringWithFormat:@"%@%ld",@"snapshot-",myId];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *chatSnapshotListStr = [userDefaults objectForKey:key];
    NSMutableArray <ChatSnapshot *>*chatSnapshotList;
    if(chatSnapshotListStr.length!=0){
        NSArray * appArray =  [NSKeyedUnarchiver unarchiveObjectWithData:chatSnapshotListStr];
        chatSnapshotList = [NSMutableArray arrayWithArray:appArray];
        for(ChatSnapshot *cs in chatSnapshotList){
            if(cs.friendId.integerValue==friendId){
                [chatSnapshotList removeObject:cs];
                break;
            }
        }
        NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[chatSnapshotList mutableCopy]];
        [userDefaults setObject:jsonData forKey:key];
        [userDefaults synchronize];
    }
}

-(void)signMsgList:(NSArray<ChatMsgModel *>*)msgs{
    if(msgs.count>0){
        NSString *extand = [NSString stringWithFormat:@"%ld", msgs[0].id ];
        for(int i=1;i<msgs.count;i++){
            extand = [NSString stringWithFormat:@"%@%@%ld",extand,@",",msgs[i].id];
        }
            
        DataContent *dataContent = [DataContent new];
        dataContent.action = SIGNED;
        dataContent.extand = extand;
        [self chat:dataContent];
    }
}

-(void)keepalive{
    DataContent *dataContent = [DataContent new];
    dataContent.action = KEEPALIVE;
    [self chat:dataContent];
}
@end
