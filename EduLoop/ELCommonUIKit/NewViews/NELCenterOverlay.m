//
//  NELCenterOverlay.m
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import "NELCenterOverlay.h"

@implementation NELCenterOverlay
- (void)showHighlightView{
    [self showHighlightViewFromPoint:CGPointZero ToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) Animation:NO];
}

@end
