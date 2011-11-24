//
//  LevelSelection.m
//  MooeeMath
//
//  Created by Cyril Gaillard on 20/12/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "Hidden.h"
#import "GameStatus.h"
#import "HiddenObject.h"
#import "GameSelection.h"
#import "SharedFunctions.h"
#import "EndScene.h"
#import "CCLabelBMFontMultiline.h"

@implementation Hidden
@synthesize numberToFindArray;
@synthesize pickedNumbers,levelBatch;

+(id) scene{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];	
	// 'layer' is an autorelease object.
	Hidden *layer = [Hidden node];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

-(void) playNumberSound{
    if (voiceChoice == 0 || voiceChoice == 2) {
        //NSInteger nameIdx = [[[GameStatus sharedGameStatus].idxArray objectAtIndex:randomIdx] intValue];
        NSString *soundStr = [NSString stringWithFormat:@"%@%02d.mp3",gameName,currentNumberIndex];
        [[SimpleAudioEngine sharedEngine] playEffect:soundStr];
    }
    
}

-(void)removeInstructionsLayer{
    navMenuLayer.navMenu.isTouchEnabled=YES;
    [instructionsLayer removeFromParentAndCleanup:YES];
    [instructionsLayer release];
    [self schedule:@selector(doStep:)];
    [self startPlaying];
}
-(void)discardInstrLayer{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeInstructionsLayer];
}

-(void)discardFailedLayer{
    navMenuLayer.navMenu.isTouchEnabled=YES;
    if(gameOverLayer){
        [gameOverLayer removeFromParentAndCleanup:YES];
        [gameOverLayer release];
        gameOverLayer=nil;
    }    
}

-(void)showInstructionsLayer{
    navMenuLayer.navMenu.isTouchEnabled=NO;
    instructionsLayer =[[InstructionsLayer alloc]initWithParent:self];
    [self addChild:instructionsLayer z:9];
    [self performSelector:@selector(removeInstructionsLayer) withObject:nil afterDelay:10.0f];    
}

-(void)showFailedLayer{
    navMenuLayer.navMenu.isTouchEnabled=NO;
    gameOverLayer = [[GameOverLayer alloc] initWithParent:self];
    [self addChild:gameOverLayer z:10];    
}

-(void) displayNavMenu{
    navMenuLayer = [[NavigationMenuLayer alloc] initWithParent:self];
    [self addChild:navMenuLayer z:10];
}

-(void)updateHelpMenu{
    CCMenu* hMenu = (CCMenu*)[navMenuLayer getChildByTag:99];
    CCMenuItemSprite *hButton=(CCMenuItemSprite *)[hMenu getChildByTag:99];
    CCLabelBMFont *hButtonLabel = (CCLabelBMFont *)[hButton getChildByTag:100];
    NSString *helpLeft= [NSString stringWithFormat:@"%d",numTips];
    [hButtonLabel setString:helpLeft];
    if (numTips==0){
        [hButton setIsEnabled:NO]; 
        [hButton setOpacity:100];
        [hButtonLabel setOpacity:100];
    }
    else{
        [hButton setOpacity:250];
        [hButtonLabel setOpacity:250];
        [hButton setIsEnabled:YES]; 
    }
}


- (void) showPausePage{	
    navMenuLayer.navMenu.isTouchEnabled=NO;
    navMenuLayer.navMenu.isTouchEnabled=NO;
    pauseLayer = [[PauseLayer alloc] initWithParent:self] ;
    [self addChild:pauseLayer z:20];
}

- (void) discardPauseLayer{	
    navMenuLayer.navMenu.isTouchEnabled=YES;
    if (pauseLayer) {
        [pauseLayer removeFromParentAndCleanup:YES];
        [pauseLayer release];
        pauseLayer=nil;
    }
}

-(void)showEndScene{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[EndScene scene] withColor:ccc3(0,0,0)]];
}


-(void)startPlaying{
	if (numberofIterations < totalItems){		
       currentNumberIndex = [[[[GameStatus sharedGameStatus] idxArray] objectAtIndex:numberofIterations] intValue];
        if ((voiceChoice == 0 || voiceChoice == 2) ) {
            [nameOfItem setString:[itemNameArray objectAtIndex:currentNumberIndex]];
        }
		[self performSelector:@selector(playNumberSound)  withObject:nil afterDelay:0.7];
	}
	else {
        for (HiddenObject *object in objects) {
            object.objFound=YES;
        }
		gameEnded(self,score,totalItems);
	}
}

-(void)showCorrectAnswer{
    CCSprite *correctAns=(CCSprite*)[self getChildByTag:currentNumberIndex];
    shakeNumberSprite(correctAns);
    numTips--;
    [self updateHelpMenu];    
}

