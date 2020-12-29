//
//  ELSearchBar.m
//  EduLoop
//
//  Created by mijika on 2020/12/28.
//

#import "ELSearchBar.h"
@interface ELSearchBar()<UITextFieldDelegate>
@end

@implementation ELSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, frame.size.width-10*2, frame.size.height-5*2)];
            _textField.backgroundColor = [UIColor whiteColor];
            _textField.delegate = self;
            _textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search-1"]];
            _textField.leftView.contentMode = UIViewContentModeScaleAspectFit;
            _textField.leftViewMode = UITextFieldViewModeAlways;
            _textField.clearButtonMode = UITextFieldViewModeAlways;
            _textField.placeholder = @"搜索";
            _textField;
        })];
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

//监听输入框内容变化 例如字数判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    return YES;
}
@end
