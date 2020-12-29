//
//  ELCommentManager.h
//  EduLoop
//
//  Created by mijika on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELCommentManager : NSObject
@property(nonatomic,strong,readwrite) UITextView *textView;
@property(nonatomic,strong,readwrite) UIView *backgroundView;

+(ELCommentManager *)sharedManager;
- (void)showCommentView;
@end

NS_ASSUME_NONNULL_END
