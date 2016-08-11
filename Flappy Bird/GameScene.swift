//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Muhammad Usman on 07/08/2016.
//  Copyright (c) 2016 Muhammad Usman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate
{
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    enum ColliderType: UInt32
    {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    var gameOver = false
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var movingObjects = SKSpriteNode()
    var labelContainer = SKSpriteNode()
    
    override func didMoveToView(view: SKView)
    {
     
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        makeBack()
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")

        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        ///////LABEL///////////
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.height - 70)
        scoreLabel.zPosition = 4
        //scoreLabel.position = CGPoint(x : CGRectGetMidX(self.frame), y: self.frame.height - 70)
        movingObjects.addChild(scoreLabel)
        
        
        
        ///////////BIRD///////////////////

        //Adding the textures
        bird = SKSpriteNode(texture: birdTexture)
        
        //initiating physics
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        //applying gravity
        bird.physicsBody!.dynamic = true
        //assigning the Bird category to the bird
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        //detects the collison
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        //used to prevent the sprite from passing thorugh the obejcts 
        //here the bird one is the same as the ground one below so these two things wont pass through eachother
        //Always remember: the collisionBitMask has to be the same for all the values we dont want to pass through eachother
        bird.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        //////GROUND/////
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        //assigning the Object category to the bird
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        //detects the collison
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        //used to prevent the sprite from passing thorugh the obejcts but not really needed here
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(ground)
        //two physics bodies wont cross each other
        
        
        //defining the position
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.zPosition = 2
        //animating
        let birdAnimate = SKAction.animateWithTextures([birdTexture,birdTexture2], timePerFrame: 0.1)
        let repeatAnimate = SKAction.repeatActionForever(birdAnimate)
        bird.runAction(repeatAnimate)
        //adding to the view
        self.addChild(bird)
        

        
}
    
    func makeBack()
    {
    
        
        ///////////BACKGROUND/////////////////
        //defining the texture
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        bg = SKSpriteNode(texture: backgroundTexture)
        
        //defining the postion and size
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bg.zPosition = 1
        bg.size.height = self.frame.height
        
        //animating the background
        let bgAnimate = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)
        let replace = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        let repeatBg = SKAction.repeatActionForever(SKAction.sequence([bgAnimate,replace]))
        
        for var i:CGFloat = 0; i < 3; i++
        {
            
            bg = SKSpriteNode(texture: backgroundTexture)
            bg.position = CGPoint(x: backgroundTexture.size().width/2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(repeatBg)
            
            //adding the node to the view
            movingObjects.addChild(bg)
        }
    }
    
    
    func makePipes()
    {
     
        
        //////////PIPES///////////////////
        
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        let pipeLimit = CGFloat(movementAmount) - self.frame.size.height / 4
        
        
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removePipe = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes,removePipe])
        
        //let pipeLimit = CGFloat(movementAmount) - self.frame.size.height / 4
        let pipe1Texture = SKTexture(imageNamed: "pipe1")
        pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1Texture.size().height / 2 + gapHeight / 2 + pipeLimit)
        pipe1.zPosition = 2
        //pipe1.size.height = self.frame.height / 2 - birdTexture.size().height
        pipe1.runAction(moveAndRemovePipes)
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1Texture.size())
        pipe1.physicsBody!.dynamic = false
        //assigning the Object category to the pipe
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        //detects the collison
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        //used to prevent the sprite from passing thorugh the obejcts
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        movingObjects.addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2")
        pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height / 2 - gapHeight / 2 + pipeLimit)
        pipe2.zPosition = 2
        // pipe2.size.height = self.frame.height / 2 - birdTexture.size().height
        pipe2.runAction(moveAndRemovePipes)
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size())
        pipe2.physicsBody!.dynamic = false
        //assigning the Object category to the pipe
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        //detects the collison
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        //used to prevent the sprite from passing thorugh the obejcts
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        movingObjects.addChild(pipe2)
        
        ///////GAP//////////
        
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeLimit )
        gap.zPosition = 2
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width,gapHeight))
        gap.physicsBody!.dynamic = false
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        movingObjects.addChild(gap)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact)
    {
        
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue
            {
                score += 1
                scoreLabel.text = String(score)
            
            }
            else
            {
    
                if gameOver == false
                {
                    gameOver = true
                    gameOverLabel.fontName = "Helvetica"
                    gameOverLabel.fontSize = 30
                    gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    gameOverLabel.zPosition = 4
                    gameOverLabel.text = "Game Over! Tap to play again."
                    labelContainer.addChild(gameOverLabel)
                    //Setting the speed of evertthing in the frame to be zero thus stopping the animation
                    self.speed = 0
                }
            }
    }
    
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
      
        if gameOver == false
        {
            //Applying the impuluse
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }
        else
        {
            score = 0
            scoreLabel.text = "0"
            bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            movingObjects.removeAllChildren()
            makeBack()
            self.speed = 1
            gameOver = false
            labelContainer.removeAllChildren()
            
        
        }
        
        
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
}
