//
//  ELBottomSelectOverlayCellTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/3/28.
//

#import "ELBottomSelectOverlayCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"

@implementation ELBottomSelectOverlayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.choiceLabel];
    [self.choiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)loadData{
    _choiceLabel.text = _data;
}

#pragma mark - View
- (UILabel *)choiceLabel{
    if(!_choiceLabel){
        _choiceLabel = [UILabel new];
        _choiceLabel.text = @"";
        _choiceLabel.numberOfLines = 1;
        _choiceLabel.textColor = [UIColor color333333];
        _choiceLabel.font = [UIFont systemFontOfSize:18];
        _choiceLabel.textAlignment = NSTextAlignmentLeft;
        _choiceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_choiceLabel sizeToFit];
    }return  _choiceLabel;
}
@end
