//
//  ELSocketManager.h
//  EduLoop
//
//  Created by mijika on 2021/4/28.
//
#import <Foundation/Foundation.h>
#import <SRWebSocket.h>
#import "DataContent.h"
#import "ChatHistory.h"
#import "ChatMsg.h"
#import "ChatSnapshot.h"
#import "ChatMsgModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ELSocketManagerDelegate<NSObject>
-(void)ws:(SRWebSocket *)webSocket didReceive:(id)msg;
-(void)wsdidOpen:(SRWebSocket *)webSocket;
@end

@interface ELSocketManager : NSObject
@property(nonatomic,weak,readwrite) id<ELSocketManagerDelegate> delegate;

+ (ELSocketManager *)sharedManager;
- (void)initSocket;
- (void)chat:(DataContent *)msg;
- (void)rechat:(DataContent *)msg;
//- (void)saveChatHistory:(NSString *)msg MyId:(NSInteger)myId FriendId:(NSInteger)friendId FromMe:(BOOL)flag;
- (void)saveChatHistory:(ChatMsg *)msg MyId:(NSInteger)myId FriendId:(NSInteger)friendId FromMe:(BOOL)flag;
- (NSMutableArray <ChatHistory *>*)getChatHistoryWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId;
- (void)deleteChatHistoryWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId;
//- (void)saveChatSnapshot:(NSString *)msg MyId:(NSInteger)myId FriendId:(NSInteger)friendId isRead:(BOOL)flag createTime:(NSString *)createTime;
- (void)saveChatSnapshot:(ChatMsg *)chatMsg MyId:(NSInteger)myId FriendId:(NSInteger)friendId isRead:(BOOL)flag;

- (NSMutableArray <ChatSnapshot *>*)getChatSnapshotWithMyId:(NSInteger)myId;
- (void)deleteChatSnapshotWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId;
- (void)readChatSnapshotWithMyId:(NSInteger)myId FriendId:(NSInteger)friendId;
-(void)signMsgList:(NSArray<ChatMsgModel *>*)msgs;
@end

NS_ASSUME_NONNULL_END
