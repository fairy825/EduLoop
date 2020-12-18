//
//  MineMiscCardTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import "MineMiscCardTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+EHGenerator.h"
#import "UIColor+EHTheme.h"

@implementation MineMiscCardTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);

    }];
    
    [self.contentView addSubview:self.arrow];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);

    }];
}
#pragma mark - View
- (UILabel *)title{
    if(!_title){
        self.title = [UILabel new];
        self.title.numberOfLines = 1;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.textColor = [UIColor eh_colorWithHexRGB:EHThemeColor_333333];
        self.title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _title;
}

- (UILabel *)detail{
    if(!_detail){
        self.detail = [UILabel new];
        self.detail.numberOfLines = 1;
        self.detail.lineBreakMode = NSLineBreakByTruncatingTail;
        self.detail.textColor = [UIColor eh_colorWithHexRGB:EHThemeColor_999999];
        self.detail.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _detail;
}

- (UIImageView *)arrow{
    if(!_arrow){
        self.arrow = [UIImageView new];
        self.arrow.image = [UIImage imageNamed:@"right_arrow_gray"];
        self.arrow.contentMode = UIViewContentModeScaleToFill;
    }
    return _arrow;
}
@end
