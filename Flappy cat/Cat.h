//
//  Cat.h
//  Flappy cat
//
//  Created by YIMING CHEN on 25/05/16.
//  Copyright © 2016 YIMING CHEN. All rights reserved.
//

#import "GameScene.h"

@interface Cat : NSObject
{
    SKTexture *catTexture1;
    SKTexture *catTexture2;
    SKTexture *catTexture3;
    CGPoint initPosition;
}
@property(nonatomic, readwrite) SKSpriteNode *sprite;
-(id)init:(int)x with_y:(int)y;
-(void) move:(int) dy with_y:(int)y;
-(CGPoint)getPosition;
-(void)fire;
-(void)reset;
-(void)reloadIce;
@end