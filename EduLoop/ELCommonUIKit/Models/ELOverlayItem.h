//
//  ELOverlayItem.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELOverlayItem : NSObject
@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,copy,readwrite) dispatch_block_t clickBlock;

@end
NS_ASSUME_NONNULL_END
