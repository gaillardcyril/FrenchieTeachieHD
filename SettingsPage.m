//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "AppDelegate.h"
#import "SettingsPage.h"
#import "GameStatus.h"
#import "MoreGames.h"
#import "SharedFunctions.h"


#define MENU_ITEM_SIZE 60
@implementation SettingsPage
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsPage *layer = [SettingsPage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
		
	// return the scene
	return scene;
}

-(void)updateUserDefault:(id) sender {
    CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    //NSLog(@"uyhf %d",toggleItem.selectedIndex);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:toggleItem.selectedIndex forKey:@"voiceChoice"];
    
}
-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}
-(void)moreGames:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[MoreGames scene]];    
}

-(void)sendEmail:(CCMenuItem *) menuItem {
 [(AppDelegate*)[[UIApplication sharedApplication] delegate] sendEmail];   
}

-(void)buyGame{
    buyAllCharacters();
}

-(void)resetAllGames:(CCMenuItem *) menuItem {  
    NSMutableArray *tempGameStatus = [[NSMutableArray alloc] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"]];
    for (NSInteger i=0; i<12; i++) {
        [tempGameStatus replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }
    
    //CCLOG(@"the array is %@ and the index is %d",tempGameStatus,idxGameStatus);
    [[[GameStatus sharedGameStatus] gameStatusList] setObject:tempGameStatus forKey:@"GameCompleted"];
    [[GameStatus sharedGameStatus] updatePListFile];
    [tempGameStatus release];
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
        
        CCLabelBMFont *resetLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"reset", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *resetItem = [CCMenuItemLabel itemWithLabel:resetLabel target:self selector:@selector(resetAllGames:)];
        
        CCLabelBMFont *sendEmailLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"send", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *sendEmailItem = [CCMenuItemLabel itemWithLabel:sendEmailLabel target:self selector:@selector(sendEmail:)];
        
        CCLabelBMFont *buyLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"FullVersion", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *buyItem = [CCMenuItemLabel itemWithLabel:buyLabel target:self selector:@selector(buyGame)];
        
        CCLabelBMFont *moreLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"moreGames", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *moreItem = [CCMenuItemLabel itemWithLabel:moreLabel target:self selector:@selector(moreGames:)];
        
        CCLabelBMFont *voiceOnlyLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"voiceSel1", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *voiceOnlyItem = [CCMenuItemLabel itemWithLabel:voiceOnlyLabel target:nil selector:nil];
        
        CCLabelBMFont *textOnlyLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"voiceSel2", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *textOnlyItem = [CCMenuItemLabel itemWithLabel:textOnlyLabel target:nil selector:nil];
        
        CCLabelBMFont *voiceTextLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"voiceSel", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *voiceTextItem = [CCMenuItemLabel itemWithLabel:voiceTextLabel target:nil selector:nil];
        
        CCMenuItemToggle *voiceSelec= [CCMenuItemToggle itemWithTarget:self selector:@selector(updateUserDefault:) items:voiceTextItem,voiceOnlyItem,textOnlyItem, nil];
        
        NSInteger voiceChoice=[[NSUserDefaults standardUserDefaults] integerForKey:@"voiceChoice"];
        
        voiceSelec.selectedIndex=voiceChoice;
        
        CCMenu *mainMenu =[CCMenu menuWithItems:resetItem,voiceSelec,buyItem,moreItem,sendEmailItem, nil];
        [mainMenu alignItemsVertically];
        mainMenu.position=ccp(winSize.width/2, winSize.height/2);
        [self addChild:mainMenu];
        
        displayBackHomeButton(self);
        
	}
	return self;
}
-(void)onExit{
    clearTextures(spritesNode);
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	
    [super dealloc];

}

@end
