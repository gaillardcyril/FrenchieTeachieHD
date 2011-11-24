//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "AppDelegate.h"
#import "MoreGames.h"
#import "SettingsPage.h"
#import "SharedFunctions.h"
#import "CCLabelBMFontMultiline.h"

#define MENU_ITEM_SIZE 60
@implementation MoreGames
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MoreGames *layer = [MoreGames node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	
	// return the scene
	return scene;
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

        
        CCSprite *colorMeNow = [CCSprite spriteWithSpriteFrameName:@"colorMeNowIcon.png"];
        CCMenuItemSprite  *colorItem = [CCMenuItemSprite itemFromNormalSprite:colorMeNow selectedSprite:nil target:self selector:@selector(goAppStore:)]; 
        CCMenu *getGame = [CCMenu menuWithItems:colorItem, nil];
        getGame.position=ccp(250,winSize.height/2);
        [self addChild:getGame];
        
        CCLabelBMFontMultiline *colorMeNowLabel = [CCLabelBMFontMultiline labelWithString:@"Color Me Now\nLearn Basic English Words,\nColor the Princesses or Monsters.\nBeat the Witch.\nTap on the image to download (for free)" fntFile:@"KidsFont38.fnt" width:450 alignment:LeftAlignment];
        
        colorMeNowLabel.position = ccp(650,winSize.height/2);
        [self addChild:colorMeNowLabel];
	}
	return self;
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[SettingsPage scene]];    
}

-(void)goAppStore:(CCMenuItem *) menuItem {
        
    NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=447188279&mt=8";
		
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
// on "dealloc" you need to release all your retained objects
-(void)onExit{
    clearTextures(spritesNode);
}
- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [super dealloc];

	
}

@end
