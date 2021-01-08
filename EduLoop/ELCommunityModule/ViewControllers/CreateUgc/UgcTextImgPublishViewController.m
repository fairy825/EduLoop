//
//  UgcTextImgPublishViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/30.
//

#import "UgcTextImgPublishViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELPublishImage.h"
#import "ELImageManager.h"
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"

@interface UgcTextImgPublishViewController ()<UITextViewDelegate,ELPublishImageDelegate>

@end

@implementation UgcTextImgPublishViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [self.textView becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UgcPublishTextImgModel *model = [UgcPublishTextImgModel new];
    model.imgs = @[[UIImage imageNamed:@"sample-1"],[UIImage imageNamed:@"sample-2"]].mutableCopy;
    self.data = model;
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
    //键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil ];
    //键盘收回监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavagationBar{
    [self setTitle:@"发送图文"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(publishUgc)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancel)];
}

- (void)setupSubviews{
    [self.view addSubview:self.bgView];
    CGFloat imgWidth = (self.view.bounds.size.width-40-15*2)/3;

    self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88-34-50-2);
    [self.bgView addSubview:self.textView];
    self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];
    self.textView.delegate = self;
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.textView.contentSize = CGSizeMake(self.textView.frame.size.width,self.textView.frame.size.height+1);

    [self.bgView addSubview:self.imgStackView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,2,self.view.bounds.size.width, 50)];
    bottomView.backgroundColor = [UIColor eh_f6f6f6];
    [bottomView addSubview:self.addImgBtn];
    self.addImgBtn.frame = CGRectMake(20,10,30,30);
    [bottomView addSubview:self.publicRangeBtn];
    self.publicRangeBtn.frame = CGRectMake(80,10,110,30);
    [self.btnView addSubview:bottomView];
    [self.view addSubview:self.btnView];

}

- (UIStackView *)imgStackView{
    if(!_imgStackView){
        if([self.data.imgs count]>0){
            CGFloat imgWidth = (self.bgView.bounds.size.width-40-15*2)/3;

            _imgStackView = [[UIStackView alloc]initWithFrame:CGRectMake(20,self.bgView.bounds.size.height-imgWidth-10, self.bgView.frame.size.width-40, imgWidth)];
            _imgStackView.spacing = 15;
            _imgStackView.distribution = UIStackViewDistributionFillEqually;
            _imgStackView.backgroundColor = [UIColor whiteColor];
            int i=0;
            for(UIImage *img in self.data.imgs){
                ELPublishImage *photo = [[ELPublishImage alloc]initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth) Img:img];
                [_imgStackView addArrangedSubview:photo];
                photo.delegate = self;
                i++;
            }
            while(i<3){
                [_imgStackView addArrangedSubview:[ELPublishImage emptyItem:CGRectMake(0, 0, imgWidth, imgWidth)]];
                i++;
            }
        }
    }
    return _imgStackView;
}

- (UIView *)btnView{
    if(!_btnView){
        _btnView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-34-50-2,self.view.bounds.size.width, 50+2)];
        _btnView.backgroundColor = [UIColor whiteColor];


    [_btnView addSubview:({
        UIView *seperatoriew = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, 2)];
        seperatoriew.backgroundColor = [UIColor eh_eeeeee];
        seperatoriew;
    })];
    }
    return _btnView;
}

- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]init];
//        _bgView.showsVerticalScrollIndicator = NO;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textAlignment = NSTextAlignmentLeft;

        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入内容...";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor eh_999999];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];

        // same font
        _textView.font = [UIFont systemFontOfSize:20];
        placeHolderLabel.font = [UIFont systemFontOfSize:20.f];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTextView)];
//
//         [_textView addGestureRecognizer:pan];
    }
    return _textView;
}

