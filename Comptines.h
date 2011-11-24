//
//  HomePage.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Bird.h"
#import "GADBannerView.h"

@interface Comptines: CCLayer {

    BOOL birdsShouldFly;
    BOOL birdsAreWalking;
    CGSize size;    
    Bird *bird1;
    Bird *bird2;
    Bird *bird3;
    Bird *bird4;
    CCSpriteBatchNode *spritesNode;

}
+(id) scene;
-(void) moveBird:(id)sender;
//@property (nonatomic,retain)
@property(nonatomic,assign)id walkAction;
@property(nonatomic,retain) Bird *bird1;
@property(nonatomic,retain) Bird *bird2;
@property(nonatomic,retain)Bird *bird3;
@property(nonatomic,retain) Bird *bird4;

@end
