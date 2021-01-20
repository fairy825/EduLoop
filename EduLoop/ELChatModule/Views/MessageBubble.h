//
//  MessageBubble.h
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageBubble : UIView

@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UILabel *messageLabel;
@property(nonatomic,readwrite) BOOL isLeft;
@end

NS_ASSUME_NONNULL_END
