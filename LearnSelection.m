//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//
#import "LearnSelection.h"
#import "HomePage.h"
#import "AppDelegate.h"
#import "LearnInterface.h"
#import "GameStatus.h"
#import "SharedFunctions.h"

#define MENU_ITEM_SIZE 60
@implementation LearnSelection
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LearnSelection *layer = [LearnSelection node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
}

-(void) displayMenuInGrid:(CCMenu *)menu{
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    NSInteger xPos=-70;
    NSInteger yPos=winSize.height-40;
    NSInteger itemPerRow = 2;
    NSInteger xPadding = 500;
    NSInteger yPadding = 100;
    NSInteger loop=1;   
    for (CCMenuItem* menuItem in menu.children){
        menuItem.position = ccp(xPos,yPos);
        xPos+=xPadding;
        if(loop%itemPerRow == 0){
            xPos=-70;
            yPos-=yPadding;
        }  
        loop++;
    }
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // ask director the the window size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
    
        spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"HomePage.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HomePage.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"homeBG.png"];
        [spritesNode addChild:background];
        background.position = ccp(winSize.width/2,winSize.height/2);
                        
        displayBackHomeButton(self);

         NSArray* names = [NSArray arrayWithObjects:NSLocalizedString(@"treats", nil),NSLocalizedString(@"kitchen", nil),NSLocalizedString(@"farmAnimals", nil),NSLocalizedString(@"numbers", nil),NSLocalizedString(@"fruits", nil),NSLocalizedString(@"vegetables", nil),NSLocalizedString(@"wildAnimals", nil),NSLocalizedString(@"alphabet", nil),NSLocalizedString(@"bedroom", nil),NSLocalizedString(@"colors", nil),NSLocalizedString(@"seacreatures", nil),NSLocalizedString(@"vehicles", nil),nil];
        
        CCMenu *learnSelectionM = [CCMenu menuWithItems: nil];
        learnSelectionM.position=ccp(winSize.width/2,winSize.height/2);
        BOOL gPurchased = [[GameStatus sharedGameStatus] gamePurchased];      
        for (NSInteger i=0; i<12; i++) {                
        
            if (gPurchased || (i!=1 && i!=3  && i!=6  && i!=4  && i!=9  && i!=11)) {
                
            CCLabelBMFont *gameLabel= [CCLabelBMFont labelWithString:[names objectAtIndex:i] fntFile:@"KidsFont78.fnt"];
            
            CCMenuItemLabel *learnItem = [CCMenuItemLabel itemWithLabel:gameLabel target:self selector:@selector(displayLearnGame:)];
            
            learnItem.tag = i;
            [learnSelectionM addChild:learnItem];
            }
        }
        
        [self displayMenuInGrid:learnSelectionM];
        learnSelectionM.position=ccp(winSize.width/2-150,-50);
        [self addChild:learnSelectionM];        
	}
	return self;
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}

-(void)displayLearnGame:(CCMenuItem *) menuItem {    
    NSString *gameFileName = [[[GameStatus sharedGameStatus].names objectAtIndex:menuItem.tag] stringByReplacingOccurrencesOfString:@" " withString:@""] ;   
    [[GameStatus sharedGameStatus]setGameName:gameFileName];
    [[GameStatus sharedGameStatus]setGameNumber:[NSNumber numberWithInt:menuItem.tag]];
    [[CCDirector sharedDirector] replaceScene:[LearnInterface scene]];    
}

-(void)onExit{
    clearTextures(spritesNode);
    [super onExit];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[super dealloc];
}

@end
