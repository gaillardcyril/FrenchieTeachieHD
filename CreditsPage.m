//
//  HomePage.m
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "AppDelegate.h"
#import "CreditsPage.h"
#import "SharedFunctions.h"
#import "GameSelection.h"
#import "CCLabelBMFontMultiline.h"

#define MENU_ITEM_SIZE 60
@implementation CreditsPage
//@synthesize  gameStatus;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsPage *layer = [CreditsPage node];
	
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

        CCLabelBMFontMultiline *credits= [CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"credits1", nil) fntFile:@"KidsFont78.fnt" width:winSize.width*0.9 alignment:CenterAlignment];
        
        credits.position = ccp(winSize.width/2,500);
        [self addChild:credits z:3];
        credits =[CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"credits2", nil) fntFile:@"KidsFont78.fnt" width:winSize.width*0.9 alignment:CenterAlignment];
                credits.position = ccp(winSize.width/2,270);
        [self addChild:credits z:3];
	}
	return self;
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}

-(void)onExit{
    clearTextures(spritesNode);
    [super onExit];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [super dealloc];


	
}

@end