- (UIButton *)addImgBtn{
    if(!_addImgBtn){
        _addImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _addImgBtn.backgroundColor = [UIColor clearColor];
        [_addImgBtn setBackgroundImage:[UIImage imageNamed:@"icon_pic"] forState:UIControlStateNormal];
        [_addImgBtn addTarget:self action:@selector(choosePic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgBtn;
}

- (UIButton *)publicRangeBtn{
    if(!_publicRangeBtn){
        _publicRangeBtn = [[UIButton alloc]init];
        [_publicRangeBtn setTitleColor:[UIColor eh_999999] forState:UIControlStateNormal];
        [_publicRangeBtn setTitle:@"可见范围" forState:UIControlStateNormal];
        _publicRangeBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [_publicRangeBtn setImage: [UIImage imageNamed:@"icon_eye-4"] forState:UIControlStateNormal];
        [_publicRangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];

        _publicRangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _publicRangeBtn.layer.cornerRadius = 15;
        _publicRangeBtn.layer.borderColor = [UIColor eh_999999].CGColor;
        _publicRangeBtn.layer.borderWidth = 1;
        [_publicRangeBtn setContentEdgeInsets:UIEdgeInsetsMake(5,8,5,8)];
//        [_publicRangeBtn addTarget:self action:@selector(toggleThumb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publicRangeBtn;
}

- (void)publishUgc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCancel{
    ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
    centerOverlayModel.title = @"确认退出？";
    centerOverlayModel.subTitle = @"退出后当前草稿不会保存";
    centerOverlayModel.leftChoice = ({
        ELOverlayItem *sureItem =[ELOverlayItem new];
        sureItem.title = @"确认";
        __weak typeof(self) wself = self;
        sureItem.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController popViewControllerAnimated:YES];

        };
        sureItem;
    });
    ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
    ];
    
    [deleteAlertView showHighlightView];
}

- (void)choosePic{
    [self.textView resignFirstResponder];
}

#pragma mark - ELPublishImageDelegate
- (void)clickImageELPublishImage:(UIView *)elPublishImage{
    ELPublishImage *photo =(ELPublishImage *)elPublishImage;
    [self.textView resignFirstResponder];
    [[ELImageManager sharedManager]showImageView:photo.image];
}

- (void)deleteImageELPublishImage:(UIView *)elPublishImage{
    ELPublishImage *photo =(ELPublishImage *)elPublishImage;
    [_data.imgs removeObject:photo.image];
    [_imgStackView removeArrangedSubview:photo];
    [photo removeFromSuperview];
    [_imgStackView addArrangedSubview:[ELPublishImage emptyItem:photo.frame]];
    if([self.data.imgs count]==0){
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88-34-50-2);
            self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];
            [self.imgStackView setHidden:YES];

        } completion:nil];
        
    }
}

#pragma mark - Keyboard
//键盘弹出时会调用
-(void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的基本信息
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = rect.size.height;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = 50+2;
    CGFloat offset = keyboardHeight+height;

    [UIView animateWithDuration:duration animations:^{
        self.btnView.frame = CGRectMake(0.0f, self.view.bounds.size.height-offset, self.view.frame.size.width, height);
        self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88-offset);

        self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];

    } completion:nil];
}

 
//键盘收回时会调用
-(void)keyboardWillHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];

    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = 50+2;
    [UIView animateWithDuration:duration animations:^{
        self.btnView.frame = CGRectMake(0.0f, self.view.bounds.size.height-34-height, self.view.frame.size.width, height);
        CGFloat imgWidth = (self.view.bounds.size.width-40-15*2)/3;
        CGFloat bgHeight = self.view.bounds.size.height-88-34-height;
        CGFloat offset = bgHeight;
        if([self.data.imgs count]>0){
            offset=bgHeight-(imgWidth+10);
        }
        
        self.bgView.frame = CGRectMake(0, 88, self.view.bounds.size.width,bgHeight);
        self.textView.frame = [self.view convertRect:CGRectInset(CGRectMake(0, 88, self.view.bounds.size.width, offset), 20, 20) toView:self.bgView];
    } completion:nil];
}

-(void)dismissKeyboard{
    [self.view endEditing:YES];
//    [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self dismissKeyboard];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

@end
