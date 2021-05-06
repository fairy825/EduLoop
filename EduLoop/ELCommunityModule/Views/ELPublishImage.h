//
//  ELPublishImage.h
//  EduLoop
//
//  Created by mijika on 2020/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ELPublishImageDelegate<NSObject>
-(void)clickImageELPublishImage:(UIView *)elPublishImage;
-(void)deleteImageELPublishImage:(UIView *)elPublishImage;
@end

@interface ELPublishImage : UIView
@property(nonatomic,strong,readwrite) NSString *imageUrl;
@property(nonatomic,strong,readwrite) UIImageView *imgView;
@property(nonatomic,strong,readwrite) UIImageView *closeIcon;
@property(nonatomic,weak,readwrite) id<ELPublishImageDelegate> delegate;
+(instancetype)emptyItem:(CGRect)rect;
- (instancetype)initWithFrame:(CGRect)frame Img:(NSString *)img;
@end

NS_ASSUME_NONNULL_END
