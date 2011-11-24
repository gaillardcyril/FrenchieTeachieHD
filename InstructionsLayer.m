//
//  InstructionsLayer.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "InstructionsLayer.h"
#import "CCLabelBMFontMultiline.h"


@implementation InstructionsLayer


-(void)discardLayer{
    [callingLayer discardInstrLayer];
}

-(id) initWithParent:(CCLayer *)parentLayer {
    
    if ((self = [super initWithColor:ccc4(255, 255, 255, 180)])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        callingLayer = parentLayer;
        
        CCLabelBMFontMultiline *helpInstructions= [CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"answer", nil) fntFile:@"KidsFont52.fnt" width:300 alignment:CenterAlignment];
        [self addChild:helpInstructions];
        helpInstructions.position=ccp(830,600);
        
        CCLabelBMFont *repeatInstructions= [CCLabelBMFont labelWithString:NSLocalizedString(@"Repeat", nil) fntFile:@"KidsFont52.fnt"];
        repeatInstructions.position=ccp(800,720);    
        [self addChild:repeatInstructions];
        
        CCLabelBMFontMultiline *fbShare= [CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"facebook", nil) fntFile:@"KidsFont52.fnt" width:300 alignment:LeftAlignment];
        fbShare.position=ccp(800,500);    
        [self addChild:fbShare];
        
        CCLabelBMFontMultiline *generalInstructions= [CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"Instructions", nil) fntFile:@"KidsFont52.fnt" width:500 alignment:CenterAlignment];
        generalInstructions.position=ccp(300,size.width/2);
        [self addChild:generalInstructions];
        
        CCLabelBMFont *startPLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"StartPlaying", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *startPItem = [CCMenuItemLabel itemWithLabel:startPLabel target:self selector:@selector(discardLayer)];
        
        CCMenu *mainMenu =[CCMenu menuWithItems:startPItem, nil];
        
        [self addChild:mainMenu];
        mainMenu.position=ccp(300,300);
           
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    //[[CCTextureCache sharedTextureCache] removeAllTextures];
    //[CCSpriteFrameCache  purgeSharedSpriteFrameCache];
}  
@end