-(void)checkAnswer:(NSInteger) tag{
    if (currentNumberIndex==tag){
        HiddenObject *correctAns=(HiddenObject*)[self getChildByTag:currentNumberIndex];
        emitter1.position =  correctAns.position;
        emitter1.visible=YES;
        [emitter1 resetSystem];
        correctAns.objFound=YES;
        [correctAns runAction:[CCFadeOut actionWithDuration:0.7]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"poof.mp3"];
        score++;
        consecGoodAnswers++;
        if (consecGoodAnswers==3) {
            if(numTips<3)numTips++;
            consecGoodAnswers=0;
            [self updateHelpMenu];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"youpi.mp3"];        
    }
    else{
        [[SimpleAudioEngine sharedEngine] playEffect:@"honk.mp3"];
        consecGoodAnswers=0;
    }
    numberofIterations++;
    [self startPlaying];
}

-(void) loadObjectsToFind{
	NSInteger numberIndex;
	NSInteger xCoordObj;
	NSInteger yCoordObj;
	
    NSString *frameName;
	for (numberIndex = 0; numberIndex < [[levelItems objectForKey:@"Xcoordinates"] count]; numberIndex++) {
        
        frameName = [NSString stringWithFormat:@"%@%02d.png",gameName,numberIndex];
		HiddenObject *numberToFind = [HiddenObject spriteWithSpriteFrameName:frameName];
        
		xCoordObj = [[[levelItems objectForKey:@"Xcoordinates"]objectAtIndex:numberIndex] intValue];
		yCoordObj = [[[levelItems objectForKey:@"Ycoordinates"]objectAtIndex:numberIndex] intValue];
		
		numberToFind.tag = numberIndex;
		numberToFind.position = ccp(xCoordObj,yCoordObj);
        [objects addObject:numberToFind];
	}
    for (HiddenObject *object in objects) {
        [self addChild:object];
    }
    
}

- (void)doStep:(ccTime)delta
{
    for (HiddenObject *object in objects) {
        if ([object isTouched]) {
            [object touchAck];
            //NSLog(@"the object %d has been touched",object.tag);
            [self checkAnswer:object.tag];
        }
    }
}

- (void) resetGame{
    numberofIterations=0;
    numTips=3;
    score=0;
    [self discardPauseLayer];
    [self discardFailedLayer];
    for (HiddenObject *object in objects) {
        object.objFound=NO;
        [object runAction:[CCFadeIn actionWithDuration:0.5]];        
    }
    [self updateHelpMenu];
    [self startPlaying];
}

-(id) init{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
        [self displayNavMenu];
        
        size = [[CCDirector sharedDirector] winSize];
        
        NSInteger gameNumber = [[[GameStatus sharedGameStatus] gameNumber] intValue];
        totalItems = [[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"totalItems"] objectAtIndex:gameNumber] intValue];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"dinnerBell.wav"];
        
        [[GameStatus sharedGameStatus] initIdxArray:totalItems];
        [[[GameStatus sharedGameStatus]idxArray]shuffle];
        gameName = [[GameStatus sharedGameStatus] gameName];
        NSString *coordpList = [gameName stringByAppendingString:@"Coord"];
        levelItems = read_pList(coordpList);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ItemNames" ofType:@"plist"];
        NSMutableDictionary *itemNameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        itemNameArray =[[NSMutableArray alloc] initWithArray: [itemNameDict objectForKey:gameName] copyItems:YES ];
        [itemNameDict release];
        objects=[[NSMutableArray alloc] init];
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        gameName = [[GameStatus sharedGameStatus] gameName];
        levelBatch = loadBatchNode(self, gameName);
        [self addChild:levelBatch];
        NSString *gameBG = [gameName stringByAppendingString:@"BG.png"];
		displayBackground (levelBatch,gameBG);
        
        numberofIterations = 0;
        score = 0;
        emitter1 = [CCParticleSystemQuad particleWithFile:@"cloud.plist"];
        emitter1.visible=NO;
        [self addChild:emitter1 z:99];
        [self loadObjectsToFind];
        
        consecGoodAnswers=0;
        numTips = 3;
		nameOfItem= [CCLabelBMFont labelWithString:@"" fntFile:@"KidsFont52.fnt"];
        nameOfItem.position = ccp(size.width/2,size.height-30);
        [self addChild:nameOfItem z:3];
        voiceChoice=[[NSUserDefaults standardUserDefaults] integerForKey:@"voiceChoice"];
        
        
        if ([[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"FirstTimePlayed"] intValue]) {
            [[[GameStatus sharedGameStatus]gameStatusList] setObject:[NSNumber numberWithInt:0] forKey:@"FirstTimePlayed"];
            [[GameStatus sharedGameStatus] updatePListFile];
            [self showInstructionsLayer];
            
        }
        else{
            [self schedule:@selector(doStep:)];
            [self startPlaying];
            }
        displayAd(GAD_SIZE_468x60);
    }
	return self;
}

-(void) onExit{
    removeAd();
    clearTextures(levelBatch);
	[super onExit];
    
}

- (void) dealloc{
    [objects release];    
    [navMenuLayer release];
	[pickedNumbers release];
    [super dealloc];
}
@end
