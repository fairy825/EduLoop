//
//  ELImageManager.m
//  EduLoop
//
//  Created by mijika on 2020/12/29.
//

#import "ELImageManager.h"
#import <SDWebImage.h>
@implementation ELImageManager

+(ELImageManager *)sharedManager{
    static ELImageManager* manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[ELImageManager alloc]init];
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
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, _backgroundView.bounds.size.width, _backgroundView.bounds.size.height-200)];
        _imgView.center = _backgroundView.center;
        [_imgView setImage:[UIImage imageNamed:@"sample-1"]];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_tapBg)];
        [_imgView addGestureRecognizer:tapGesture];
        _imgView;
    })];
    }
    return self;

}

- (void)showImageView:(NSString *)url{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
    [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
}
- (void)showImageBase:(NSString *)url{
    NSData * showData = [[NSData alloc]initWithBase64EncodedString:url options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.imgView.image = [UIImage imageWithData:showData];
    [[UIApplication sharedApplication].keyWindow addSubview:_backgroundView];
}
- (void)_tapBg{
    [_backgroundView removeFromSuperview];
}
@end
