//
//  UgcTextImgPublishViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "UgcPublishTextImgModel.h"
#import "ELBottomSelectOverlay.h"
#import "TeamModel.h"
#import <TZImagePickerController.h>
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcTextImgPublishViewController : ELBaseViewController

@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UITextView *textView;
@property(nonatomic,strong,readwrite) UIView *btnView;
@property(nonatomic,strong,readwrite) UIButton *addImgBtn;
//@property(nonatomic,strong,readwrite) UIButton *publicRangeBtn;
@property(nonatomic,strong,readwrite) UIStackView *imgStackView;
//@property(nonatomic,strong,readwrite) ELBottomSelectOverlay *overlay;
//@property(nonatomic,strong,readwrite) NSArray<TeamModel *> *teams;
//@property(nonatomic,strong,readwrite) NSMutableArray<NSNumber *> *chosedTeamIndexs;
@property(nonatomic,strong,readwrite) NSMutableArray<NSString *> *imgs;
@property(nonatomic,strong,readwrite) TZImagePickerController *imagePickerVc;
@end

NS_ASSUME_NONNULL_END
