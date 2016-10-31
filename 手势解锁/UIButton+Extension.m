//
//  UIButton+Extension.m
//  手势解锁
//
//  Created by dsperson on 2016/10/30.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>
@implementation UIButton (Extension)


- (void)haha:(NSMutableArray *)sender {
    
    NSLog(@"真的进来了啊");
}


+ (BOOL)resolveClassMethod:(SEL)sel {
    
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(haha:)) {
        NSLog(@"-----button");
        return self;
    }
    return nil;
}

@end
