//
//  ELPublishImage.m
//  EduLoop
//
//  Created by mijika on 2020/12/30.
//

#import "ELPublishImage.h"
#import "UIColor+EHTheme.h"
@implementation ELPublishImage

- (instancetype)initWithFrame:(CGRect)frame Img:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = img;
        self.imgView = [[UIImageView alloc]initWithFrame:frame];
        self.imgView.image = _image;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.clipsToBounds = YES;
//        self.imgView.tag=1000+i;
        //允许用户交互
        self.imgView.userInteractionEnabled = YES;
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_clickImgView)];
        [self.imgView addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_tapCloseIcon)];
        [self.closeIcon addGestureRecognizer:tap];
        [self addSubview:self.imgView];
        self.imgView.frame = frame;
        
        [self addSubview:self.closeIcon];
        self.closeIcon.frame = CGRectMake(frame.size.width-16, 0, 16, 16);
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
+(instancetype)emptyItem:(CGRect)rect {
    return [[ELPublishImage alloc] initWithFrame:rect];
}

- (UIImageView *)closeIcon{
    if(!_closeIcon){
        _closeIcon = [[UIImageView alloc]init];
        _closeIcon.backgroundColor = [UIColor eh_e1e1e1];
        _closeIcon.image = [UIImage imageNamed:@"icon_close"];
        _closeIcon.contentMode = UIViewContentModeScaleToFill;
        _closeIcon.userInteractionEnabled = YES;

    }
    return _closeIcon;
}

- (void)_clickImgView{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickImageELPublishImage:)]){
        [self.delegate clickImageELPublishImage:self];
    }
}

- (void)_tapCloseIcon{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(deleteImageELPublishImage:)]){
        [self.delegate deleteImageELPublishImage:self];
    }
}
@end
