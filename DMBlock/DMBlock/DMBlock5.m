//
//  DMBlock5.m
//  DMBlock
//
//  Created by lbq on 2018/6/2.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "DMBlock5.h"
typedef int (^blk_t)(int);
@implementation DMBlock5

blk_t func(int rate){
    blk_t bk = ^(int count){
        return rate * count;
    };
    return bk;
}
@end
