//
//  ELOverlay.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "ELOverlay.h"
#import <Masonry/Masonry.h>
#import "ELOverlayTableViewCell.h"

@implementation ELBottomOverlay
- (void)showHighlightView{
    [self showHighlightViewFromPoint:CGPointMake(self.coverWidth/2-100,self.coverHeight) ToPoint:CGPointMake(self.coverWidth/2,self.coverHeight-self.highLightView.bounds.size.height/2-20) Animation:YES];
}
@end


@interface ELOverlay()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation ELOverlay
- (instancetype)initWithFrame:(CGRect)frame Data:(NSArray<ELOverlayItem *> *)data
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:screenRect];
    if (self) {
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
        [self loadData:data];
        ELOverlayItem * item=[ELOverlayItem new];
        item.title =@"取消";
        [_choices addObject:item];
        [self setUpSubviews];
    }
    return self;
}
- (void)loadData:(NSArray<ELOverlayItem *> *)data{
    _choices = [NSMutableArray arrayWithArray:data];
}
- (void)setUpSubviews{
  
    [self addSubview:self.backgroundView];
    [self addSubview:self.highLightView];
}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.highLightView.frame = CGRectMake(point.x, point.y,  200,50*_choices.count);
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.highLightView.center = point2;

        } completion:nil];
    }else{
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        self.highLightView.center = point2;
    }
}

- (void)dismissOverlay{
    [self removeFromSuperview];
}

#pragma mark - View
- (UIView *)backgroundView{
    if(!_backgroundView){
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _coverWidth, _coverHeight)];
        self.backgroundView.backgroundColor = [UIColor grayColor];
        self.backgroundView.alpha = 0.5;
        [self.backgroundView addGestureRecognizer: ({
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissOverlay)];
            recognizer;
        })];
    }
    return _backgroundView;
}

- (UIView *)highLightView{
    if(!_highLightView){
        _highLightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,200 ,50*_choices.count )];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_highLightView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(25, 25)];
//
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//        maskLayer.frame = _highLightView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _highLightView.layer.mask = maskLayer;
        _highLightView.layer.cornerRadius = 15;
        _highLightView.layer.masksToBounds = YES;
        _highLightView.backgroundColor = [UIColor whiteColor];
        UITableView *tableView = [UITableView new];
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        [_highLightView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_highLightView);
        }];
    }
    return _highLightView;
}

//UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id = @"ELOverlayTableViewCell";
    ELOverlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if(!cell){
        cell = [[ELOverlayTableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
        ELOverlayItem *item =[_choices objectAtIndex:[indexPath row]];
        cell.choiceLabel.text =item.title;
        cell.clickItemBlock = item.clickBlock;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger idx = [indexPath row];
    ELOverlayItem *chosenItem = [_choices objectAtIndex:idx];
    dispatch_block_t clickBlock =chosenItem.clickBlock;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(getChosenTitle:)]){
        [self.delegate getChosenTitle:chosenItem.title];
    }
    if(clickBlock){
        clickBlock();
    }
    [self dismissOverlay];
}
@end
