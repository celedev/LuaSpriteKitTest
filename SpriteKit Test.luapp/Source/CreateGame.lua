
local SKScene = require "SpriteKit.SKScene"

local skView = skViewController.view

skView.showsFPS = true
skView.showsNodeCount = true

local GameScene = require "GameScene"

local scene = GameScene:sceneWithSize(skView.bounds.size)
scene.scaleMode = SKScene.ScaleMode.AspectFill

skView:presentScene(scene)
