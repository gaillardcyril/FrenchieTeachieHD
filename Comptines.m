//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//
#import "Comptines.h"
#import "HomePage.h"
#import "AppDelegate.h"
#import "GameStatus.h"
#import "SharedFunctions.h"
#import "CCScrollLayer.h"
#import "CCLabelBMFontMultiline.h"

#define MENU_ITEM_SIZE 60
@implementation Comptines
@synthesize walkAction,bird1,bird2,bird3,bird4;
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Comptines *layer = [Comptines node];
	
	// add layer as a child to scene
	[scene addChild: layer];
		
	// return the scene
	return scene;
}

-(void) displayMenuAligned:(CCMenu *)menu{
    NSInteger xPos0=150;
    NSInteger yPos0=650;
    NSInteger yPadding = 100;
    NSInteger yPos=yPos0;
    for (CCMenuItem* menuItem in menu.children){
        menuItem.anchorPoint=ccp(0,0);
        menuItem.position = ccp(xPos0,yPos);
            yPos-=yPadding;
        }  
}

-(void)moveBirds{    
    [bird1 walkForEver];
    [bird2 walkForEver];
    [bird3 walkForEver];
    [bird4 walkForEver];
    [self moveBird:nil];
    [self schedule:@selector(moveBird:)  interval:6];
    
}

-(void) moveBird:(id)sender{
    if (birdsShouldFly) {
        [bird1 flyAcrossScreenWithDelay:0];
        [bird2 flyAcrossScreenWithDelay:0.2f];
        [bird3 flyAcrossScreenWithDelay:0.5f];
        [bird4 flyAcrossScreenWithDelay:0.7f];
    }
}

-(void)playComptine:(CCMenuItem *) menuItem {
    
    if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {  
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    }
    birdsShouldFly=YES;
    if (birdsAreWalking==NO) {
        [self moveBirds];
        birdsAreWalking=YES;
    } 
    NSString *comptineStr = [NSString stringWithFormat:@"Comptine%02d.mp3",menuItem.tag];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:comptineStr loop:NO];
    
    
}
-(void)stopComptine{
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic]; 
    birdsShouldFly=NO;
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}

-(void)checkSong:(ccTime)dt
{
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
    birdsShouldFly=NO;
    }
} 



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // ask director the the window size
		size = [[CCDirector sharedDirector] winSize];
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"HomePage.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HomePage.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"homeBG.png"];
        [spritesNode addChild:background];
        
        background.position = ccp(size.width/2,size.height/2);
                        
        displayBackHomeButton(self);
        
        NSMutableArray *gameCompletedList = [[NSMutableArray alloc] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"]];
        NSInteger numberOfComptines=0;
        
        NSMutableArray *layersArray=[[NSMutableArray alloc] init]; 
        
        for (NSInteger i=0; i<[gameCompletedList count]; i++) {
        if ([[gameCompletedList objectAtIndex:i] intValue]) {
            numberOfComptines++;
            CCLayer *l1 = [[CCLayer alloc] init];
            NSString *comptineName = [[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"ComptineName"] objectAtIndex:i];
            //CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"Layer 1" fontName:@"Marker Felt" fontSize:64];
            CCLabelBMFontMultiline *label1= [CCLabelBMFontMultiline labelWithString:comptineName fntFile:@"KidsFont110.fnt" width:size.width*0.8 alignment:CenterAlignment];
            //label1.anchorPoint=ccp(0.5,1);
            [l1 addChild:label1];
            label1.position=ccp(size.width/2,size.height-150);
            
            CCMenuItemImage *menuItemStopSong =[CCMenuItemImage itemFromNormalImage:@"stopButton.png" selectedImage: @"stopButtonS.png" target:self selector:@selector(stopComptine)];
            
            CCMenuItemImage *menuItemPlaySong =[CCMenuItemImage itemFromNormalImage:@"continueButton.png" selectedImage: @"continueButtonS.png" target:self selector:@selector(playComptine:)];
            menuItemPlaySong.tag = i;
            
            CCMenu *playerMenu = [CCMenu menuWithItems:menuItemStopSong,menuItemPlaySong, nil];
            [playerMenu alignItemsHorizontallyWithPadding:20];
            playerMenu.position = ccp(size.width/2,size.height/2-100);
            [l1 addChild:playerMenu];
            [layersArray addObject:l1];
            [l1 release];
            }
        }
        
        [gameCompletedList release];
        
        if (!numberOfComptines) {
            CCLabelBMFontMultiline *credits = [CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"comptinesDefault", nil) fntFile:@"KidsFont110.fnt" width:size.width*0.8 alignment:CenterAlignment];
            credits.position = ccp(size.width/2,size.height/2);
            [self addChild:credits z:3];
                        
        }
        
        CCScrollLayer *scrollLayer =[[CCScrollLayer alloc] initWithLayers:layersArray widthOffset:0];
        scrollLayer.showPagesIndicator=NO;
        scrollLayer.minimumTouchLengthToSlide=10.0f;
        scrollLayer.minimumTouchLengthToChangePage=30.0f;
        [self addChild:scrollLayer z:5];
        [scrollLayer release];
        [layersArray release];
    
        bird1 = [Bird spriteWithSpriteFrameName:@"1styellowbird0001.png"];
        [bird1 initAnimationsWithName:@"1styellowbird"];
        bird1.position=ccp(1200,20);
        [self addChild:bird1];
        
        bird2=[Bird spriteWithSpriteFrameName:@"2ndyellowbird0001.png"];
        [bird2 initAnimationsWithName:@"2ndyellowbird"];
        bird2.position=ccp(1200,20);
        [self addChild:bird2];
        
        bird3=[Bird spriteWithSpriteFrameName:@"3rdBird0001.png"];
        [bird3 initAnimationsWithName:@"3rdBird"];
        bird3.position=ccp(1200,20);
        [self addChild:bird3];
        
        bird4=[Bird spriteWithSpriteFrameName:@"4thBird0001.png"];
        [bird4 initAnimationsWithName:@"4thBird"];
        bird4.position=ccp(1200,20);
        [self addChild:bird4];  
        birdsShouldFly = NO;
        birdsAreWalking = NO;
        displayAd(GAD_SIZE_728x90);
        [self schedule:@selector(checkSong:) interval:0.5f];
	}
	return self;
}

-(void)onExit{
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    clearTextures(spritesNode);
    removeAd();
    [super onExit];

}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [walkAction release];

	[super dealloc];
}

@end
