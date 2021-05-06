//
//  CommentEditView.m
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import "CommentEditView.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELScreen.h"
@implementation CommentEditView
+(CommentEditView *)sharedManager{
    static CommentEditView* manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[CommentEditView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    });
    return manager;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor f6f6f6].CGColor;
    self.layer.borderWidth = 5;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.avatarImage.layer.cornerRadius = 20;
    self.avatarImage.layer.masksToBounds = YES;
    
    [self.bgView addSubview:self.detailTextView];
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.avatarImage);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.right.equalTo(self.bgView);
    }];
    
}

- (void)expandInputArea{
    [self.bgView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarImage);
        make.height.equalTo(@30);
        make.width.equalTo(@50);
        make.right.equalTo(self.bgView);
    }];
    
    [self.detailTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.bgView);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.right.equalTo(self.finishBtn.mas_left).offset(-10);
    }];
}

- (void)resumeInputArea{
    [self.finishBtn removeFromSuperview];
    
    [self.detailTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.avatarImage);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.right.equalTo(self.bgView);
    }];
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
        [_finishBtn setTitleColor:[UIColor color999999] forState:UIControlStateNormal];
        [_finishBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:16]];
        [_finishBtn addTarget:self action:@selector(editFinish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _avatarImage.image = [UIImage imageNamed:@"avatar-4"];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImage;
}

//- (UITextField *)detailTextfield{
//    if(!_detailTextfield){
//        self.detailTextfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//            self.detailTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
//            self.detailTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
//            self.detailTextfield.textAlignment = NSTextAlignmentLeft;
//        self.detailTextfield.backgroundColor = [UIColor eh_colorWithHex:EHThemeColor_CellHighlightedColor andAlpha:0.5];
//        self.detailTextfield.textColor = [UIColor color999999];
//        self.detailTextfield.font = [UIFont eh_regularWithSize:16];
//        self.detailTextfield.placeholder = @"点击发表我的观点";
//        self.detailTextfield.borderStyle = UITextBorderStyleRoundedRect;
//    }
//    return _detailTextfield;
//}

-(UITextView *)detailTextView{
    if(!_detailTextView){
        _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _detailTextView.layer.cornerRadius =15;
        _detailTextView.backgroundColor = [UIColor elColorWithHex:Color_CellHighlightedColor andAlpha:0.5];
        _detailTextView.textColor = [UIColor color999999];
        _detailTextView.textAlignment = NSTextAlignmentLeft;
        _detailTextView.font = [UIFont systemFontOfSize:16];

    }
    return _detailTextView;
}

- (void)editFinish{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(textView:finalText:)]){
        [self.delegate textView:self finalText:self.detailTextView.text];
    }
}

-(void)toggleState:(BOOL)canPublish{
    if(canPublish==YES){
        [self.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.finishBtn.backgroundColor = [UIColor color5bb2ff];
    }else{
        [self.finishBtn setTitleColor:[UIColor color999999] forState:UIControlStateNormal];
        self.finishBtn.backgroundColor = [UIColor clearColor];
    }
}


@end
