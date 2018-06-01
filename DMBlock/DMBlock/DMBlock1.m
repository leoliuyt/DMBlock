//
//  DMBlock1.m
//  DMBlock
//
//  Created by leoliu on 2018/5/25.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "DMBlock1.h"

@implementation DMBlock1

- (void)dm_method
{
    void(^MyBlock)(void) = ^(){
        NSLog(@"my block");
    };
    MyBlock();
}
@end
