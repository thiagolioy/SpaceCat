//
//  THUtil.m
//  Space Cat
//
//  Created by Amit Bijlani on 5/15/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THUtil.h"

@implementation THUtil

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random()%(max - min) + min;
}


@end
