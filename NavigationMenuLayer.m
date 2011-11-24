//
//  NavigationMenuLayer.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "NavigationMenuLayer.h"
#import "AWScreenshot.h"


@implementation NavigationMenuLayer
@synthesize navMenu;

-(void) showPausePage{
    [callingLayer showPausePage];
}

-(void) showCorrectAnswer{
    [callingLayer showCorrectAnswer];
}

-(void)playNumberSound{
    [callingLayer playNumberSound];
}

-(void)shareGame{
    UIImage *screenshot=[AWScreenshot takeAsImage];
    SHKItem *item = [SHKItem image:screenshot title:@"Learn French with Frenchie Teachie"];
    [SHKFacebook shareItem:item];
    
}

-(id) initWithParent:(CCLayer *)parentLayer{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        callingLayer = parentLayer;
        
        CCSprite *star =[CCSprite spriteWithFile:@"star.png"];    
        CCMenuItemSprite *menuItemHelpGame =[CCMenuItemSprite itemFromNormalSprite:star selectedSprite:nil target:self selector:@selector(showCorrectAnswer)];	
        menuItemHelpGame.tag=99;
        
        CCLabelBMFont *helpNumLabel= [CCLabelBMFont labelWithString:@"3" fntFile:@"KidsFont38.fnt"];
        helpNumLabel.tag=100;
        [star contentSize];
        helpNumLabel.position = ccp([menuItemHelpGame contentSize].width/2,[menuItemHelpGame contentSize].height/2-5);
        
        menuItemHelpGame.position=ccp(size.width-60,size.height-160);
        [menuItemHelpGame addChild:helpNumLabel];
        
        CCMenuItemImage *menuItemPauseGame =[CCMenuItemImage itemFromNormalImage:@"pauseButton.png" selectedImage: nil target:self selector:@selector(showPausePage)];	
        menuItemPauseGame.position = ccp([menuItemPauseGame contentSize].width/2, size.height-[menuItemPauseGame contentSize].height/2);
        
        CCMenuItemImage *menuItemRepeat =[CCMenuItemImage itemFromNormalImage:@"repeatButton.png" selectedImage: @"repeatButtonS.png" target:self selector:@selector(playNumberSound)];
        menuItemRepeat.scale=0.7;
        menuItemRepeat.position = ccp(size.width-60,size.height-60);
        
        CCMenuItemImage *menuShareGame =[CCMenuItemImage itemFromNormalImage:@"facebook.png" selectedImage: @"facebookS.png" target:self selector:@selector(shareGame)];	
        menuShareGame.position=ccp(size.width-60,size.height-260);
        
        navMenu = [CCMenu menuWithItems:menuItemHelpGame,menuItemPauseGame,menuItemRepeat,menuShareGame, nil];
        navMenu.tag=99;
        navMenu.position=ccp(0,0);
        [self addChild:navMenu];		
                
    }
	return self;
}


-(void)dealloc{
    [super dealloc];
    //[[CCTextureCache sharedTextureCache] removeAllTextures];
    //[CCSpriteFrameCache  purgeSharedSpriteFrameCache];
}  
@end
