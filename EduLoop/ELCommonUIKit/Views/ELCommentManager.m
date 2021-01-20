//
//  ELCommentManager.m
//  EduLoop
//
//  Created by mijika on 2020/12/28.
//

#import "ELCommentManager.h"
#import "ELScreen.h"
@interface ELCommentManager()<UITextViewDelegate>
@end
@implementation ELCommentManager
+(ELCommentManager *)sharedManager{
    static ELCommentManager* manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[ELCommentManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    _backgroundView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapBg)];
    [_backgroundView addGestureRecognizer:tap];
    [_backgroundView addSubview:({
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, _backgroundView.bounds.size.height, SCREEN_WIDTH, 100)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textView.layer.borderWidth = 5;
        _textView;
    })];

    }
    //键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_doTextViewShow:) name:UIKeyboardWillChangeFrameNotification object:nil ];
    return self;

}

- (void)_doTextViewShow:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(keyboardFrame.origin.y >= 896){
        //收回
        [UIView animateWithDuration:duration animations:^{
                    self.textView.frame = CGRectMake(0, _backgroundView.bounds.size.height, SCREEN_WIDTH, 100);
        }];
    }else{
        //展开
        self.textView.frame = CGRectMake(0, _backgroundView.bounds.size.height, SCREEN_WIDTH, 100);

        [UIView animateWithDuration:duration animations:^{
                    self.textView.frame = CGRectMake(0, _backgroundView.bounds.size.height-keyboardFrame.size.height-100, SCREEN_WIDTH, 100);
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showCommentView{
    [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
    [_textView becomeFirstResponder];
}

- (void)_tapBg{
    [_textView resignFirstResponder];
    [_backgroundView removeFromSuperview];
}
@end
