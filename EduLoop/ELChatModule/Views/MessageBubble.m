//
//  MessageBubble.m
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//

#import "MessageBubble.h"
#import "UIColor+EHTheme.h"
@implementation MessageBubble
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.bgView addSubview:self.messageLabel];

        [self addSubview:self.bgView];
    }
    return self;
}

-(void) reload{
    
}

#pragma mark - View
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//        _bgView.backgroundColor = [UIColor grayColor];
//        UIView *triangle = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 5, 10)];
//        CGSize size = triangle.bounds.size;
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(0, triangle.frame.origin.y+size.height/2)];
//        [path addLineToPoint:CGPointMake(size.width, triangle.frame.origin.y)];
//        [path addLineToPoint:CGPointMake(size.width, triangle.frame.origin.y+size.height)];
//        [path closePath];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//        maskLayer.frame = triangle.frame;
//        maskLayer.path = path.CGPath;
//        triangle.layer.mask = maskLayer;
//        triangle.layer.masksToBounds = YES;
//        triangle.backgroundColor = [UIColor redColor];
//        [_bgView addSubview:triangle];
//        UIView *rect = [[UIView alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.width, self.bounds.size.height)];
//        rect.layer.cornerRadius = 10;
//        rect.layer.masksToBounds = YES;
//        [_bgView addSubview:rect];
    }
    return _bgView;
}

- (UILabel *)messageLabel{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:18.f];
        _messageLabel.textColor = [UIColor eh_333333];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.numberOfLines = 0;

    }
    return _messageLabel;
}

@end
