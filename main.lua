push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
   local file = io.open('highScore.txt', 'r')
   love.graphics.setDefaultFilter('nearest', 'nearest')

   math.randomseed(os.time())

   scoreFont = love.graphics.newFont('font.ttf', 8)
   infoFont = love.graphics.newFont('font.ttf', 16)

   love.graphics.setFont(scoreFont)

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
   player = Paddle(VIRTUAL_WIDTH / 2 - 18, VIRTUAL_HEIGHT - 30, 36, 5)

   -- Ball moves to every direction
   ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT - 35, 4, 4)

   gameState = 'start'
end

function love.update(dt)
      if gameState == 'play' then
         -- Player movement
      if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
         player.dx = -PADDLE_SPEED
      elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
         player.dx = PADDLE_SPEED
      else
         player.dx = 0
      end
      -- ball update
      ball:update(dt)
   end

   player:update(dt)
end

function love.keypressed(key)
   if key == 'escape' then
      love.event.quit()
   elseif key == 'enter' or key == 'return' then
      if gameState == 'start' then
         gameState = 'play'
      else
         gameState = 'start'

         player:reset()
         ball:reset()
      end
   end
end


function love.draw()
   push:apply('start')

   love.graphics.clear(40/255, 45/255, 52/255, 255/255) -- (R, G, B, Transparency)
   love.graphics.setFont(scoreFont)
   
   love.graphics.print(tostring(lifePoint)..' LP', VIRTUAL_WIDTH / 4 - 8, 10)
   love.graphics.print(tostring(playerScore), VIRTUAL_WIDTH / 4, 20)
   
   love.graphics.print('HIGH SCORE', VIRTUAL_WIDTH / 2 - 20, 10)
   love.graphics.print(tostring(highScore), VIRTUAL_WIDTH / 2, 20)

   if gameState == 'start' then
      love.graphics.setFont(infoFont)
      love.graphics.printf(
         'Press ENTER to start!', 
         0, 
         VIRTUAL_HEIGHT / 2-8, -- (Halfway down the screen) - (Font size)
         VIRTUAL_WIDTH, 
         'center'
      )
   end
   
   player:render()
   ball:render()

   love.graphics.rectangle('fill', 0, 30, VIRTUAL_WIDTH, 5)

   push:apply('end')
end