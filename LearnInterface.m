//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//
#import "LearnInterface.h"
#import "HomePage.h"
#import "AppDelegate.h"
#import "GameStatus.h"
#import "LearnSelection.h"
#import "SharedFunctions.h"


#define MENU_ITEM_SIZE 60
@implementation LearnInterface
@synthesize  levelBatch,scrollLayer;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LearnInterface *layer = [LearnInterface node];
	
	// add layer as a child to scene
	[scene addChild: layer];
		
	// return the scene
	return scene;
}

-(void)onEnterTransitionDidFinish{
    id scrollLeft = [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.6 position:ccp(-100,0)] rate:2];
    //id scrollLeft = [CCMoveBy actionWithDuration:0.6 position:ccp(-100,0)] ;
     //id scrollRight = [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.6 position:ccp(100,0)] rate:3];
    id scrollRight = [CCMoveBy actionWithDuration:0.5 position:ccp(100,0)];
    id scrollSeq = [CCSequence actions:scrollLeft,scrollRight, nil];
    
    [scrollLayer runAction:scrollSeq ];
}

-(void)playWordSound{
    NSInteger pageNum = [scrollLayer currentScreen];
    NSLog(@"page number is %d",pageNum);
    NSString *soundToPlay = [NSString stringWithFormat:@"%@%02d.mp3",gameStr,pageNum];
    NSLog(@"page number is %@",soundToPlay);
    [[SimpleAudioEngine sharedEngine] playEffect:soundToPlay];
    
}

-(void)goBackLearnSelection:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[LearnSelection scene]];    
}

-(void) displayBackSelButton{
    CGSize dSize = [[CCDirector sharedDirector] winSize];
	CCMenuItemImage *menuItemHelpGame =[CCMenuItemImage itemFromNormalImage:@"backArrow.png" selectedImage: nil target:self selector:@selector(goBackLearnSelection:)];	
    
	CCMenu *helpButtonMenu = [CCMenu menuWithItems:menuItemHelpGame, nil];
	helpButtonMenu.position = ccp([menuItemHelpGame contentSize].width/2, dSize.height-[menuItemHelpGame contentSize].height/2);
    
	[self addChild:helpButtonMenu z:10];
}
-(void) tick: (ccTime) dt{
    NSInteger pageNum = [scrollLayer currentScreen];
    //NSLog(@"scroll layer %d",pageNum);
    if (gameNumber!=7) {
        [nameOfItem setString:[itemNameArray objectAtIndex:pageNum]];
    }  
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        size= [[CCDirector sharedDirector] winSize];
        
        gameNumber = [[[GameStatus sharedGameStatus] gameNumber] intValue];
        totalItems = [[[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"totalItems"] objectAtIndex:gameNumber] intValue];	
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
        spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"HomePage.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HomePage.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"homeBG.png"];
        [spritesNode addChild:background];
        background.position = ccp(size.width/2,size.height/2);
        
        [self displayBackSelButton];
        
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
                
        gameName = [[GameStatus sharedGameStatus] gameName];
        if (gameNumber==1||gameNumber==5||gameNumber==8||gameNumber==11) {
            gameName = [gameName stringByAppendingString:@"Only"];
        }
        levelBatch = loadBatchNode(self, gameName);        
        nameOfItem= [CCLabelBMFont labelWithString:@"" fntFile:@"KidsFont78.fnt"];
        nameOfItem.position = ccp(size.width/2,size.height-50);
        [self addChild:nameOfItem z:3];
    
        NSMutableArray *layersArray=[[NSMutableArray alloc] init];
        
         gameStr = [[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameName"]objectAtIndex:gameNumber];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ItemNames" ofType:@"plist"];
        NSMutableDictionary *itemNameDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        itemNameArray =[[NSMutableArray alloc] initWithArray: [itemNameDict objectForKey:gameStr] copyItems:YES ];

        [itemNameDict release];
        for (NSInteger i=0; i<totalItems; i++){
            
            CCLayer *l1 = [[CCLayer alloc] init];
        
            NSString *itemStr = [NSString stringWithFormat:@"%@%02d.png",gameStr,i];
            CCSprite *item = [CCSprite spriteWithSpriteFrameName:itemStr];
            item.position = ccp(size.width/2,size.height/2+100); 
            
            [l1 addChild:item];
            
            CCMenuItemImage *menuItemPlaySound =[CCMenuItemImage itemFromNormalImage:@"repeatButton.png" selectedImage: @"repeatButtonS.png" target:self selector:@selector(playWordSound)];
            menuItemPlaySound.tag = i;
            CCMenu *playerMenu = [CCMenu menuWithItems:menuItemPlaySound, nil];
            playerMenu.position = ccp(size.width/2,size.height/2-150);
            [l1 addChild:playerMenu];            
            [layersArray addObject:l1];
            [l1 release];
        }
            scrollLayer = [[CCScrollLayer alloc] initWithLayers:layersArray widthOffset:200];
            scrollLayer.showPagesIndicator = NO;
            [self addChild:scrollLayer];
            [self schedule: @selector(tick:) interval:0.5];
            [layersArray release];
            displayAd(GAD_SIZE_728x90);
            //scrollLayer.isTouchEnabled=NO;
                
    }
    return self;
}

-(void)onExit{
    clearTextures(levelBatch);
    clearTextures(spritesNode);
    removeAd();
    [super onExit];
    
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    //NSLog(@"calling dealloc");    
    [itemNameArray release];
    [scrollLayer release];
    [super dealloc];
}

@end
