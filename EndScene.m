//
//  ResultsPage.m
//  FrenchieTeachieObjects
//
//  Created by Cyril Gaillard on 30/09/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "EndScene.h"
#import "GameSelection.h"
#import "GameStatus.h"
#import "SharedFunctions.h"



@implementation EndScene
@synthesize endSound;

+(id) scene{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];	
	// 'layer' is an autorelease object.
	EndScene *layer = [EndScene node];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

-(void) playSong{
    [bird1 runAction:[CCRepeatForever actionWithAction:walkActionB1]];
    [bird2 runAction:[CCRepeatForever actionWithAction:walkActionB2]];
    [bird3 runAction:[CCRepeatForever actionWithAction:walkActionB3]];
    [bird4 runAction:[CCRepeatForever actionWithAction:walkActionB4]];
    
    id jumpB1 = [CCJumpBy actionWithDuration:4 position:ccp(700,0) height:40 jumps:6];
    id flyB1 = [CCJumpBy actionWithDuration:1 position:ccp(150,220) height:230 jumps:1];
    
    id jumpB2 = [CCJumpBy actionWithDuration:4 position:ccp(600,0) height:50 jumps:6];
    id flyB2 = [CCJumpBy actionWithDuration:1 position:ccp(150,220) height:230 jumps:1];
    
    id jumpB3 = [CCJumpBy actionWithDuration:4 position:ccp(500,0) height:60 jumps:6];
    id flyB3 = [CCJumpBy actionWithDuration:1 position:ccp(150,220) height:230 jumps:1];
    
    id jumpB4 = [CCJumpBy actionWithDuration:4 position:ccp(400,0) height:70 jumps:6];
    id flyB4 = [CCJumpBy actionWithDuration:1 position:ccp(150,240) height:230 jumps:1];

    [bird1 runAction:[CCSequence actions:jumpB1,flyB1, nil]];
    [bird2 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0f],jumpB2,flyB2, nil]];
    [bird3 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:2.0f],jumpB3,flyB3, nil]];
    [bird4 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.0f],jumpB4,flyB4, nil]];
    dancingNote1.visible=YES;
    dancingNote2.visible=YES;
    dancingNote3.visible=YES;
    dancingNote4.visible=YES;
    
    [endSound play];
}
-(void)displayGameSelection:(CCMenuItem *) menuItem {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameSelection scene] withColor:ccc3(0,0,0)]];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [bird1 stopAllActions];
    [bird2 stopAllActions];
    [bird3 stopAllActions];
    [bird4 stopAllActions];
    dancingNote1.duration=0.5f;
    dancingNote2.duration=0.5f;
    dancingNote3.duration=0.5f;
    dancingNote4.duration=0.5f;
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameSelection scene] withColor:ccc3(0,0,0)]];
}

-(void) showSelectionPage {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameSelection scene] withColor:ccc3(0,0,0)]];
}

-(id) init 
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        CGSize size=[[CCDirector sharedDirector] winSize];
        displayBackSelButton(self);
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"EndScene.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"EndScene.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"EndSceneBG.png"];
        [spritesNode addChild:background];
        background.position = ccp(size.width/2,size.height/2);
        
        CCAnimation *walkAnimB1 = [CCAnimation animation];
        CCAnimation *walkAnimB2 = [CCAnimation animation];
        CCAnimation *walkAnimB3 = [CCAnimation animation];
        CCAnimation *walkAnimB4 = [CCAnimation animation];
        for(int i = 1; i <= 15; ++i) {
            [walkAnimB1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName :[NSString stringWithFormat:@"1styellowbird%04d.png",i]]];
            [walkAnimB2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName :[NSString stringWithFormat:@"2ndyellowbird%04d.png",i]]];
            [walkAnimB3 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName :[NSString stringWithFormat:@"3rdBird%04d.png",i]]];
            [walkAnimB4 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName :[NSString stringWithFormat:@"4thBird%04d.png",i]]];
			
        }
        bird1 = [CCSprite spriteWithSpriteFrameName:@"1styellowbird0001.png"];
        bird2 = [CCSprite spriteWithSpriteFrameName:@"2ndyellowbird0001.png"];
        bird3 = [CCSprite spriteWithSpriteFrameName:@"3rdBird0001.png"];
        bird4 = [CCSprite spriteWithSpriteFrameName:@"4thBird0001.png"];
        [self addChild:bird1];
        bird1.position=ccp(40,40);
        [self addChild:bird2];
        bird2.position=ccp(0,40);
        [self addChild:bird3];
        bird3.position=ccp(-40,40);
        [self addChild:bird4];
        bird4.position=ccp(-80,40);
        
        walkActionB1=[CCAnimate actionWithDuration:0.25f animation:walkAnimB1 restoreOriginalFrame:NO];
        [walkActionB1 retain];
        walkActionB2=[CCAnimate actionWithDuration:0.25f animation:walkAnimB2 restoreOriginalFrame:NO];
        [walkActionB2 retain];
        walkActionB3=[CCAnimate actionWithDuration:0.25f animation:walkAnimB3 restoreOriginalFrame:NO];
        [walkActionB3 retain];
        walkActionB4=[CCAnimate actionWithDuration:0.25f animation:walkAnimB4 restoreOriginalFrame:NO];
        [walkActionB4 retain];
        
        dancingNote1 = [CCParticleSystemQuad particleWithFile:@"note.plist"];
        [bird1 addChild:dancingNote1 z:3];
        dancingNote1.position=ccp(30,30);
        dancingNote1.totalParticles=7;
        [dancingNote1 resetSystem];
        dancingNote1.visible=NO; 
        
        dancingNote2 = [CCParticleSystemQuad particleWithFile:@"note.plist"];
        [bird2 addChild:dancingNote2 z:3];
        dancingNote2.position=ccp(90,60);
        dancingNote2.totalParticles=7;
        [dancingNote2 resetSystem];
        dancingNote2.visible=NO;
        
        dancingNote3 = [CCParticleSystemQuad particleWithFile:@"note.plist"];
        [bird3 addChild:dancingNote3 z:3];
        dancingNote3.position=ccp(90,60);
        dancingNote3.totalParticles=7;
        [dancingNote3 resetSystem];
        dancingNote3.visible=NO;
        
        dancingNote4 = [CCParticleSystemQuad particleWithFile:@"note.plist"];
        [bird4 addChild:dancingNote4 z:3];
        dancingNote4.position=ccp(90,60);
        [dancingNote4 resetSystem];
        dancingNote4.totalParticles=7;
        dancingNote4.visible=NO;
        
        NSInteger gameNumber = [[[GameStatus sharedGameStatus] gameNumber] intValue];
        NSString *winningSong = [NSString stringWithFormat:@"Comptine%02d.mp3",gameNumber];
        NSURL *pathFinishSong = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],winningSong]];
        endSound = [[AVAudioPlayer alloc] initWithContentsOfURL:pathFinishSong error:NULL];
        endSound.delegate = self;
        [endSound prepareToPlay];
        [self performSelector:@selector(playSong) withObject:nil afterDelay:1.0];
                
	}
	return self;
}

- (void) onExit{
    [endSound stop];
    clearTextures(spritesNode);
    [super onExit];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    
    [walkActionB1 release];
    [walkActionB2 release];
    [walkActionB3 release];
    [walkActionB4 release];
    [endSound release];

	// don't forget to call "super dealloc"
    [super dealloc];
	
}

@end
