//
//  SettingDataView.m
//  EduLoop
//
//  Created by mijika on 2020/12/8.
//

#import "SettingDataTableViewCell.h"
#import "UIColor+ELColor.h"
#import <Masonry/Masonry.h>
#import <SDWebImage.h>

@implementation SettingDataModel

- (instancetype)init
{
    if ((self = [super init])) {
        _accessoryType = SettingTableViewCellType_Text;
        _showArrow = YES;
        _maxLength = 50;
    }
    return self;
}
@end

@interface SettingDataTableViewCell ()<UITextViewDelegate,UITextFieldDelegate>

@end
@implementation SettingDataTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(SettingDataModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _data = model;
        [self setupView];
        [self loadData];
//        [self addGestureRecognizer:({
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCell)];
//            recognizer;
//        })];
    }
    return self;
}
- (void) clickCell{
    if(_data.clickBlock){
        _data.clickBlock();
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    _data.realContent = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int kLimitNumber = _data.maxLength;
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger res = kLimitNumber-[str length];
    if(res >= 0){
        _detailTextViewLengthLabel.text = [NSString stringWithFormat:@"%ld/%d", str.length, kLimitNumber];
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        _detailTextViewLengthLabel.text = [NSString stringWithFormat:@"%ld/%d", kLimitNumber, kLimitNumber];
        return NO;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    _data.realContent = textField.text;
}

- (void)loadData{
    _titleLabel.text= _data.title;
    _subtitleLabel.text= _data.subtitle;
    if(_data.accessoryType==SettingTableViewCellType_InlineTextField){
        _detailTextfield.text = _data.detailText;
        if(_data.detailDefaultText.length!=0)
            _detailTextfield.placeholder = _data.detailDefaultText;
    }else if(_data.accessoryType ==SettingTableViewCellType_BigTextField){
        _detailTextView.text = _data.detailText;
    }
    else
        _detailLabel.text= _data.detailText;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_data.avatarImageUrl] placeholderImage:_data.defaultAvatarImage];
    _detailTextViewLengthLabel.text = [NSString stringWithFormat:@"%ld/%d", (unsigned long)_detailTextView.text.length, _data.maxLength];
    _data.realContent = _data.detailText;

}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        if(_data.accessoryType!=SettingTableViewCellType_BigTextField&&_data.accessoryType!=SettingTableViewCellType_Choices)
            make.centerY.equalTo(self.contentView.mas_centerY);
        else
            make.top.equalTo(self.contentView).offset(20);
        make.width.equalTo(@100);
    }];
    
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.top.equalTo(self.titleLabel);
//        make.width.lessThanOrEqualTo(@50);
        make.height.equalTo(@20);
    }];
    
    if(_data.showArrow){
        [self addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    
    if(_data.accessoryType==SettingTableViewCellType_Image){
        [self.contentView addSubview:self.avatarView];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(_data.showArrow)
                make.right.equalTo(self.arrowImage.mas_left);
            else
                make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
    }else if(_data.accessoryType==SettingTableViewCellType_Switch){
        [self.contentView addSubview:self.aSwitch];
        [self.aSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            if(_data.showArrow)
                make.right.equalTo(self.arrowImage.mas_left);
            else
                make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    else{
        UIView *view;
        if(_data.accessoryType==SettingTableViewCellType_Text)
            view =self.detailLabel;
        else if(_data.accessoryType==SettingTableViewCellType_InlineTextField)
            view = self.detailTextfield;
        else if(_data.accessoryType==SettingTableViewCellType_BigTextField)
            view = [self getDetailTextViewWithLength];
        else if(_data.accessoryType==SettingTableViewCellType_Choices){
            view = [self getChoicesStack];
        }
        
        [self.contentView addSubview:view];
        if(_data.accessoryType==SettingTableViewCellType_BigTextField||_data.accessoryType==SettingTableViewCellType_Choices){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(20);
                make.right.equalTo(self.contentView).offset(-20);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
                make.height.equalTo(@150);
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if(_data.showArrow)
                    make.right.equalTo(self.arrowImage.mas_left);
                else
                    make.right.equalTo(self.contentView).offset(-20);
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.subtitleLabel.mas_right);
//                make.width.mas_greaterThanOrEqualTo(@100);
            }];
        }
    }
}

#pragma mark - View
- (UIView *)getDetailTextViewWithLength{
    UIView *view = [[UIView alloc]init];
    [view addSubview:self.detailTextView];
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).mas_offset(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
    [view addSubview:self.detailTextViewLengthLabel];
    [self.detailTextViewLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTextView.mas_bottom).offset(5);
        make.right.equalTo(view);
    }];
    return view;
}

