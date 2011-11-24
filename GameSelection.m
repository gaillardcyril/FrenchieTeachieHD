//
//  GameSelection.m
//  ColorMeNow
//
//  Created by Cyril Gaillard on 22/05/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "GameSelection.h"
#import "HomePage.h"
#import "ThreeChoice.h"
#import "SharedFunctions.h"
#import "Hidden.h"
#import "GameStatus.h"


@implementation GameSelection

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];	
	// 'layer' is an autorelease object.
	GameSelection *layer = [GameSelection node];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

-(void) displayMenuInGrid:(CCMenu *)menu{
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    NSInteger xPos=150;
    NSInteger yPos=winSize.height-40;
    NSInteger itemPerRow = 4;
    NSInteger xPadding = 250;
    NSInteger yPadding = 250;
    NSInteger loop=1;   
    for (CCMenuItem* menuItem in menu.children){
        menuItem.position = ccp(xPos,yPos);
        xPos+=xPadding;
        if(loop%itemPerRow == 0){
            xPos=150;
            yPos-=yPadding;
        }  
        loop++;
    }
}

-(void)goBackHome:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[HomePage scene]];    
}

-(void)displayGame:(CCMenuItem *) menuItem {
    NSInteger gPurchased = [[GameStatus sharedGameStatus] gamePurchased];
    NSInteger i=menuItem.tag;
    if (!gPurchased && (i==1||i==3||i==6||i==4||i==9||i==11)) {
        buyAllCharacters();
    }
    else{
    NSString *gameFileName = [[[GameStatus sharedGameStatus].names objectAtIndex:menuItem.tag] stringByReplacingOccurrencesOfString:@" " withString:@""] ;   
    [[GameStatus sharedGameStatus]setGameName:gameFileName];
    [[GameStatus sharedGameStatus]setGameNumber:[NSNumber numberWithInt:menuItem.tag]];
    NSString *gameType = [[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameType"] objectAtIndex:menuItem.tag];
    if([gameType isEqualToString:@"Choice"])
       [[CCDirector sharedDirector] replaceScene:[ThreeChoice scene]];
    else
       [[CCDirector sharedDirector] replaceScene:[Hidden scene]];
    }
     
}

// on "init" you need to initialize your instance
-(id) init
    {
       // always call "super" init
        // Apple recommends to re-assign "self" with the "super" return value
        if( (self=[super init] )) {
            
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            
            [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
            backgroundBatch = [CCSpriteBatchNode batchNodeWithFile:@"HomePage.pvr.ccz"];
            [self addChild:backgroundBatch];    
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HomePage.plist"];
            CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"homeBG.png"];
            [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

            [backgroundBatch addChild:background];
            background.position = ccp(winSize.width/2,winSize.height/2);
             
            displayBackHomeButton(self);
            
            gameSelection = [CCMenu menuWithItems: nil];
            gameSelection.position=ccp(winSize.width/2,winSize.height/2);
            
            NSInteger thumbWidth;
            NSInteger gPurchased = [[GameStatus sharedGameStatus] gamePurchased];
            
            NSMutableArray *gameCompletedList = [[NSMutableArray alloc] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"]];
            
            
            NSArray* gNames = [NSArray arrayWithObjects:NSLocalizedString(@"treats", nil),NSLocalizedString(@"kitchen", nil),NSLocalizedString(@"farmAnimals", nil),NSLocalizedString(@"numbers", nil),NSLocalizedString(@"fruits", nil),NSLocalizedString(@"vegetables", nil),NSLocalizedString(@"wildAnimals", nil),NSLocalizedString(@"alphabet", nil),NSLocalizedString(@"bedroom", nil),NSLocalizedString(@"colors", nil),NSLocalizedString(@"seacreatures", nil),NSLocalizedString(@"vehicles", nil),nil];
            
            for (NSInteger i=0; i<12; i++) {                
                NSString *gameName = [[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameIcon"] objectAtIndex:i];
                            
                CCSprite *gameThumb = [CCSprite spriteWithSpriteFrameName:gameName];
                gameThumb.scale=0.9;   
                thumbWidth = [gameThumb contentSize].width*gameThumb.scale;
                [gameThumb setContentSize:CGSizeMake(thumbWidth,300)];
        
                CCMenuItemSprite *gameThumbItem = [CCMenuItemSprite itemFromNormalSprite:gameThumb selectedSprite:nil target:self selector:@selector(displayGame:)];
                if (!gPurchased && (i==1||i==3||i==6||i==4||i==9||i==11)) {
                    CCSprite *buyButton = [CCSprite spriteWithFile:@"inAppButton.png"];
                    buyButton.position=ccp(100,50);
                    [gameThumbItem addChild:buyButton z:99];
                }
                  
              
                NSString *humanGameN = [gNames objectAtIndex:i];
                 if ([[gameCompletedList objectAtIndex:i] intValue]) {
                 // NSLog(@"going here");
                 humanGameN = [NSString stringWithFormat:@"Å %@",humanGameN];  
                 }   
                 
                 CCLabelBMFont *gameLabel= [CCLabelBMFont labelWithString:humanGameN fntFile:@"KidsFont38.fnt"];
                 gameLabel.position=ccp(thumbWidth/2,-30);  
                
                 [gameThumbItem addChild:gameLabel];
                             
              gameThumbItem.tag = i;
             [gameSelection addChild:gameThumbItem];
            }
            
            //[gameCompletedList release];
            [self displayMenuInGrid:gameSelection];
            gameSelection.position=ccp(0,0);
            [self addChild:gameSelection];        
        }
        return self;
}
-(void)onExit{
    clearTextures(backgroundBatch);
    [super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [names release];
    [super dealloc];
}

@end

