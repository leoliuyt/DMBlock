//
//  Block4.m
//  DMBlock
//
//  Created by lbq on 2018/6/2.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "Block4.h"

int(^block1)(void) = ^{return 100;};


static int(^block2)(void) = ^{return 1;};

@implementation Block4

- (void)dm_method
{
    int a = block1();
    NSLog(@"%tu",a);
    
    int b = block2();
    NSLog(@"%tu",b);
}

@end
