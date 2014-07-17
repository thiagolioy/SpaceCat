//
//  THSpaceCatNode.h
//  Space Cat
//
//  Created by Amit Bijlani on 5/14/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THSpaceCatNode : SKSpriteNode

+ (instancetype) spaceCatAtPosition:(CGPoint)position;

- (void) performTap;

@end
