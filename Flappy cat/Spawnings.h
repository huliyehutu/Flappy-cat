//
//  Header.h
//  Flappy cat
//
//  Created by YIMING CHEN on 31/05/16.
//  Copyright © 2016 YIMING CHEN. All rights reserved.
//


#import "GameScene.h"

@interface Spawnings : SKNode
{
    NSMutableArray<SKTexture*> *textures;
}
//@property(nonatomic, readwrite) SKSpriteNode *sprite;
-(void)spawn;
@end