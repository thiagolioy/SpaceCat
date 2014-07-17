//
//  THUtil.h
//  Space Cat
//
//  Created by Amit Bijlani on 5/15/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <Foundation/Foundation.h>


static const int THProjectileSpeed = 400;
static const int THSpaceDogMinSpeed = -100;
static const int THSpaceDogMaxSpeed = -50;
static const int THMaxLives = 1;
static const int THPointsPerHit = 100;

typedef NS_OPTIONS(uint32_t, THCollisionCategory) {
    THCollisionCategoryEnemy        = 1 << 0,       // 0000
    THCollisionCategoryProjectile   = 1 << 1,       // 0010
    THCollisionCategoryDebris       = 1 << 2,       // 0100
    THCollisionCategoryGround       = 1 << 3        // 1000
};


@interface THUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end






















