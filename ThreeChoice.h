//
//  LevelSelection.h
//  MooeeMath
//
//  Created by Cyril Gaillard on 20/12/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InstructionsLayer.h"
#import "PauseLayer.h"
#import "GameOverLayer.h"
#import "NavigationMenuLayer.h"

@interface ThreeChoice : CCLayer{
    NSInteger numberIterations;
    CCMenu *itemsMenu;
    CGSize size;
    NSString *gameName;
    NSInteger randomIdx;
    NSInteger totalItems;
    NSInteger score;
    CCParticleSystemQuad *emitter1;
	CCParticleSystemQuad *emitter2;
	CCParticleSystemQuad *emitter3;
    NSInteger consecGoodAnswers;
    CCLabelBMFont *nameOfItem;    
    NSInteger numTips;
    GameOverLayer *gameOverLayer;
    NSMutableArray* itemNameArray;
    NSInteger voiceChoice;
    NSInteger gameNumber;
    PauseLayer *pauseLayer;
    InstructionsLayer *instructionsLayer;
    NavigationMenuLayer *navMenuLayer;
    BOOL gameFinished;
    CCSpriteBatchNode *levelBatch;
}
+(id) scene;
-(void)placeItems;
-(void) startPlaying;

@end
