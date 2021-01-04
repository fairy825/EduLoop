//
//  ELCustomLabel.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "ELCustomLabel.h"

@implementation ELCustomLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}
- (void)setTextInsets:(UIEdgeInsets)textInsets
{
    _textInsets = textInsets;
    [self invalidateIntrinsicContentSize];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    UIEdgeInsets insets = self.textInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                        limitedToNumberOfLines:numberOfLines];
    if (self.text.length > 0) {
        rect.origin.x    -= insets.left;
        rect.origin.y    -= insets.top;
        rect.size.width  += (insets.left + insets.right);
        rect.size.height += (insets.top + insets.bottom);
    }
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
