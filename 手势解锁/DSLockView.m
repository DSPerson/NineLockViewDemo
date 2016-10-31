//
//  DSLockView.m
//  手势解锁
//
//  Created by dsperson on 2016/10/30.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import "DSLockView.h"
#import <objc/runtime.h>

/** 这个算是是精确度 数值越小越靠近按钮的中心 */
static const CGFloat kButtonCenterToPointLength = 30;
/** 线得宽度 */
static const CGFloat kLineWidth = 8;
static const NSInteger kDSButtonTag = 6666;
static const NSInteger kDSButtonNums = 9;
/** 动画时间duration */
static const CGFloat kDSViewAnimationTimeInterval = 1;

static const NSInteger kButtonHang = 3;
static const NSInteger kButtonLie = 3;
@interface DSLockView ()
/**  */
@property (nonatomic, strong) NSMutableArray *btnArray;

/** <#(id)#> */
@property (nonatomic, assign) CGPoint currentPoint;
@end
@implementation DSLockView


- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       NSLog(@"-+-+-%s", __func__);
        [self createUI];
    }
    return self;
}

/** 先调用解析xib */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
       NSLog(@"---%s", __func__);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    for (NSInteger i = 0; i < kDSButtonNums; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        button.userInteractionEnabled = false;
        button.tag = kDSButtonTag + i;
        [self addSubview:button];
    }
}

- (CGPoint)pointWithTouchs:(NSSet<UITouch *>*)touchs {
    UITouch *touch = touchs.anyObject;
    return [touch locationInView:self];
}

- (UIButton *)rectContainInPoint:(CGPoint)point {
    __block NSUInteger index = 0;
    __block UIButton *button;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.origin.x = (obj.center.x - kButtonCenterToPointLength * 0.5);
        frame.origin.y = (obj.center.y - kButtonCenterToPointLength * 0.5);
        frame.size.width = kButtonCenterToPointLength;
        frame.size.height = kButtonCenterToPointLength;
        if (CGRectContainsPoint(frame, point)) {
            index = idx;
            *stop = true;
            button = (UIButton *)obj;
        }
    }];
    return (button ? button : nil);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSAssert(self.passwordStr != nil,@"密码不能为空 passwordStr is nil！！！");
    CGPoint point = [self pointWithTouchs:touches];
    UIButton *button = [self rectContainInPoint:point];
    if (button && button.selected == false) {
        button.selected = true;
        [self.btnArray addObject:button];
        
    }
   
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self getUserInputResult];
}

- (void)getUserInputResult {
    __block NSMutableString *string = [NSMutableString string];
    
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton *)obj;
        button.selected = false;
        NSInteger tag = button.tag - kDSButtonTag;
        [string appendString:[NSString stringWithFormat:@"%ld", tag]];
    }];
    [self.btnArray removeAllObjects];
    [self setNeedsDisplay];
    
    if (!self.kDSResultBlock) return;
    BOOL result = false;
    if ([self.passwordStr isEqualToString:string]) {
        result = true;
    } else {
        self.kDSResultBlock(result,false);
        return;
    }
    //如果动画不是开启的 则 动画完成只返回false
    if (!self.openAnimate) {
        self.kDSResultBlock(result,false);
    } else {
        [self loginSuccessStartAnimate];
    }
    
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self pointWithTouchs:touches];
    UIButton *button = [self rectContainInPoint:point];
    self.currentPoint =  [self pointWithTouchs:touches];
    if (button && button.selected == false) {
        button.selected = true;
        [self.btnArray addObject:button];
    }
    
    [self setNeedsDisplay];
}
/** xib解析完成 */
- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //位置更准确
    [self creatNineButton];
   
}
#pragma mark ------------------
#pragma mark 创建九宫格
- (void)creatNineButton {
    CGFloat hang = 0;
    CGFloat lie = 0;
    
    CGFloat btnW = 74; // 图片本身为74
    CGFloat btnH = 74;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    // 3 为3行和三列
    CGFloat tolCol = (self.bounds.size.width - btnW * kButtonHang) / (kButtonHang + 1);//两列间距
    
    //kDSButtonNums 可以使用 self.subviews 代替
    for (NSInteger i = 0 ; i < kDSButtonNums; i++) {
        
        UIButton *button = self.subviews[i];
        lie = i % kButtonLie;
        hang = i / kButtonHang;
        btnX = tolCol + (tolCol + btnW) * lie;
        btnY = (tolCol + btnH) * hang;
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.btnArray.count == 0) {
        return;
    }
   
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    __block UIButton *button;
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        button = (UIButton *)obj;
        CGPoint point = button.center;
        if (idx == 0) {
           [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }];
    UIColor *color = self.lineColor ? self.lineColor : [UIColor greenColor];
    [color setStroke];
    [path addLineToPoint:_currentPoint];
    
    path.lineWidth = kLineWidth;
    
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}


- (void)loginSuccessStartAnimate {
    
    [UIView animateWithDuration:kDSViewAnimationTimeInterval animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.kDSResultBlock(true,false);
        [self removeFromSuperview];
    }];
}

@end
