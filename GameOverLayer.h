//
//  GameOverLayer.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor {
    CCLayer *callingLayer;
}
-(id) initWithParent:(CCLayer *)parentLayer;
@end
