//
//  ELFloatingButton.m
//  EduLoop
//
//  Created by mijika on 2020/12/15.
//

#import "ELFloatingButton.h"
#import <Masonry/Masonry.h>
#import "UIColor+EHTheme.h"
@implementation ELFloatingButton
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImage = image;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self insertSubview:self.shadow atIndex:0];
    [self.shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.shadow addSubview:self.aButton];
    [self.aButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
}
#pragma mark - Views
- (UIView *)shadow{
    if(!_shadow){
        _shadow = [UIView new];
        _shadow.backgroundColor = [UIColor color5bb2ff];
        _shadow.layer.shadowOpacity = 1;
        _shadow.layer.cornerRadius = self.bounds.size.width/2;
        _shadow.layer.masksToBounds = YES;
        _shadow.layer.shadowOffset = CGSizeMake(50,50);
        _shadow.layer.shadowRadius = 50;
        _shadow.layer.shadowColor = [UIColor color5bb2ff].CGColor;
        [_shadow addGestureRecognizer: ({
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFloatingBtn)];
            recognizer;
        })];
    }
    return _shadow;
}

- (UIButton *)aButton{
    if(!_aButton){
        _aButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _aButton.backgroundColor = [UIColor color5bb2ff];
        [_aButton setImage:self.iconImage forState:UIControlStateNormal];
        _aButton.imageView.contentMode = UIViewContentModeScaleToFill;
        [_aButton addTarget:self action:@selector(clickFloatingBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aButton;
}

-(void)clickFloatingBtn{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickFloatingButton)]){
        [self.delegate clickFloatingButton];
    }
}
@end
