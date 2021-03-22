//
//  ELOverlayTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "ELOverlayTableViewCell.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
@implementation ELOverlayTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
//    [self addGestureRecognizer:({
//        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItem)];
//        recognizer;
//    })];
    [self.contentView addSubview:self.choiceLabel];
    [self.choiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
}

#pragma mark - View
- (UILabel *)choiceLabel{
    if(!_choiceLabel){
        _choiceLabel = [UILabel new];
        _choiceLabel.backgroundColor = [UIColor whiteColor];
        _choiceLabel.text = @"";
        _choiceLabel.numberOfLines = 1;
        _choiceLabel.textColor = [UIColor color333333];
        _choiceLabel.font = [UIFont systemFontOfSize:16];
        _choiceLabel.textAlignment = NSTextAlignmentCenter;
        _choiceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_choiceLabel sizeToFit];
    }return  _choiceLabel;
}
@end
