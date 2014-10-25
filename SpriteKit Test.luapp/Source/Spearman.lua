local SKSpriteNode = objc.SKSpriteNode
local SKNode = objc.SKNode
local SKAction = objc.SKAction

local Spearman = class.createClass ("Spearman", SKSpriteNode)

local spearmanTextureAtlas = objc.SKTextureAtlas:atlasNamed("Spearman")

local function getStriteTexturesWithPrefix (spriteTexturePrefix)
    -- Load Texture atlas for Spearman
    local spearmanTextureNames = spearmanTextureAtlas.textureNames
    local spriteTextures = {}
    local textureFound = true
    local textureIndex = 1

    while textureFound do
        local spriteTextureName = spriteTexturePrefix .. textureIndex .. ".png"
        textureFound = spearmanTextureNames:containsObject(spriteTextureName)
        if textureFound then 
            table.insert(spriteTextures, spearmanTextureAtlas:textureNamed(spriteTextureName))
            textureIndex = textureIndex + 1
        end
    end
    
    return objc.toArray(spriteTextures)
end

Spearman.walkPeriod = 0.8-- duration of the spearman animation
local walkLeftTextures = getStriteTexturesWithPrefix ("bSpearman_Walk_Left")
Spearman.walkLeftSpriteAnimation = SKAction:repeatActionForever(SKAction:animateWithTextures_timePerFrame(walkLeftTextures, Spearman.walkPeriod / walkLeftTextures.count))

function Spearman.classMethod:createSpearmanAtLocation (location)
    local spearman = self:spriteNodeWithTexture(walkLeftTextures[1])
    spearman.position = location
    spearman.zPosition = -location.y
    
    spearman:runAction(Spearman.walkLeftSpriteAnimation)
    
    local toPoint = { x = - spearman.size.width, y = location.y }
    local moveAction = SKAction:moveTo_duration(toPoint, (location.x - toPoint.x) / spearman.size.height * self.walkPeriod * 0.8)
    local removeAction = SKAction:removeFromParent()
    spearman:runAction(SKAction:sequence { moveAction, removeAction })
    
    return spearman
end

return Spearman