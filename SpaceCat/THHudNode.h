//
//  THHudNode.h
//  Space Cat
//
//  Created by Amit Bijlani on 5/29/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface THHudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

- (void) addPoints:(NSInteger)points;
- (BOOL) loseLife;

@end
