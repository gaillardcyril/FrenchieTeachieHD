//
//  NavigationMenuLayer.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SHK.h"
#import "SHKFacebook.h"

@interface NavigationMenuLayer : CCLayer {
    CCMenu *navMenu;
    CCLayer *callingLayer;
}
-(id) initWithParent:(CCLayer *)parentLayer;

@property(nonatomic,assign) CCMenu *navMenu;
@end
