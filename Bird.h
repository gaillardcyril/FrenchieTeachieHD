//
//  Bird.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 11/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bird : CCSprite {
   CCParticleSystemQuad *dancingNote; 
   id walkAction;
    
}
@property(nonatomic,retain) CCParticleSystemQuad *dancingNote;
-(void)initAnimationsWithName:(NSString *)animName;
-(void)walkForEver;
-(void)flyAcrossScreenWithDelay:(CGFloat)delay;

@end
