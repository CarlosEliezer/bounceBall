Brick = Class{}

function Brick:init(x, y, width, height)
   self.x = x
   self.y = y
   self.width = width
   self.height = height

   -- number of times that need to be hit to be break
   self.hitBreak = math.ceil(math.random(1, 5))
end



function Brick:render()
   love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end