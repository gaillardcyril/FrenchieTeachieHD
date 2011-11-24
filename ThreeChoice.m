//
//  LevelSelection.m
//  MooeeMath
//
//  Created by Cyril Gaillard on 20/12/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "ThreeChoice.h"
#import "GameSelection.h"
#import "GameStatus.h"
#import "EndScene.h"
#import "AppDelegate.h"
#import "CCLabelBMFontMultiline.h"
#import "SharedFunctions.h"


@implementation ThreeChoice

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];	
	// 'layer' is an autorelease object.
	ThreeChoice *layer = [ThreeChoice node];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}



-(void)showEndScene{
[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[EndScene scene] withColor:ccc3(0,0,0)]];
}

-(void) playNumberSound{
    if (numberIterations < totalItems ){
        
        if (voiceChoice == 0 || voiceChoice == 2) {
            NSInteger nameIdx = [[[GameStatus sharedGameStatus].idxArray objectAtIndex:numberIterations] intValue];
         NSString *soundStr = [NSString stringWithFormat:@"%@%02d.mp3",gameName,nameIdx];
        [[SimpleAudioEngine sharedEngine] playEffect:soundStr];
        }
    }
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



-(void) displayNavMenu{
    navMenuLayer = [[NavigationMenuLayer alloc] initWithParent:self];
    [self addChild:navMenuLayer z:10];
}

-(void)discardFailedLayer{
    navMenuLayer.navMenu.isTouchEnabled=YES;
    itemsMenu.isTouchEnabled=YES;
    if(gameOverLayer){
        [gameOverLayer removeFromParentAndCleanup:YES];
        [gameOverLayer release];
        gameOverLayer=nil;
    }    
}
-(void)showFailedLayer{
    navMenuLayer.navMenu.isTouchEnabled=NO;
    itemsMenu.isTouchEnabled=NO;
    gameOverLayer = [[GameOverLayer alloc] initWithParent:self];
    [self addChild:gameOverLayer z:10];    
}

- (void) showPausePage{	
    //[[CCDirector sharedDirector] replaceScene:[GameSelection scene]];
    
    itemsMenu.isTouchEnabled=NO;
    navMenuLayer.navMenu.isTouchEnabled=NO;
    pauseLayer = [[PauseLayer alloc] initWithParent:self];
    [self addChild:pauseLayer z:20];
}

-(void)removeInstructionsLayer{
    
    navMenuLayer.navMenu.isTouchEnabled=YES;
    itemsMenu.isTouchEnabled=YES;
    [instructionsLayer removeFromParentAndCleanup:YES];
    [instructionsLayer release];
    emitter1.visible = emitter2.visible = emitter3.visible= YES;
    [self startPlaying];
}


-(void)discardInstrLayer{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeInstructionsLayer];
}

-(void)showInstructionsLayer{    
    navMenuLayer.navMenu.isTouchEnabled=NO;
    itemsMenu.isTouchEnabled=NO;
    instructionsLayer =[[InstructionsLayer alloc]initWithParent:self];
    [self addChild:instructionsLayer z:9];
    [self performSelector:@selector(removeInstructionsLayer) withObject:nil afterDelay:10.0f];    
}

- (void) discardPauseLayer{	
    itemsMenu.isTouchEnabled=YES;
    navMenuLayer.navMenu.isTouchEnabled=YES;
    if (pauseLayer) {
        [pauseLayer removeFromParentAndCleanup:YES];
        [pauseLayer release];
        pauseLayer=nil;
    }
}

-(void)showCorrectAnswer {
    shakeNumberToPick(itemsMenu,randomIdx);
    numTips--;
    [self updateHelpMenu];    
}

-(void)checkAnswer: (CCMenuItem *) menuItem{
   // NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);

    if (numberIterations < totalItems ) {
        //NSLog(@"in the check loop");
        if (menuItem.tag==randomIdx) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"youpi.mp3"];
            score++;
            consecGoodAnswers++;
            if (consecGoodAnswers==3) {
                if(numTips<3) numTips++;
                consecGoodAnswers=0;
                [self updateHelpMenu];
            }
        }
        else{
            [[SimpleAudioEngine sharedEngine] playEffect:@"honk.mp3"];
            consecGoodAnswers=0;
        }
        numberIterations++;
        [self startPlaying];
    }
    
}

-(void)fillItemsIdxArr:(NSMutableArray*)idxArr with:(NSInteger)rdxValue{
    //NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
    [idxArr addObject:[NSNumber numberWithInt: rdxValue]];
    NSInteger itemIdx2;
    do {
        itemIdx2=arc4random()%totalItems;
    } while (itemIdx2==rdxValue);
    [idxArr addObject:[NSNumber numberWithInt:itemIdx2]];
    NSInteger itemIdx3;
    do {
        itemIdx3=arc4random()%totalItems;
    } while (itemIdx3==rdxValue || itemIdx2 == itemIdx3);
    [idxArr addObject:[NSNumber numberWithInt:itemIdx3]];
    //NSLog(@"idx arr %@",idxArr);
    
}

