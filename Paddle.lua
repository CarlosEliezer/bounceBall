Paddle = Class{}

function Paddle:init(x, y, width, height)
   self.x = x
   self.y = y
   self.width = width
   self.height = height
   self.dx = 0
end

function Paddle:reset()
   self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
   self.y = VIRTUAL_HEIGHT - 30
end

function Paddle:update(dt)
   if self.dx < 0 then
      -- to not pass 0px in screen size
      self.x = math.max(0, self.x + self.dx * dt)
   else
      -- to not pass the screen size
      self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
   end
end

function Paddle:render()
   love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end