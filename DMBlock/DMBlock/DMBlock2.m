//
//  DMBlock2.m
//  DMBlock
//
//  Created by leoliu on 2018/5/25.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "DMBlock2.h"

@implementation DMBlock2
- (void)dm_method
{
    __block int multiplier = 4;
    int(^MyBlock)(int) = ^int(int num){
        return num * multiplier;
    };
    MyBlock(2);
}
@end
