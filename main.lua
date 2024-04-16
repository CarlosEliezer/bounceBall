push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
   local file = io.open('highScore.txt', 'r')
   love.graphics.setDefaultFilter('nearest', 'nearest')

   smallFont = love.graphics.newFont('font.ttf', 8)
   scoreFont = love.graphics.newFont('font.ttf', 16)

   love.graphics.setFont(smallFont)
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = true
   })

   playerScore = 0
   lifePoint = 3
   highScore = file:read('*all')
   file:close()

   -- Only moves to right and left, start center
   playerX = VIRTUAL_WIDTH / 2 - 18
end

function love.update(dt)
   -- Player movement
   if love.keyboard.isDown('a') then
      playerX = playerX - PADDLE_SPEED * dt
   elseif love.keyboard.isDown('d') then
      playerX = playerX + PADDLE_SPEED * dt
   end
end

function love.keypressed(key)
   if key == 'escape' then
      love.event.quit()
   end
end


function love.draw()
   push:apply('start')

   love.graphics.clear(40/255, 45/255, 52/255, 255/255) -- (R, G, B, Transparency)
   love.graphics.setFont(smallFont)
   love.graphics.printf(
      'BOUNCE BALL!',
      0,
      VIRTUAL_HEIGHT / 2-8, -- (Halfway down the screen) - (Font size)
      VIRTUAL_WIDTH,
      'center'
   )

   love.graphics.setFont(scoreFont)
   love.graphics.print(tostring(lifePoint)..'LP', VIRTUAL_WIDTH / 4 - 50, 10)
   love.graphics.print(tostring(playerScore), VIRTUAL_WIDTH / 4 - 42, 30)
   
   love.graphics.print('HIGH SCORE', VIRTUAL_WIDTH / 2 - 44, 10)
   love.graphics.print(tostring(highScore), VIRTUAL_WIDTH / 2 - 5, 30)
   
   love.graphics.rectangle('fill', playerX, VIRTUAL_HEIGHT - 30, 36, 5)
   love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT - 35, 4, 4)

   love.graphics.rectangle('fill', 0, 50, VIRTUAL_WIDTH, 5)

   push:apply('end')
end