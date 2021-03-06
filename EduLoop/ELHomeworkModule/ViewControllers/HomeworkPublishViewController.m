//
//  HomeworkPublishViewController.m
//  EduLoop
//
//  Created by mijika on 2021/5/5.
//

#import "HomeworkPublishViewController.h"
#import "UIColor+ELColor.h"
#import <Masonry/Masonry.h>
#import "ELPublishImage.h"
#import "ELImageManager.h"
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "ELScreen.h"
#import "ELNetworkSessionManager.h"
#import "GetMyTPTeamsResponse.h"
#import "BasicInfo.h"
#import "MomentsModel.h"
@interface HomeworkPublishViewController ()<UITextViewDelegate,ELPublishImageDelegate,TZImagePickerControllerDelegate>

@end

@implementation HomeworkPublishViewController
- (instancetype)initWithTaskId:(NSInteger)taskId Student:(StudentModel *)student
{
    self = [super init];
    if (self) {
        _taskId = taskId;
        _student = student;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.textView becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgs = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
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
    NSString *title = [NSString stringWithFormat:@"%@%@%@",@"为学生",self.student.name,@"提交作业"];
    [self setTitle:title];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(publishHomework)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancel)];
}

- (void)setupSubviews{
    [self.view addSubview:self.bgView];
    CGFloat imgWidth = (self.view.bounds.size.width-40-15*2)/3;
    self.bgView.frame = CGRectMake(0,(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT), self.view.bounds.size.width, self.view.bounds.size.height-(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT)-HOME_BUTTON_HEIGHT-50-2);
    [self.bgView addSubview:self.textView];
    self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];
    self.textView.delegate = self;
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.textView.contentSize = CGSizeMake(self.textView.frame.size.width,self.textView.frame.size.height+1);

    [self.bgView addSubview:self.imgStackView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,2,self.view.bounds.size.width, 50)];
    bottomView.backgroundColor = [UIColor elBackgroundColor];
    [bottomView addSubview:self.addImgBtn];
    self.addImgBtn.frame = CGRectMake(20,10,30,30);
//    [bottomView addSubview:self.publicRangeBtn];
//    self.publicRangeBtn.frame = CGRectMake(80,10,110,30);
    [self.btnView addSubview:bottomView];
    [self.view addSubview:self.btnView];

}

- (UIStackView *)imgStackView{
    if(!_imgStackView){
//        if([self.imgs count]>0){
            CGFloat imgWidth = (self.bgView.bounds.size.width-40-15*2)/3;

            _imgStackView = [[UIStackView alloc]initWithFrame:CGRectMake(20,self.bgView.bounds.size.height-imgWidth-10, self.bgView.frame.size.width-40, imgWidth)];
            _imgStackView.spacing = 15;
            _imgStackView.distribution = UIStackViewDistributionFillEqually;
            _imgStackView.backgroundColor = [UIColor whiteColor];
        _imgStackView.alpha = 0;

//            int i=0;
//            for(NSString *img in self.imgs){
//                ELPublishImage *photo = [[ELPublishImage alloc]initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth) Img:img];
//                [_imgStackView addArrangedSubview:photo];
//                photo.delegate = self;
//                i++;
//            }
//            while(i<3){
//                [_imgStackView addArrangedSubview:[ELPublishImage emptyItem:CGRectMake(0, 0, imgWidth, imgWidth)]];
//                i++;
//            }
//        }
    }
    return _imgStackView;
}

- (UIView *)btnView{
    if(!_btnView){
        _btnView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-HOME_BUTTON_HEIGHT-50-2,self.view.bounds.size.width, 50+2)];
        _btnView.backgroundColor = [UIColor whiteColor];


    [_btnView addSubview:({
        UIView *seperatoriew = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, 2)];
        seperatoriew.backgroundColor = [UIColor elSeperatorColor];
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
        placeHolderLabel.text = @"请按老师要求完成作业";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];

        // same font
        _textView.font = [UIFont systemFontOfSize:20];
        placeHolderLabel.font = [UIFont systemFontOfSize:20.f];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
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