-(void)placeItems{
    //NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
    CCMenuItemSprite *numberItem;
    CCSprite *itemSprite;
    if ((voiceChoice == 0 || voiceChoice == 2) && gameNumber!=7 ) {
        NSInteger nameIdx = [[[GameStatus sharedGameStatus].idxArray objectAtIndex:numberIterations] intValue];
        [nameOfItem setString:[itemNameArray objectAtIndex:nameIdx]];
    }
    
    NSInteger idxToDisplay = [[[GameStatus sharedGameStatus].idxArray objectAtIndex:numberIterations] intValue];
    
    NSMutableArray *itemsIdxArr=[[NSMutableArray alloc] init];
    [self fillItemsIdxArr:itemsIdxArr with:idxToDisplay];
    NSInteger intToSave = [[itemsIdxArr objectAtIndex:randomIdx] intValue];
    [itemsIdxArr replaceObjectAtIndex:randomIdx withObject:[itemsIdxArr objectAtIndex:0]];
    [itemsIdxArr replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:intToSave]];
        
    for(NSInteger i=0;i<3;i++){   
        NSInteger idxToDisplay = [[itemsIdxArr objectAtIndex:i ] intValue];
        NSString *itemStr = [NSString stringWithFormat:@"%@%02d.png",gameName,idxToDisplay];
     itemSprite = [CCSprite spriteWithSpriteFrameName:itemStr];
     emitter1 = [CCParticleSystemQuad particleWithFile:@"cloud.plist"];
     emitter1.visible=YES;
     emitter1.scale=2.5;
     emitter1.duration = 0.6;
     emitter1.position=ccp(80,80);
     [emitter1 resetSystem];    
     [itemSprite addChild:emitter1]; 
     
     numberItem =[CCMenuItemSprite itemFromNormalSprite:itemSprite selectedSprite:nil target: self selector: @selector(checkAnswer:)];  
     numberItem.tag = i;
     [itemsMenu addChild:numberItem];
     }
    
}

-(void) startPlaying{
    //NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
        if (numberIterations>0) {
        [self removeChild:itemsMenu cleanup:YES];
        itemsMenu=nil;
    } 
    //NSLog(@"numbers of iteration %d, %d",numberIterations, totalItems);

    if (numberIterations < totalItems) {  
        //NSLog(@"in the playing loop");

        itemsMenu = [CCMenu menuWithItems:nil];
        randomIdx = floor(arc4random()%3);
        //randomIdx=0;
        [self placeItems];
        [self addChild:itemsMenu z:4];
        //itemsMenu.visible=NO;
        [[SimpleAudioEngine sharedEngine] playEffect:@"poof.mp3"];   
        [itemsMenu setOpacity:0];
        [itemsMenu runAction:[CCFadeIn actionWithDuration:1.0]];
        [itemsMenu alignItemsHorizontallyWithPadding:80];        
        itemsMenu.position = ccp(size.width/2,size.height/2-100);
        [self performSelector:@selector(playNumberSound) withObject:nil afterDelay:0.7];
    }
    else{
        //NSLog(@"game finished");
        //NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
        gameFinished=YES;
        gameEnded(self,score,totalItems);
    }
}

-(void)resetGame{
    //NSLog((@"%s [Line %d] "), __PRETTY_FUNCTION__, __LINE__);
    numberIterations=0;
    numTips=3;
    gameFinished=NO;
    score=0;
    [self discardPauseLayer];
    [self discardFailedLayer ];
    [self removeChild:itemsMenu cleanup:YES];
    [self updateHelpMenu];
    [self startPlaying];
}

-(id) init{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
				
		//[[GameStatus sharedCurrentLevel] setLevelNumber:[NSNumber numberWithInt:1]];
		//[[CurrentLevel sharedCurrentLevel] setCurrentScore:[NSNumber numberWithInt:0]];
		// ask director the the window size
        size = [[CCDirector sharedDirector] winSize];
        
        //displayNavMenu(self, navMenu);
        [self displayNavMenu];
        gameNumber = [[[GameStatus sharedGameStatus] gameNumber] intValue];
        totalItems = [[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"totalItems"] objectAtIndex:gameNumber] intValue];
       
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
        NSString *gameStr = [[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameName"]objectAtIndex:gameNumber];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ItemNames" ofType:@"plist"];
        NSMutableDictionary *itemNameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        itemNameArray =[[NSMutableArray alloc] initWithArray: [itemNameDict objectForKey:gameStr] copyItems:YES ];
        [itemNameDict release];

        [[GameStatus sharedGameStatus] initIdxArray:totalItems];
        [[GameStatus sharedGameStatus].idxArray shuffle];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"dinnerBell.wav"];
        
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        gameName = [[GameStatus sharedGameStatus] gameName];
        levelBatch = loadBatchNode(self, gameName);
                                
        NSString *gameBG = [gameName stringByAppendingString:@"BG.png"];
		displayBackground (levelBatch,gameBG);
        gameFinished=NO;
        //NSLog(@"the game name is -%@-",gameName);
        if ([gameName isEqualToString:@"Colors"]||[gameName isEqualToString:@"Alphabet"] ||[gameName isEqualToString:@"Numbers"]) {
            CCSprite *stringPeg=[CCSprite spriteWithSpriteFrameName:@"AlphabetString.png"];
            stringPeg.position=ccp(size.width/2,size.height/2+100);
            [self addChild:stringPeg z:6];
        }
        
        numberIterations = 0; 
        score=0;
        
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
            [self startPlaying];
            emitter1.visible = emitter2.visible =emitter3.visible= YES;
        }
        displayAd(GAD_SIZE_728x90);
    }
    return self;
}
-(void)onExit{
    removeAd();
    clearTextures(levelBatch);
    [super onExit];
    
}
-(void)dealloc{
    [navMenuLayer release];
    [itemNameArray release];
    [super dealloc];
    }    
@end
