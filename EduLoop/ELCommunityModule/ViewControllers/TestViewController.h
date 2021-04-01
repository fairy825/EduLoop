//
//  TestViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController
@property(nonatomic,strong,readwrite) UIScrollView *scrollView;
@property(nonatomic,strong,readwrite) UITableView *commentTableView;
@property(nonatomic,strong,readwrite) UITextView *textView;

@end

NS_ASSUME_NONNULL_END