- (TZImagePickerController *)imagePickerVc{
    if(!_imagePickerVc){
        CGFloat imgWidth = (self.view.bounds.size.width-40-15*2)/3;

        _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        _imagePickerVc.preferredLanguage = @"zh-Hans";
        _imagePickerVc.allowPickingOriginalPhoto = NO;
        _imagePickerVc.showSelectedIndex = YES;
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [_imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [_imgs removeAllObjects];
            for(UIView *view in [self.imgStackView arrangedSubviews])
                [self.imgStackView removeArrangedSubview:view];
            for(UIImage *img in photos){
                NSData *data = UIImagePNGRepresentation(img);
                NSString * base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [self.imgs addObject:base64];
                ELPublishImage *photo = [[ELPublishImage alloc]initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth) Img:base64];
                [self.imgStackView addArrangedSubview:photo];
                photo.delegate = self;

    //            for(NSString *img in self.imgs){
    //                ELPublishImage *photo = [[ELPublishImage alloc]initWithFrame:CGRectMake(0, 0, imgWidth, imgWidth) Img:img];
    //                [_imgStackView addArrangedSubview:photo];
    //                photo.delegate = self;
    //                i++;
    //            }
                
            }
            NSInteger i=[photos count];
            while(i<3){
                [self.imgStackView addArrangedSubview:[ELPublishImage emptyItem:CGRectMake(0, 0, imgWidth, imgWidth)]];
                i++;
            }
            if(self.imgs.count>0){
                self.imgStackView.alpha=1;
                self.bgView.frame = CGRectMake(0, (STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT), self.view.bounds.size.width, self.view.bounds.size.height-(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT)-HOME_BUTTON_HEIGHT-50-2-self.imgStackView.frame.size.height);
                self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];
                
            }
        }];
    }
    return _imagePickerVc;
}

- (void)selectImage{
    
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];
}

- (void)postHomeworkNetworkWithSuccess:(nullable void (^)())success{
    NSDictionary *paramDict =  @{
        @"taskId":[NSNumber numberWithInteger: self.taskId],
        @"studentId":[NSNumber numberWithInteger: self.student.id],
        @"detail":self.textView.text,
        @"imgs":self.imgs
    };
    [BasicInfo POST:[BasicInfo url:@"/homework"] parameters:paramDict success:success];
}


- (void)publishHomework{
    if(self.textView.text.length==0&&self.imgs.count==0){
        [BasicInfo showToastWithMsg:@"请输入作业内容或上传作业图片"];
        return ;
    }
    [self postHomeworkNetworkWithSuccess:^{
        [BasicInfo showToastWithMsg:@"发布成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
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
    [self selectImage];
}

#pragma mark - ELPublishImageDelegate
- (void)clickImageELPublishImage:(UIView *)elPublishImage{
    ELPublishImage *photo =(ELPublishImage *)elPublishImage;
    [self.textView resignFirstResponder];
    [[ELImageManager sharedManager]showImageBase:photo.imageUrl];
}

- (void)deleteImageELPublishImage:(UIView *)elPublishImage{
    ELPublishImage *photo =(ELPublishImage *)elPublishImage;
    [_imgs removeObject:photo.imageUrl];
    [_imgStackView removeArrangedSubview:photo];
    [photo removeFromSuperview];
    [_imgStackView addArrangedSubview:[ELPublishImage emptyItem:photo.frame]];
    if([self.imgs count]==0){
        [UIView animateWithDuration:0.25 animations:^{
            self.imgStackView.alpha = 0;

            self.bgView.frame = CGRectMake(0, (STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT), self.view.bounds.size.width, self.view.bounds.size.height-(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT)-HOME_BUTTON_HEIGHT-50-2);
            self.textView.frame = [self.view convertRect:CGRectInset(self.bgView.frame, 20, 20) toView:self.bgView];
//            [self.imgStackView setHidden:YES];

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
        self.bgView.frame = CGRectMake(0, (STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT), self.view.bounds.size.width, self.view.bounds.size.height-(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT)-offset);

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
        self.btnView.frame = CGRectMake(0.0f, self.view.bounds.size.height-HOME_BUTTON_HEIGHT-height, self.view.frame.size.width, height);
        CGFloat imgWidth = (self.view.bounds.size.width-40-15*2)/3;
        CGFloat bgHeight = self.btnView.frame.origin.y-(STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT);
        CGFloat offset = bgHeight;
        if([self.imgs count]>0){
            offset=bgHeight-(imgWidth+10);
        }
        
        self.bgView.frame = CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT, self.view.bounds.size.width,bgHeight);
        self.textView.frame = [self.view convertRect:CGRectInset(CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_HEIGHT, self.view.bounds.size.width, offset), 20, 20) toView:self.bgView];
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
