//
//  Bird.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 11/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "Bird.h"


@implementation Bird
@synthesize dancingNote;
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        //NSLog(@"I am being called init");
        dancingNote = [CCParticleSystemQuad particleWithFile:@"note.plist"];
        [self addChild:dancingNote z:3];
        //self.scaleX*=-1;
        dancingNote.tag=77;
        dancingNote.scaleX=1;
        dancingNote.position=ccp(30,30);
        [dancingNote resetSystem];
       	}
	return self;
}

-(void)initAnimationsWithName:(NSString *)animName {    
    CCAnimation *walkAnim = [CCAnimation animation];
    for(int i = 1; i <= 15; ++i) {
        [walkAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName :[NSString stringWithFormat:@"%@%04d.png",animName, i]]];
    }
    
    walkAction = [CCAnimate actionWithDuration:0.25f animation:walkAnim restoreOriginalFrame:NO];
    [walkAction retain];
    
}

-(void)walkForEver{
    id walkForever = [CCRepeatForever actionWithAction:walkAction];
    [self runAction:walkForever];
}
-(void)flyAcrossScreenWithDelay:(CGFloat)delay{    
    //self.scaleX*=-1;
    //dancingNote.scaleX=1;
    NSInteger endPosX;
    if (self.position.x==-100) {
        endPosX = 1200;
        [self runAction:[CCFlipX actionWithFlipX:NO]];
    }
    else{
        endPosX = -100;
        [self runAction:[CCFlipX actionWithFlipX:YES]];
    }
    
    NSInteger endPosY = arc4random()%1024;
    id flyAction = [CCMoveTo actionWithDuration:5 position:ccp(endPosX,endPosY)];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],flyAction,nil]];
}

- (void) dealloc
{
	
    [walkAction release];
    
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [CCTextureCache purgeSharedTextureCache];
    [CCSpriteFrameCache  purgeSharedSpriteFrameCache];
    [super dealloc];
}



@end
