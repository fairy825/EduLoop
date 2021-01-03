//
//  UgcTextImgPublishViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "UgcPublishTextImgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcTextImgPublishViewController : UIViewController

@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UITextView *textView;
@property(nonatomic,strong,readwrite) UIView *btnView;
@property(nonatomic,strong,readwrite) UIButton *addImgBtn;
@property(nonatomic,strong,readwrite) UIButton *publicRangeBtn;
@property(nonatomic,strong,readwrite) UIStackView *imgStackView;
@property(nonatomic,strong,readwrite) UgcPublishTextImgModel *data;
@end

NS_ASSUME_NONNULL_END
