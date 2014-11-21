
local SKScene = objc.SKScene
local SKAction = objc.SKAction
local SKTexture = objc.SKTexture

local Spearman = require "Spearman"

local CgGeometry = require "CoreGraphics.CGGeometry"
local CgPath = require "CoreGraphics.CGPath"

local M_PI = math.pi

local GameScene = class.createClass ("GameScene", SKScene)

function GameScene:initWithSize(size)
    
    self = self[SKScene]:initWithSize (size)
    if self then
        self:configureScene ()
        
        local labelNode = objc.SKLabelNode:labelNodeWithFontNamed("ChalkDuster")
        labelNode.text = "Hello World"
        labelNode.fontSize = 60;
        labelNode.position = { x = CgGeometry.CGRectGetMidX(self.frame),
                               y = CgGeometry.CGRectGetMidY(self.frame) }
        
        self:addChild(labelNode)
    end
    
    return self
end

function GameScene:configureScene ()
    self.backgroundColor = objc.UIColor:colorWithRed_green_blue_alpha(0.15, 0.15, 0.3, 1.0)
    
    getResource ('Spaceship', 'png', self, function (self, resourceImage)
                                               self.spaceshipTexture = SKTexture:textureWithImage(resourceImage) 
                                               
                                               self:enumerateChildNodesWithName_usingBlock("spaceship",
                                                                                           function (node) 
                                                                                               node.texture = self.spaceshipTexture 
                                                                                           end)
                                           end)
end

function GameScene:touchesBegan_withEvent(touches, event)
    -- Called when a touch begins
    
    for touch in touches do
        local location = touch:locationInNode(self)
        
        local sprite = Spearman:createSpearmanAtLocation(location)
        
        self:addChild(sprite)
    end
    
    if touches.count >= 3 then
        -- Create a spaceship
        self:addSpaceshipAtLocation(touches.anyObject:locationInNode(self))
    end
end

function GameScene:addSpaceshipAtLocation (location)

    local spaceship = objc.SKSpriteNode:spriteNodeWithTexture(self.spaceshipTexture)
    
    spaceship.name = "spaceship"
    spaceship.scale = 0.2 * math.random(1,4)
    spaceship.position = location
    spaceship.zPosition = spaceship.xScale * 100
    
    local radiusX, radiusY = location.x / 2, location.y / 2
    local path = CgPath.CreateWithEllipseInRect { x = location.x- 2 * radiusX,  
                                                  y = location.y - radiusY, 
                                                  width = 2 * radiusX, 
                                                  height = 2 * radiusY }
    if path then
        local animation = SKAction:followPath_asOffset_orientToPath_duration (path, false, true, 0.5 * math.random(4,10))
        spaceship:runAction(SKAction:repeatActionForever(animation))
        
        CgPath.Release (path)
    end
    
    local waitAction = SKAction:waitForDuration(20)
    local shrinkAction = SKAction:scaleTo_duration(0, 1.6)
    spaceship:runAction(SKAction:sequence { waitAction, shrinkAction, SKAction:removeFromParent() })
    
    self:addChild(spaceship)
end

return GameScene