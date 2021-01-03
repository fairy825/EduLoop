//
//  MineToolCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import <UIKit/UIKit.h>
#import "MineToolCardItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MineToolCardDelegate<NSObject>
-(void)jumpToNewPage:(int )idx;
@end

@interface MineToolCard : UIView
@property (nonatomic) NSArray<MineToolCardItem*> *items;
@property(nonatomic,weak,readwrite) id<MineToolCardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
