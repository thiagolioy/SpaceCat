//
//  THTitleScene.m
//  Space Cat
//
//  Created by Amit Bijlani on 5/14/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THTitleScene.h"
#import "THGamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface THTitleScene ()
@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end


@implementation THTitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
            
        
    }
    return self;
}


- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self runAction:self.pressStartSFX];
    [self.backgroundMusic stop];
    
    THGamePlayScene *gamePlayScene = [THGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

@end















