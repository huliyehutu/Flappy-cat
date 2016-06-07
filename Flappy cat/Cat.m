//
//  Cat.m
//  Flappy cat
//
//  Created by YIMING CHEN on 25/05/16.
//  Copyright © 2016 YIMING CHEN. All rights reserved.
//

#import "Cat.h"


@implementation Cat
const uint32_t catCategory = 1 << 0;
const uint32_t iceConeCategory = 1 << 1;
const uint32_t enemyCategory = 1 << 2;
const uint32_t ballCategory = 1 << 3;
@synthesize sprite;

-(id)init:(int)x with_y:(int)y{
    catTexture1 = [SKTexture textureWithImageNamed:@"cat_with_wing1"];
    catTexture1.filteringMode = SKTextureFilteringNearest;
    
    catTexture2 = [SKTexture textureWithImageNamed:@"cat_with_wing2"];
    catTexture2.filteringMode = SKTextureFilteringNearest;
    
    catTexture3 = [SKTexture textureWithImageNamed:@"cat_with_wing3"];
    catTexture3.filteringMode = SKTextureFilteringNearest;
    
    sprite = [SKSpriteNode spriteNodeWithTexture:catTexture1];
    sprite.position = initPosition = CGPointMake(x,y);
    
    SKAction* flap = [SKAction repeatActionForever:[SKAction animateWithTextures:@[catTexture1, catTexture2,catTexture3] timePerFrame:0.2]];
    [sprite runAction:flap];
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width / 3];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.categoryBitMask = catCategory;
    sprite.physicsBody.affectedByGravity = NO;
    sprite.physicsBody.allowsRotation = NO;
    sprite.physicsBody.collisionBitMask = enemyCategory;
    sprite.physicsBody.contactTestBitMask = enemyCategory;
    sprite.physicsBody.velocity = CGVectorMake( 0, 0 );
    
    //Reload a ice cone every 5 seconds
    SKAction* reload = [SKAction performSelector:@selector(reloadIce) onTarget:self];
    SKAction* delay = [SKAction waitForDuration:5.0];
    SKAction* reloadThenDelay = [SKAction sequence:@[reload,delay]];
    SKAction* reloadThenDelayForever = [SKAction repeatActionForever:reloadThenDelay];
    [sprite runAction:reloadThenDelayForever];
    for(int i =0;i<5; i++){
        SKSpriteNode *iceCone = createIceCone(i);
        [self.sprite addChild:iceCone];
        
    }
    return self;
}
SKSpriteNode* (^createIceCone)(int) = ^(int index){
    
    SKTexture *iceConeTexture = [SKTexture textureWithImageNamed:@"ice_cone"];
    iceConeTexture.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:iceConeTexture];
    sprite.position = CGPointMake(20*index -20,  60 - 30 * abs(2-index));
    sprite.zPosition = 2-index;
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.height / 10];
    sprite.physicsBody.categoryBitMask = iceConeCategory;
    sprite.physicsBody.contactTestBitMask = enemyCategory;
    sprite.physicsBody.collisionBitMask = enemyCategory;
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.affectedByGravity = NO;
    
    return sprite;
};

-(void) move:(int) dy with_y:(int)y{
    if(y + dy > 160 && y + dy < sprite.parent.frame.size.height-160){
        sprite.position = CGPointMake(sprite.position.x, y + dy);
        for(int i = 0 ; i < sprite.children.count; i ++){
            if(sprite.children[i].position.x<sprite.size.width){
                sprite.children[i].position =CGPointMake(sprite.children[i].position.x, 60 - 30 * abs(2- i));
            }
        }
    }
}
-(CGPoint)getPosition{
    return  sprite.position;
}
-(void)reset{
    sprite.position = initPosition;
    sprite.physicsBody.affectedByGravity = NO;
    sprite.physicsBody.allowsRotation = NO;
    sprite.physicsBody.velocity = CGVectorMake( 0, 0 );
    [self.sprite removeAllChildren];
    for(int i =0;i<5; i++){
        SKSpriteNode *iceCone = createIceCone(i);
        [self.sprite addChild:iceCone];
    }
    
    
}

//Reload a ice cone
-(void)reloadIce{
    if(self.sprite.children.count<5){
        SKSpriteNode *iceCone = createIceCone((int)self.sprite.children.count);
        
        [self.sprite addChild:iceCone];
    }
}

//Fire a ice cone, remove the node from Cat and add it to GameScene
-(void)fire{
    SKNode *node;
    if(self.sprite.children.count>0){
        node= self.sprite.children[self.sprite.children.count-1];
        [node moveToParent:sprite.parent];
        SKAction* moveIceCone = [SKAction moveByX:900 y:0 duration:0.5];
        SKAction* removeIceCone = [SKAction removeFromParent];
        SKAction* _moveIceConeAndRemove = [SKAction sequence:@[moveIceCone, removeIceCone]];
        [node runAction:_moveIceConeAndRemove];
        
    }
}


@end

