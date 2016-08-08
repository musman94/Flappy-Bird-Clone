//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Muhammad Usman on 07/08/2016.
//  Copyright (c) 2016 Muhammad Usman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    
    override func didMoveToView(view: SKView)
    {
        
        ///////////BACKGROUND/////////////////
        //defining the texture
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        bg = SKSpriteNode(texture: backgroundTexture)
        
        //defining the postion and size
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
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
            self.addChild(bg)
        }
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")

        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        
        
        
        ///////////BIRD///////////////////

        //Adding the textures
        bird = SKSpriteNode(texture: birdTexture)
        
        //initiating physics
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        //applying gravity
        bird.physicsBody!.dynamic = true
        
        //////ground/////
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
        
        //two physics bodies wont cross each other
        
        
        
        
        //defining the position
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        //animating
        let birdAnimate = SKAction.animateWithTextures([birdTexture,birdTexture2], timePerFrame: 0.1)
        let repeatAnimate = SKAction.repeatActionForever(birdAnimate)
        bird.runAction(repeatAnimate)
        
        //adding to the view
        self.addChild(bird)

        
        
        
        
             
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
        //pipe1.size.height = self.frame.height / 2 - birdTexture.size().height
        pipe1.runAction(moveAndRemovePipes)
        addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2")
        pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height / 2 - gapHeight / 2 + pipeLimit)
        // pipe2.size.height = self.frame.height / 2 - birdTexture.size().height
        pipe2.runAction(moveAndRemovePipes)
        addChild(pipe2)
        
        
    }
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
      
        //Applying the impuluse
        bird.physicsBody!.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        
        
        
        
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
}
