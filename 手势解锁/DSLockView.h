//
//  DSLockView.h
//  手势解锁
//
//  Created by dsperson on 2016/10/30.
//  Copyright © 2016年 杜帅. All rights reserved.
//

/**
  学习于黑马视频，不是打广告，吃水不忘挖井人而已。
  
  支持XIB和代码创建 XIB 直接 创建的View 继承DSLockView 就可以
  代码创建ViewController 中有例子
  
  有一些属性 我懒得拿出来 可以直接在 .m中找到 比如说线的宽度等 
 
 */

#import <UIKit/UIKit.h>

typedef void (^kDSResultBlock)(BOOL result, BOOL animateComplete);
@interface DSLockView : UIView


/** 线的颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** block回调方式进行判断 */
@property (nonatomic, copy) kDSResultBlock kDSResultBlock;
/** 设置密码 */
@property (nonatomic, strong) NSString *passwordStr;
/** 是否开启动画 默认不开启 很简单的动画 给懒的人写的*/
@property (nonatomic, assign) BOOL openAnimate;
@end
