//
//  GameScene.m
//  Flappy cat
//
//  Created by YIMING CHEN on 22/05/16.
//  Copyright (c) 2016 YIMING CHEN. All rights reserved.
//

#import "GameScene.h"
#import "Cat.h"

@interface GameScene(){
    Cat *_cat;//The cat node contains the cat and ice cones
    int startY;//Record the y position when a touch begain for a relative moving action
    SKColor* _skyColor;
    CGPoint catLocation;
    SKNode* _moving; //Node contains all moving object
    SKNode* _spawnings;//Node contains all auto spawned object
    SKLabelNode* _scoreLabelNode;
    NSInteger _score;
    NSInteger _gameState;
    SKSpriteNode *startPage;
}
@end

@implementation GameScene

const uint32_t _catCategory = 1 << 0;
const uint32_t _iceConeCategory = 1 << 1;
const uint32_t _enemyCategory = 1 << 2;
const uint32_t _ballCategory = 1 << 3;
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    _skyColor = [SKColor colorWithRed:100.0/255.0 green:196.0/255.0 blue:239.0/255.0 alpha:1.0];
    _gameState = 0;
    _score = 0;
    _scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    _scoreLabelNode.position =  CGPointMake(self.frame.size.width*8.5/10,self.frame.size.height *8/ 10 );
    _scoreLabelNode.zPosition = 100;
    _scoreLabelNode.text = [NSString stringWithFormat:@"%d", _score];
    [self addChild:_scoreLabelNode];
    _moving = [SKNode node];
    [self addChild:_moving];
    _spawnings = [SKNode node];
    [_moving addChild:_spawnings];
    _moving.speed = 0;
    self.physicsWorld.gravity = CGVectorMake( 0.0, -7.5 );
    self.physicsWorld.contactDelegate = self;
    [self setBackgroundColor:_skyColor];
    _cat = [[Cat alloc]init : self.frame.size.width / 8 with_y:CGRectGetMidY(self.frame)];
    
    [self addChild:_cat.sprite];
    //[self addChild:_cat.iceCones];
    
    catLocation = [_cat getPosition];
    
    SKTexture* startPageTexture = [SKTexture textureWithImageNamed:@"startPage1"];
    startPageTexture.filteringMode = SKTextureFilteringNearest;
    startPage = [SKSpriteNode spriteNodeWithTexture:startPageTexture];
    startPage.position =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    startPage.size = self.frame.size;
    startPage.zPosition = 200;
    [self addChild:startPage];
    
    
    
    SKTexture* skylineTexture1 = [SKTexture textureWithImageNamed:@"sky_background1"];
    skylineTexture1.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite = [SKAction moveByX:-skylineTexture1.size.width*2 y:0 duration:0.01 * skylineTexture1.size.width];
    SKAction* resetGroundSprite = [SKAction moveByX:skylineTexture1.size.width*2 y:0 duration:0];
    SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for( int i = 0; i < 4; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture1];
        sprite.zPosition = -20;
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height/2+40);
        [sprite runAction:moveGroundSpritesForever];
        [_moving addChild:sprite];
    }
    
    SKTexture* skylineTexture2 = [SKTexture textureWithImageNamed:@"sky_background2"];
    skylineTexture1.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveGroundSprite2 = [SKAction moveByX:-skylineTexture2.size.width y:0 duration:0.01 * skylineTexture2.size.width];
    SKAction* resetGroundSprite2 = [SKAction moveByX:skylineTexture2.size.width y:0 duration:0];
    SKAction* moveGroundSpritesForever2 = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite2, resetGroundSprite2]]];
    
    for( int i = 0; i < 4; ++i ) {
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture2];
        sprite.zPosition = -20;
        sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height + 40);
        [sprite runAction:moveGroundSpritesForever2];
        [_moving addChild:sprite];
    }

    
    SKAction* spawnEnemy = [SKAction performSelector:@selector(spawnEnemies) onTarget:self];
    SKAction* spawnBall = [SKAction performSelector:@selector(spawnWoolBalls) onTarget:self];
    SKAction* delay1 = [SKAction waitForDuration:2.0 withRange:4.0];
    SKAction* delay2 = [SKAction waitForDuration:0.8 withRange:1.0];
    SKAction* spawnThenDelay = [SKAction sequence:@[spawnBall,delay2,spawnBall,delay2,spawnEnemy,delay2,spawnBall,delay1]];
    SKAction* spawnThenDelayForever = [SKAction repeatActionForever:spawnThenDelay];
    [_moving runAction:spawnThenDelayForever];
    
    
}
-(void)spawnEnemies {
    
    SKTexture* enemy1Texture = [SKTexture textureWithImageNamed:@"octopus"];
    enemy1Texture.filteringMode = SKTextureFilteringNearest;
    SKTexture* enemy2Texture = [SKTexture textureWithImageNamed:@"cucumber"];
    enemy2Texture.filteringMode = SKTextureFilteringNearest;
    
    
    
    CGFloat distanceToMove = self.frame.size.width + 2 * enemy1Texture.size.width;
    SKAction* moveEnemy = [SKAction moveByX:-distanceToMove y:0 duration:0.01 * distanceToMove];
    SKAction* removeEnemy = [SKAction removeFromParent];
    SKAction* _moveEnemyAndRemove = [SKAction sequence:@[moveEnemy, removeEnemy]];
    
    CGFloat y = arc4random() % (NSInteger)( 3 * self.frame.size.height / 5)+  self.frame.size.height / 5;
    //Use a random enemy texture
    SKTexture* enemyTexture = arc4random_uniform(2) > 0 ? enemy1Texture :enemy2Texture;
    SKSpriteNode* enemy = [SKSpriteNode spriteNodeWithTexture:enemyTexture];
    enemy.position = CGPointMake( self.frame.size.width, y );
    enemy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemy.size.height/2];
    enemy.physicsBody.dynamic = NO;
    enemy.physicsBody.categoryBitMask = _enemyCategory;
    enemy.physicsBody.contactTestBitMask = _catCategory|_iceConeCategory ;
    SKAction* flapEnemyUp = [SKAction moveByX:0 y: enemy.size.height/6 duration:0.01*enemy.size.height/4];
    SKAction* flapEnemyDown = [SKAction moveByX:0 y: -enemy.size.height/6 duration:0.01*enemy.size.height/4];
    SKAction* flapEnemy =[SKAction sequence:@[flapEnemyUp,flapEnemyDown]];
    SKAction* flapEnemyForever = [SKAction repeatActionForever:flapEnemy];
    [enemy runAction:_moveEnemyAndRemove];
    [enemy runAction:flapEnemyForever];
    [_spawnings addChild:enemy];
    
}
-(void)spawnWoolBalls {
    
    SKTexture* ball1Texture = [SKTexture textureWithImageNamed:@"yarn_ball_blue"];
    ball1Texture.filteringMode = SKTextureFilteringNearest;
    SKTexture* ball2Texture = [SKTexture textureWithImageNamed:@"yarn_ball_green"];
    ball2Texture.filteringMode = SKTextureFilteringNearest;
    SKTexture* ball3Texture = [SKTexture textureWithImageNamed:@"yarn_ball_pink"];
    ball3Texture.filteringMode = SKTextureFilteringNearest;
    
    
    
    CGFloat distanceToMove = self.frame.size.width + 2 * ball1Texture.size.width;
    SKAction* moveBall = [SKAction moveByX:-distanceToMove y:0 duration:0.01 * distanceToMove];
    SKAction* removeBall = [SKAction removeFromParent];
    SKAction* _moveBallAndRemove = [SKAction sequence:@[moveBall, removeBall]];
    
    CGFloat y = arc4random() % (NSInteger)( 3 * self.frame.size.height / 5)+  self.frame.size.height / 5;
    
    SKTexture* ballTexture;
    //Use a random colour for a yarn ball
    switch (arc4random_uniform(3)) {
        case 0:
            ballTexture = ball1Texture;
            break;
        case 1:
            ballTexture = ball2Texture;
            break;
        case 2:
            ballTexture = ball3Texture;
            break;
            
        default:
            break;
    }
    SKSpriteNode* ball = [SKSpriteNode spriteNodeWithTexture:ballTexture];
    ball.position = CGPointMake( self.frame.size.width, y );
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height/2];
    ball.physicsBody.dynamic = NO;
    ball.physicsBody.categoryBitMask = _ballCategory;
    ball.physicsBody.contactTestBitMask = _catCategory ;
    SKAction* popUp = [SKAction resizeToWidth:ball.size.width*1.1 height:ball.size.width*1.1 duration:(0.5)];;
    SKAction* popDown = [SKAction resizeToWidth:ball.size.width*0.9 height:ball.size.width*0.9 duration:(0.5)];
    SKAction* flapBall =[SKAction sequence:@[popUp,popDown]];
    SKAction* flapBallForever = [SKAction repeatActionForever:flapBall];
    [ball runAction:_moveBallAndRemove];
    [ball runAction:flapBallForever];
    [_spawnings addChild:ball];
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    // Flash background if contact of cat and enemy is detected
    if( _moving.speed > 0 ) {
        if( (( contact.bodyA.categoryBitMask & _catCategory ) == _catCategory &&( contact.bodyB.categoryBitMask & _enemyCategory ) == _enemyCategory )||(( contact.bodyA.categoryBitMask & _enemyCategory ) == _enemyCategory &&( contact.bodyB.categoryBitMask & _catCategory ) == _catCategory)){
            _moving.speed = 0;
            [self removeActionForKey:@"flash"];
            [self runAction:[SKAction sequence:@[[SKAction repeatAction:[SKAction sequence:@[[SKAction runBlock:^{
                self.backgroundColor = [SKColor redColor];
            }], [SKAction waitForDuration:0.1], [SKAction runBlock:^{
                self.backgroundColor = _skyColor;
            }], [SKAction waitForDuration:0.2]]] count:3], [SKAction runBlock:^{
                _gameState = 3;
                _cat.sprite.physicsBody.affectedByGravity = YES;
                _cat.sprite.physicsBody.allowsRotation = NO;
                for(SKSpriteNode *node in _cat.sprite.children){
                    node.physicsBody.affectedByGravity = YES;
                }
            }]]] withKey:@"flash"];

        }
        // Remove enemy and ice if contact of ice and enemy is detected
         else if((contact.bodyA.categoryBitMask & _iceConeCategory ) == _iceConeCategory ||( contact.bodyB.categoryBitMask & _iceConeCategory ) == _iceConeCategory ){
             SKTexture* iceBlockTexture = [SKTexture textureWithImageNamed:@"ice_block"];
             SKSpriteNode* iceBlock = [SKSpriteNode spriteNodeWithTexture:iceBlockTexture];
             iceBlock.physicsBody.dynamic = YES;
             SKAction* moveEnemy = [SKAction moveByX:0 y:-self.frame.size.height duration:0.002 * self.frame.size.height];
             SKAction* removeEnemy = [SKAction removeFromParent];
             SKAction* _moveEnemyAndRemove = [SKAction sequence:@[moveEnemy, removeEnemy]];
             [iceBlock runAction:_moveEnemyAndRemove];
             if(contact.bodyA.categoryBitMask == _enemyCategory){
                 iceBlock.position = contact.bodyA.node.position ;
                 [self addChild:iceBlock];
                 [contact.bodyA.node removeFromParent];
                 [contact.bodyB.node removeFromParent];
             }
             else{
                 iceBlock.position = contact.bodyB.node.position ;
                 [self addChild:iceBlock];
                 [contact.bodyB.node removeFromParent];
                 [contact.bodyA.node removeFromParent];
             }
         }
        //Increase score if contact of cat and a woolball is detected
         else if( (( contact.bodyA.categoryBitMask & _catCategory ) == _catCategory &&( contact.bodyB.categoryBitMask & _ballCategory ) == _ballCategory )||(( contact.bodyA.categoryBitMask & _ballCategory ) == _ballCategory &&( contact.bodyB.categoryBitMask & _catCategory ) == _catCategory)){
             _score++;
             _scoreLabelNode.text = [NSString stringWithFormat:@"%d", _score];
             
             if(contact.bodyA.categoryBitMask == _ballCategory){
                 [contact.bodyA.node removeFromParent];
             }
             else{
                 [contact.bodyB.node removeFromParent];
             }
         }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(_gameState == 2){
            if(location.x < self.frame.size.width/2){
                //Move cat only with y position
                [_cat move: location.y-startY with_y: catLocation.y];
            }
        }
    }
}
-(void)resetScene {
    // Move cat to original position and reset velocity
    [_cat reset];
    // Remove all existing enemis
    [_spawnings removeAllChildren];
    // Reset _canRestart
    _gameState = 2;
    // Restart animation
    _moving.speed = 1;
    // Reset _score
    _score = 0;
    _scoreLabelNode.text = [NSString stringWithFormat:@"%d", _score];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if(_gameState==0){
            SKTexture* startPageTexture = [SKTexture textureWithImageNamed:@"startPage2"];
            startPageTexture.filteringMode = SKTextureFilteringNearest;
            startPage.texture =startPageTexture;
            _gameState = 1;
        }
        else if(_gameState==1){
            [startPage removeFromParent];
            _gameState = 2;
            _moving.speed = 1;
        }
        else if(_gameState==2){
            
            //Move cat if touch the left side of screen
            if(location.x < self.frame.size.width/2){
                startY = location.y;
                catLocation = [_cat getPosition];
            }
            //Fire if touch right side of screen
            else{
                [_cat fire];
            }
        }
        //Reset if game was over
        else if(_gameState == 3){
            [self resetScene];
        }
    }
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
