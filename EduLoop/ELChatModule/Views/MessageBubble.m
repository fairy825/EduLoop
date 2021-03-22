//
//  MessageBubble.m
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//

#import "MessageBubble.h"
#import "UIColor+EHTheme.h"
#import "ELScreen.h"
#define triWidth 10.0
#define rectRadius 10.0
#define triTop  20.0
@implementation MessageBubble
- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)str isLeft:(BOOL)isLeft
{
    self = [super initWithFrame:frame];
    if (self) {
        _isLeft = isLeft;
        _messageStr = str;
        [self load];
        [self.bgView addSubview:self.messageLabel];
        [self addSubview:self.bgView];
    }
    return self;
}

- (void)load{
    NSDictionary *attri = @{NSFontAttributeName: self.messageLabel.font};
    //自适应高度
    CGSize size = [self.messageStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.55, SCREEN_HEIGHT * 0.58) options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    self.frame = CGRectMake(0,0, size.width +20+triWidth, size.height + 20);
    self.messageLabel.frame = CGRectMake(self.isLeft?10+triWidth:10,10, size.width, size.height);
}

#pragma mark - View
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
       
        CGFloat rectWidth = _bgView.frame.size.width-triWidth;
        CGFloat rectHeight = _bgView.frame.size.height;
        UIBezierPath *path = [UIBezierPath bezierPath];
        CAShapeLayer *layer = [CAShapeLayer layer];

        if(self.isLeft){
            [path moveToPoint:CGPointMake(triWidth+rectRadius,0)];
            [path addLineToPoint:CGPointMake(rectWidth + triWidth - rectRadius,0)];
            [path addArcWithCenter:CGPointMake(rectWidth + triWidth - rectRadius, rectRadius) radius:rectRadius startAngle:- M_PI_2 endAngle:0 clockwise:YES];//右上
            [path addLineToPoint:CGPointMake(rectWidth + triWidth,rectHeight- rectRadius)];
            [path addArcWithCenter:CGPointMake(rectWidth + triWidth-rectRadius, rectHeight - rectRadius) radius:rectRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];//右下
            [path addLineToPoint:CGPointMake(triWidth+rectRadius,rectHeight)];
            [path addArcWithCenter:CGPointMake(triWidth+rectRadius, rectHeight - rectRadius) radius:rectRadius startAngle:-M_PI*3/2.0 endAngle:-M_PI clockwise:YES];//左下
            [path addLineToPoint:CGPointMake(triWidth,triTop+triWidth)];
            [path addLineToPoint:CGPointMake(0,triTop+triWidth/2)];
            [path addLineToPoint:CGPointMake(triWidth,triTop)];
            [path addLineToPoint:CGPointMake(triWidth,rectRadius)];
            [path addArcWithCenter:CGPointMake(triWidth + rectRadius, rectRadius) radius:rectRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];//左上
            layer.fillColor = [UIColor grayColor].CGColor;
        }else{
            [path moveToPoint:CGPointMake(rectRadius,0)];
            [path addLineToPoint:CGPointMake(rectWidth - rectRadius,0)];
            [path addArcWithCenter:CGPointMake(rectWidth - rectRadius, rectRadius) radius:rectRadius startAngle:- M_PI_2 endAngle:0 clockwise:YES];//右上
            [path addLineToPoint:CGPointMake(rectWidth,triTop)];
            [path addLineToPoint:CGPointMake(rectWidth+triWidth,triTop+triWidth/2)];
            [path addLineToPoint:CGPointMake(rectWidth,triTop+triWidth)];
            [path addLineToPoint:CGPointMake(rectWidth,rectHeight- rectRadius)];
            
            [path addArcWithCenter:CGPointMake(rectWidth-rectRadius, rectHeight - rectRadius) radius:rectRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];//右下
            [path addLineToPoint:CGPointMake(rectRadius,rectHeight)];
            [path addArcWithCenter:CGPointMake(rectRadius, rectHeight - rectRadius) radius:rectRadius startAngle:-M_PI*3/2.0 endAngle:-M_PI clockwise:YES];//左下
            [path addLineToPoint:CGPointMake(0,rectRadius)];
            [path addArcWithCenter:CGPointMake(rectRadius, rectRadius) radius:rectRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];//左上
            layer.fillColor = [UIColor greenColor].CGColor;
        }
        [path closePath];
        layer.path= path.CGPath;
//        _bgView.layer.mask = layer;
        [self.bgView.layer addSublayer:layer];
        
    }
    return _bgView;
}

- (UILabel *)messageLabel{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:18.f];
        _messageLabel.textColor = [UIColor color333333];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = self.messageStr;
    }
    return _messageLabel;
}

@end
