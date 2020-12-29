//
//  ELImageManager.h
//  EduLoop
//
//  Created by mijika on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELImageManager : NSObject

@property(nonatomic,strong,readwrite) UIImageView *imgView;
@property(nonatomic,strong,readwrite) UIView *backgroundView;

+(ELImageManager *)sharedManager;
- (void)showImageView:(UIImage *)photo;
@end

NS_ASSUME_NONNULL_END