- (UIView *)getChoicesStack{
       UIView *aChoice = [[UIView alloc]init];
       UILabel *aLabel = [[UILabel alloc]init];
       aLabel.text = @"A";
       aLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
       [aLabel sizeToFit];
       [aChoice addSubview:aLabel];
       [aLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(aChoice).offset(10);
           make.bottom.equalTo(aChoice).offset(-10);
           make.left.equalTo(aChoice);
       //        make.right.equalTo(aChoice).offset(-20);
       }];
       [aChoice addSubview:self.aTextField];
       [self.aTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(aLabel);
           make.bottom.equalTo(aLabel);
           make.left.equalTo(aLabel).offset(20);
           make.right.equalTo(aChoice);
       }];
       
       UIView *bChoice = [[UIView alloc]init];
       UILabel *bLabel = [[UILabel alloc]init];
       bLabel.text = @"B";
       bLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
       [bLabel sizeToFit];
       [bChoice addSubview:bLabel];
       [bLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(bChoice).offset(10);
           make.bottom.equalTo(bChoice).offset(-10);
           make.left.equalTo(bChoice);
       //        make.right.equalTo(aChoice).offset(-20);
       }];
       [bChoice addSubview:self.bTextField];
       [self.bTextField mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(bLabel);
           make.bottom.equalTo(bLabel);
           make.left.equalTo(bLabel).offset(20);
           make.right.equalTo(bChoice);
       }];
       UIView *choicesStack = [UIView new];
       [choicesStack addSubview:aChoice];
       [aChoice mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(choicesStack);
           make.left.equalTo(choicesStack);
           make.right.equalTo(choicesStack);
           make.height.equalTo(@50);
       }];
       [choicesStack addSubview:bChoice];
       [bChoice mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(aChoice.mas_bottom);
           make.height.equalTo(@50);
           make.left.equalTo(aChoice);
           make.right.equalTo(aChoice);
       }];
    return choicesStack;
}

- (UILabel *)detailTextViewLengthLabel{
    if (!_detailTextViewLengthLabel) {
        _detailTextViewLengthLabel = [UILabel new];
        _detailTextViewLengthLabel.backgroundColor = [UIColor clearColor];
        _detailTextViewLengthLabel.numberOfLines = 0;
        _detailTextViewLengthLabel.textColor = [UIColor lightGrayColor];
        _detailTextViewLengthLabel.font = [UIFont systemFontOfSize:14];
        _detailTextViewLengthLabel.textAlignment = NSTextAlignmentRight;
        [_detailTextViewLengthLabel sizeToFit];
    }
    return _detailTextViewLengthLabel;
}

- (UISwitch *)aSwitch{
    if(!_aSwitch){
        _aSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        _aSwitch.on =_data.switchOpen;
        [_aSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _aSwitch;
}

-(void)switchChange{
    _data.switchOpen = _aSwitch.on;
}

- (UIImageView *)avatarView{
    if(!_avatarView){
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.backgroundColor = [UIColor elSeperatorColor];
        _avatarView.layer.cornerRadius = 35;
        _avatarView.layer.masksToBounds = YES;
        
    }
    return _avatarView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.numberOfLines = 1;
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:15];
        _subtitleLabel.textAlignment = NSTextAlignmentLeft;
        _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _subtitleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _subtitleLabel.numberOfLines = 1;
    }
    return _detailLabel;
}

- (UITextField *)detailTextfield{
    if(!_detailTextfield){
        self.detailTextfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
            self.detailTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
            self.detailTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.detailTextfield.textAlignment = NSTextAlignmentRight;
        self.detailTextfield.delegate = self;
        self.detailTextfield.textColor = [UIColor lightGrayColor];
        self.detailTextfield.font = [UIFont systemFontOfSize:16];
    }
    return _detailTextfield;
}

-(UITextView *)detailTextView{
    if(!_detailTextView){
        _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _detailTextView.layer.cornerRadius =15;
        _detailTextView.backgroundColor = [UIColor elBackgroundColor];
        _detailTextView.textAlignment = NSTextAlignmentLeft;
        _detailTextView.textColor = [UIColor lightGrayColor];
        _detailTextView.font = [UIFont systemFontOfSize:16];
        _detailTextView.delegate = self;
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = _data.detailDefaultText;

        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_detailTextView addSubview:placeHolderLabel];
        // same font
        placeHolderLabel.font = [UIFont systemFontOfSize:16];
        [_detailTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _detailTextView;
}

- (UIImageView *)arrowImage{
    if(!_arrowImage){
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"right_arrow_gray"];
        _arrowImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _arrowImage;
}

- (UITextField *)aTextField{
    if(!_aTextField){
        _aTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _aTextField.font = [UIFont systemFontOfSize:18.f];
        _aTextField.textColor = [UIColor lightGrayColor];
//        _aTextField.layer.cornerRadius =15;
//        _aTextField.backgroundColor = [UIColor elBackgroundColor];
      
        _aTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _aTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _aTextField.textAlignment = NSTextAlignmentLeft;
        _aTextField.placeholder = @"输入选项内容";
    }
    return _aTextField;
}

- (UITextField *)bTextField{
    if(!_bTextField){
        _bTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        _bTextField.font = [UIFont systemFontOfSize:18.f];
        _bTextField.textColor = [UIColor lightGrayColor];
//        _bTextField.layer.cornerRadius =15;
//        _bTextField.backgroundColor = [UIColor elBackgroundColor];
        _bTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _bTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _aTextField.textAlignment = NSTextAlignmentLeft;
        _bTextField.placeholder = @"输入选项内容";
    }
    return _bTextField;
}

-(void)clickHomeworkMenu{
//    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickOtherButtonTableViewCell:)]){
//        [self.delegate clickOtherButtonTableViewCell:self];
//    }
}
@end
