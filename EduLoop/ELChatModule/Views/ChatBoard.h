//
//  ChatBoard.h
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChatBoardDelegate<NSObject>
-(void)textView:(UITextView *)textView finalText:(NSString *)text;
@end

@interface ChatBoard : UIView
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UITextView *textView;
@property(nonatomic,strong,readwrite) UIButton *finishBtn;
@property(nonatomic,weak,readwrite) id<ChatBoardDelegate> delegate;
@property(nonatomic,readwrite) BOOL commentMode;
+(ChatBoard *)sharedManager:(CGRect)frame;
-(void)resize;
- (void)toggleState:(BOOL)canPush;
@end

NS_ASSUME_NONNULL_END
