push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
LP = 3

function love.load()
   local file = io.open('highScore.txt', 'r')
   love.graphics.setDefaultFilter('nearest', 'nearest')
   love.window.setTitle('Brick Breaker')

   math.randomseed(os.time())

   scoreFont = love.graphics.newFont('font.ttf', 8)
   infoFont = love.graphics.newFont('font.ttf', 16)

   love.graphics.setFont(scoreFont)

   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = true
   })

   score = 0
   lifePoint = LP
   highScore = file:read('*all')
   file:close()

   -- Only moves to right and left, start center
   player = Paddle(VIRTUAL_WIDTH / 2 - 18, VIRTUAL_HEIGHT - 30, 36, 5)

   -- Ball moves to every direction
   ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT - 35, 4, 4)

   gameState = 'start'
end

function SaveScore()
   if score > tonumber(highScore) then
      local file = io.open('highScore.txt', 'w')
      file:write(tostring(score))
      file:close()

      -- update the High Score into current section
      highScore = score
   end
end

function love.update(dt)
   if gameState == 'play' then
      -- detect paddle colision
      if ball:collides(player) then
         ball.dy = -ball.dy * 1.1
         ball.y = player.y - 4
         score = score + 3

         if ball.dx < 0 then
            ball.dx = -math.random(10, 150)
         else
            ball.dx = math.random(10, 150)
         end
      end

      if gameState == 'start' then
         ball.dx = math.random(-50, 50)
         ball.dy = -math.random(140, 200)
      end

      -- detect sides colision
      if ball.x <= 0 then
         ball.x = 0
         ball.dx = -ball.dx * 1.05
         score = score + 1
      end

      if ball.x >= VIRTUAL_WIDTH - 4 then
         ball.x = VIRTUAL_WIDTH - 4
         ball.dx = -ball.dx * 1.05
         score = score + 1
      end

      -- detect top colision and bottom colision
      if ball.y <= 34 then
         ball.y = 34
         ball.dy = -ball.dy * 1.05
         score = score + 1
      end

      if ball.y >= VIRTUAL_HEIGHT - 4 then
         lifePoint = lifePoint - 1
         if lifePoint <= 0 then
            SaveScore()
            
            score = 0
            lifePoint = LP
         end

         player:reset()
         ball:reset()
         gameState = 'start'
      end

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
      if gameState == 'start' or gameState == 'pause' then
         gameState = 'play'
      else
         gameState = 'pause'
      end
   end
end


function love.draw()
   push:apply('start')

   love.graphics.clear(40/255, 45/255, 52/255, 255/255) -- (R, G, B, Transparency)
   love.graphics.setFont(scoreFont)
   
   love.graphics.print(tostring(lifePoint)..' LP', VIRTUAL_WIDTH / 4 - 8, 10)
   love.graphics.print(tostring(score), VIRTUAL_WIDTH / 4, 20)
   
   love.graphics.print('HIGH SCORE', VIRTUAL_WIDTH / 2 - 20, 10)
   love.graphics.print(tostring(highScore), VIRTUAL_WIDTH / 2, 20)

   if gameState == 'start' then
      love.graphics.setFont(infoFont)
      love.graphics.printf(
         'Press ENTER!', 
         0, 
         VIRTUAL_HEIGHT / 2-8, -- (Halfway down the screen) - (Font size)
         VIRTUAL_WIDTH, 
         'center'
      )
   end

   if gameState == 'pause' then
      love.graphics.setFont(infoFont)
      love.graphics.printf(
         'PAUSED',
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