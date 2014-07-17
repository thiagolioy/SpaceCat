//
//  THSpaceDogNode.m
//  Space Cat
//
//  Created by Amit Bijlani on 5/17/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THSpaceDogNode.h"
#import "THUtil.h"

@implementation THSpaceDogNode

+ (instancetype) spaceDogOfType:(THSpaceDogType)type {
    THSpaceDogNode *spaceDog;
    
    NSArray *textures;
    
    if ( type == THSpaceDogTypeA ) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"]];
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"]];
    }
    
    float scale = [THUtil randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = THCollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = THCollisionCategoryProjectile | THCollisionCategoryGround; // 0010 | 1000 = 1010
}


@end


















