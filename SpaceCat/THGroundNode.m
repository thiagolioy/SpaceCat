//
//  THGroundNode.m
//  Space Cat
//
//  Created by Amit Bijlani on 5/17/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THGroundNode.h"
#import "THUtil.h"

@implementation THGroundNode

+ (instancetype) groundWithSize:(CGSize)size {
    THGroundNode *ground = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    ground.name = @"Ground";
    ground.position = CGPointMake(size.width/2,size.height/2);
    [ground setupPhysicsBody];
    
    return ground;
}


- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = THCollisionCategoryGround;
    self.physicsBody.collisionBitMask = THCollisionCategoryDebris;
    self.physicsBody.contactTestBitMask = THCollisionCategoryEnemy;
}

@end










