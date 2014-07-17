//
//  THSpaceDogNode.h
//  Space Cat
//
//  Created by Amit Bijlani on 5/17/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, THSpaceDogType) {
    THSpaceDogTypeA = 0,
    THSpaceDogTypeB = 1
};


@interface THSpaceDogNode : SKSpriteNode

+ (instancetype) spaceDogOfType:(THSpaceDogType)type;

@end
