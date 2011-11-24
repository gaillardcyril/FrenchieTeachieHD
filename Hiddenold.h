//
//  LevelSelection.h
//  MooeeMath
//
//  Created by Cyril Gaillard on 20/12/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "InstructionsLayer.h"
#import "PauseLayer.h"
#import "NavigationMenuLayer.h"
#import "GameOverLayer.h"


@interface Hidden : CCLayer
{	
    CGSize size;
	ALuint instructionSoundID;
	NSDictionary *levelItems;
    CCMenu *navMenu;
    NSString *gameName;
    NSInteger totalItems;
	NSMutableArray *numberToFindArray;
	NSInteger numberofIterations;
	NSInteger currentNumberIndex;
    CCMenu *numberMenu;
	ALuint correctSpriteSoundID;
    NSInteger score;
    CCParticleSystemQuad  *emitter1;
    NSInteger consecGoodAnswers;
    NSInteger numTips;
    NSInteger voiceChoice;
    PauseLayer *pauseLayer;
    NavigationMenuLayer *navMenuLayer;
    GameOverLayer *gameOverLayer;
    InstructionsLayer *instructionsLayer;
    CCLabelBMFont *nameOfItem;
    NSMutableArray* itemNameArray;

}

+(id) scene;
-(void) loadObjectsToFind;
-(void) startPlaying;
-(void) playNumberSound;

@property(nonatomic,retain) NSMutableArray *numberToFindArray;
@property(nonatomic,retain) NSMutableArray *pickedNumbers;
@end
