////
////  Spawnings.m
////  Flappy cat
////
////  Created by YIMING CHEN on 31/05/16.
////  Copyright © 2016 YIMING CHEN. All rights reserved.
////
//
//#import "Spawnings.h"
//
//@implementation Spawnings
//
//-(id)init:(NSString *)textureName,...{
//    
//
//    textures = [NSMutableArray alloc];
//    va_list args;
//    va_start(args, textureName);
//    id arg = nil;
//    while ((arg = va_arg(args,id))) {
//        SKTexture* texture = [SKTexture textureWithImageNamed:arg];
//        texture.filteringMode = SKTextureFilteringNearest;
//        [textures addObject:texture];
//    }
//    va_end(args);
//
//    return self;
//}
//-(void)spawn{
//    
//
//    
//    
//    
//    CGFloat distanceToMove = self.frame.size.width + 2 * enemy1Texture.size.width;
//    SKAction* moveEnemy = [SKAction moveByX:-distanceToMove y:0 duration:0.01 * distanceToMove];
//    SKAction* removeEnemy = [SKAction removeFromParent];
//    SKAction* _moveEnemyAndRemove = [SKAction sequence:@[moveEnemy, removeEnemy]];
//    
//    CGFloat y = arc4random() % (NSInteger)( 3 * self.frame.size.height / 5)+  self.frame.size.height / 5;
//    
//    SKTexture* enemyTexture = arc4random_uniform(2) > 0 ? enemy1Texture :enemy2Texture;
//    SKSpriteNode* enemy = [SKSpriteNode spriteNodeWithTexture:enemyTexture];
//    //[enemy setScale:2];
//    enemy.position = CGPointMake( self.frame.size.width, y );
//    enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemy.size.height/2];
//    enemy.physicsBody.dynamic = NO;
//    enemy.physicsBody.categoryBitMask = _enemyCategory;
//    enemy.physicsBody.contactTestBitMask = _catCategory|_iceConeCategory ;
//    SKAction* flapEnemyUp = [SKAction moveByX:0 y: enemy.size.height/6 duration:0.01*enemy.size.height/4];
//    SKAction* flapEnemyDown = [SKAction moveByX:0 y: -enemy.size.height/6 duration:0.01*enemy.size.height/4];
//    SKAction* flapEnemy =[SKAction sequence:@[flapEnemyUp,flapEnemyDown]];
//    SKAction* flapEnemyForever = [SKAction repeatActionForever:flapEnemy];
//    [enemy runAction:_moveEnemyAndRemove];
//    [enemy runAction:flapEnemyForever];
//    [_enemies addChild:enemy];
//    
//}
//@end