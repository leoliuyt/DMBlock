//
//  DMBlock3.m
//  DMBlock
//
//  Created by lbq on 2018/6/2.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "DMBlock3.h"
@interface DMBlock3()
{
    int(^copyBlock)(int);
}
@end

@implementation DMBlock3

- (void)dm_method
{
    int multiplier = 4;
    int(^MyBlock)(int) = ^int(int num){
        return num * multiplier;
    };
//    copyBlock = [MyBlock copy];
    MyBlock(2);
    NSLog(@"%@",MyBlock);
    /*
     截获变量：
     <__NSMallocBlock__: 0x174446690>
     不截获变量：
     <__NSGlobalBlock__: 0x10000c370>
     */
}
@end
