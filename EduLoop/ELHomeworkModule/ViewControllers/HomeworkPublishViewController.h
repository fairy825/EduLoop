//
//  HomeworkPublishViewController.h
//  EduLoop
//
//  Created by mijika on 2021/5/5.
//

#import <UIKit/UIKit.h>
#import <TZImagePickerController.h>
#import "StudentModel.h"
#import "ELBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkPublishViewController : ELBaseViewController
@property(nonatomic,readwrite) NSInteger taskId;
@property(nonatomic,readwrite) StudentModel *student;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UITextView *textView;
@property(nonatomic,strong,readwrite) UIView *btnView;
@property(nonatomic,strong,readwrite) UIButton *addImgBtn;
@property(nonatomic,strong,readwrite) UIStackView *imgStackView;
@property(nonatomic,strong,readwrite) NSMutableArray<NSString *> *imgs;
@property(nonatomic,strong,readwrite) TZImagePickerController *imagePickerVc;
- (instancetype)initWithTaskId:(NSInteger)taskId Student:(StudentModel *)student;
@end

NS_ASSUME_NONNULL_END
