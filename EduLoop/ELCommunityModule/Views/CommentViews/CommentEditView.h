//
//  CommentEditView.h
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CommentEditViewDelegate<NSObject>
-(void)textView:(UITextView *)textView finalText:(NSString *)text;
@end

@interface CommentEditView : UIView

@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
//@property(nonatomic,strong,readwrite) UITextField *detailTextfield;
@property(nonatomic,strong,readwrite) UITextView *detailTextView;
@property(nonatomic,strong,readwrite) UIButton *finishBtn;
@property(nonatomic,weak,readwrite) id<CommentEditViewDelegate> delegate;
+(CommentEditView *)sharedManager;
- (void)resumeInputArea;
- (void)expandInputArea;
@end

NS_ASSUME_NONNULL_END
