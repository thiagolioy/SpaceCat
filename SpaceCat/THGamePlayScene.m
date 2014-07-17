//
//  THGamePlayScene.m
//  Space Cat
//
//  Created by Amit Bijlani on 5/14/14.
//  Copyright (c) 2014 Treehouse. All rights reserved.
//

#import "THGamePlayScene.h"
#import "THMachineNode.h"
#import "THSpaceCatNode.h"
#import "THProjectileNode.h"
#import "THSpaceDogNode.h"
#import "THGroundNode.h"
#import "THUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "THHudNode.h"
#import "THGameOverNode.h"

@interface THGamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplayed;
@end



@implementation THGamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = THSpaceDogMinSpeed;
        self.restart = NO;
        self.gameOver = NO;
        self.gameOverDisplayed = NO;
        
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        THMachineNode *machine = [THMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        THSpaceCatNode *spaceCat = [THSpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y-2)];
        [self addChild:spaceCat];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        THGroundNode *ground = [THGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        [self setupSounds];
        
        THHudNode *hud = [THHudNode hudAtPosition:CGPointMake(0, self.frame.size.height-20) inFrame:self.frame];
        [self addChild:hud];
        
        
        
        
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}


- (void) setupSounds {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];

    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 1;
    [self.gameOverMusic prepareToPlay];

    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( !self.gameOver ) {
        for (UITouch *touch in touches) {
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardsPosition:position];
        }
    } else if ( self.restart ) {
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        
        THGamePlayScene *scene = [THGamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }

}

- (void) performGameOver {
    THGameOverNode *gameOver = [THGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    [gameOver performAnimation];
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
}

- (void) shootProjectileTowardsPosition:(CGPoint)position {
    THSpaceCatNode *spaceCat = (THSpaceCatNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    THMachineNode *machine = (THMachineNode *)[self childNodeWithName:@"Machine"];
    
    THProjectileNode *projectile = [THProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y+machine.frame.size.height-15)];
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX];
    
}

- (void) addSpaceDog {
    NSUInteger randomSpaceDog = [THUtil randomWithMin:0 max:2];
    
    THSpaceDogNode *spaceDog = [THSpaceDogNode spaceDogOfType:randomSpaceDog];
    float dy = [THUtil randomWithMin:THSpaceDogMinSpeed max:THSpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);

    float y = self.frame.size.height + spaceDog.size.height;
    float x = [THUtil randomWithMin:spaceDog.size.width+10 max:self.frame.size.width-spaceDog.size.width-10];
    
    spaceDog.position = CGPointMake(x,y);
    [self addChild:spaceDog];
}


- (void) update:(NSTimeInterval)currentTime {
    if ( self.lastUpdateTimeInterval ) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if ( self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver ) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if ( self.totalGameTime > 480 ) {
        // 480 / 60 = 8 minutes
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = -160;
        
    } else if ( self.totalGameTime > 240 ) {
        // 240 / 60 = 4 minutes
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if ( self.totalGameTime > 20 ) {
        // 120 / 60 = 2 minutes
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if ( self.totalGameTime > 10 ) {
        self.addEnemyTimeInterval = 1.00;
        self.minSpeed = -100;
    }
    
    if ( self.gameOver && !self.gameOverDisplayed ) {
        [self performGameOver];
    }
    
    
}


- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask ) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    if ( firstBody.categoryBitMask == THCollisionCategoryEnemy &&
         secondBody.categoryBitMask == THCollisionCategoryProjectile ) {
        NSLog(@"BAM!");
        
        THSpaceDogNode *spaceDog = (THSpaceDogNode *)firstBody.node;
        THProjectileNode *projectile = (THProjectileNode*)secondBody.node;
        
        [self addPoints:THPointsPerHit];
        
        [self runAction:self.explodeSFX];
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        
    } else if ( firstBody.categoryBitMask == THCollisionCategoryEnemy &&
               secondBody.categoryBitMask == THCollisionCategoryGround ) {
        NSLog(@"Hit ground!");

        [self runAction:self.damageSFX];
        THSpaceDogNode *spaceDog = (THSpaceDogNode *)firstBody.node;
        [spaceDog removeFromParent];
        
        [self loseLife];
    }
    
    [self createDebrisAtPosition:contact.contactPoint];

}

- (void) addPoints:(NSInteger)points{
    THHudNode *hud = (THHudNode*)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

- (void) loseLife {
    THHudNode *hud = (THHudNode*)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}


- (void) createDebrisAtPosition:(CGPoint)position {
    NSInteger numberOfPieces = [THUtil randomWithMin:5 max:20];
    
    
    for (int i=0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [THUtil randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%d",randomPiece];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = THCollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = THCollisionCategoryGround | THCollisionCategoryDebris;
        debris.name = @"Debris";
        
        debris.physicsBody.velocity = CGVectorMake([THUtil randomWithMin:-150 max:150],
                                                   [THUtil randomWithMin:150 max:350]);
        
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
            [debris removeFromParent];
        }];
        
    }
    
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
    
    
}

@end

















