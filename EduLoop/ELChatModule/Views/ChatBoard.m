//
//  ChatBoard.m
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import "ChatBoard.h"
#import "UIColor+EHTheme.h"
#import "ELScreen.h"

@implementation ChatBoard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView{
//    self.chatBoard.frame = CGRectMake(0, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-60, self.view.bounds.size.width, 60);

    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor eh_f6f6f6].CGColor;
    self.layer.borderWidth = 5;
    CGSize board = self.frame.size;
    [self addSubview:self.bgView];
    self.bgView.frame = CGRectMake(20, 10, board.width-40, board.height-20);
   
    [self.bgView addSubview:self.textView];
    self.textView.frame = CGRectMake(0, 0, self.bgView.frame.size.width-70, self.bgView.frame.size.height);
   
    [self.bgView addSubview:self.finishBtn];
    self.finishBtn.frame = CGRectMake( self.textView.frame.origin.x+self.textView.frame.size.width+10, 0,60, self.bgView.frame.size.height);
}

-(void)resize{
    CGFloat textHeight = self.frame.size.height-20;
    if(self.textView.frame.size.height==textHeight)
        return;
    self.bgView.frame = CGRectMake(20, 10, self.frame.size.width-40, textHeight);
    self.textView.frame = CGRectMake(0, 0, self.bgView.frame.size.width-70, self.bgView.frame.size.height);
    self.finishBtn.frame = CGRectMake( self.textView.frame.origin.x+self.textView.frame.size.width+10, 0,60, self.bgView.frame.size.height);
}

#pragma mark - Views
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)finishBtn{
    if(!_finishBtn){
        _finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _finishBtn.backgroundColor = [UIColor clearColor];
        [_finishBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
        [_finishBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:16]];
        [_finishBtn addTarget:self action:@selector(editFinish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor eh_colorWithHex:EHThemeColor_CellHighlightedColor andAlpha:0.5];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = [UIColor eh_subtitleColor];
        _textView.layer.cornerRadius =15;
        _textView.font = [UIFont systemFontOfSize:20];
    }
    return _textView;
}

+(ChatBoard *)sharedManager:(CGRect) frame{
    static ChatBoard* manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[ChatBoard alloc]initWithFrame:frame];
    });
    return manager;
}

- (void)editFinish{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(textView:finalText:)]){
        [self.delegate textView:self.textView finalText:self.textView.text];
    }
}

@end
