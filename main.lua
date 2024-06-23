require 'header'

print(1)

--[[
    1. Improve animations
        a. Die only if animated head collided
        b. Move by ceil: < 0.5 = fuck go back, >= 0.5 = okey les go
]]

local moves = {
    d = vector(1, 0), -- right
    a = vector(-1, 0), -- left
    w = vector(0, -1), -- up
    s = vector(0, 1), -- down
}

local snake = {
    -- Snake body
    body = {},               -- Array of snake body segments
    animated_body = {},      -- Array of segments for animation

    -- Snake movement
    client_last_move = moves.d, -- The last registered movement of the client
    last_move = moves.d,        -- Last move direction
    update_rate = 1 / 8,        -- Position update frequency
    elapsed_time = 0,           -- Time elapsed since the last update

    -- Snake status
    settuped = false,        -- Flag indicating if the snake is set up
    start_body_length = 4,   -- Initial length of the snake's body
    alive = false,           -- Is snake alive

    -- Map data
    map_size = 8,            -- Size of the game field
    apples = {},             -- Apples on the map

    -- Player info
    score = 0,               -- Amount of eated apples
    growth_amount = 0,
} do
    ---@param origin vector
    snake.new_body_part = function(origin)
        table.insert(snake.body, origin)
        table.insert(snake.animated_body, origin)
    end

    snake.reset = function()
        snake.body = {}
        snake.animated_body = {}
        snake.apples = {}
        snake.growth_amount = 0
        snake.score = 0
    end

    snake.setup = function()
        love.graphics.setFont(love.graphics.newFont(24))

        snake.reset()

        local center = math.floor(snake.map_size / 2)
        local length = snake.start_body_length - 1

        for i = 0, length do
            local origin = vector(center - i, center)

            table.insert(snake.body, origin)
            table.insert(snake.animated_body, origin)
        end

        snake.alive = true
        snake.add_apple()

        snake.settuped = true
    end

    ---@return table
    snake.get_free_cells = function()
        local map = {}

        for x = 0, snake.map_size - 1 do
            if not map[x] then
                map[x] = {}
            end
            for y = 0, snake.map_size - 1 do
                map[x][y] = true -- free
            end
        end

        for _, origin in ipairs(snake.body) do
            if not map[origin.x] then
                goto continue
            end
            map[origin.x][origin.y] = false -- not free
            ::continue::
        end

        local heap = {}

        for x = 0, snake.map_size - 1 do
            for y = 0, snake.map_size - 1 do
                if map[x][y] then
                    table.insert(heap, vector(x, y))
                end
            end
        end

        return heap
    end

    ---@return vector|nil
    snake.get_random_free_cell = function()
        local free_cells = snake.get_free_cells()

        if #free_cells == 0 then
            error('Win') -- There is no empty space left
        end

        return free_cells[math.random(1, #free_cells)]
    end

    snake.add_apple = function()
        table.insert(snake.apples, snake.get_random_free_cell())
    end

    ---@return boolean
    snake.is_valid = function()
        return snake.settuped and snake.alive
    end

    ---@return vector
    snake.get_head = function()
        return snake.body[1]
    end

    ---@param direction vector
    ---@return boolean
    snake.is_move_legal = function(direction)
        local head = snake.get_head()
        local predicted_position = head + direction

        return predicted_position ~= snake.body[2]
    end

    ---@param origin vector
    ---@param from vector
    ---@param to vector
    ---@return boolean
    snake.in_bounds = function(origin, from, to)
        return origin.x >= from.x and origin.x <= to.x and origin.y >= from.y and origin.y <= to.y
    end

    ---@return boolean
    snake.is_collided = function()
        local head = snake.get_head()
        local map_size = snake.map_size

        if not snake.in_bounds(head, vector(), vector(map_size - 1)) then
            return true
        end

        for i = 2, #snake.body do
            local part = snake.body[i]

            if head == part then
                return true
            end
        end

        return false
    end

    snake.clmove = function()
        for button, direction in pairs(moves) do
            if love.keyboard.isDown(button) then
                snake.client_last_move = direction
            end
        end
    end

    ---@return vector
    snake.get_move_direction = function()
        return snake.client_last_move
    end

    snake.createmove = function()
        if not snake.is_valid() then
            return
        end

        local move_direction = snake.get_move_direction()
        local last_origin = snake.get_head()

        local is_legal = snake.is_move_legal(move_direction)

        if is_legal then
            snake.body[1] = snake.body[1] + move_direction
            snake.last_move = move_direction
        else
            snake.body[1] = snake.body[1] + snake.last_move
        end

        for i = 2, #snake.body do
            local origin = snake.body[i]

            snake.body[i] = last_origin
            last_origin = origin
        end

        if snake.growth_amount > 0 then
            snake.new_body_part(last_origin)
            snake.growth_amount = snake.growth_amount - 1
            snake.add_apple()
        end
    end

    snake.postmove = function()
        local head = snake.get_head()

        for i, apple in ipairs(snake.apples) do
            if head == apple then
                table.remove(snake.apples, i)
                snake.score = snake.score + 1
                snake.growth_amount = snake.growth_amount + 1
                break
            end
        end

        if snake.is_collided() then
            snake.alive = false
        end
    end

    snake.update_animations = function()
        for i = 1, #snake.animated_body do
            local origin = snake.animated_body[i]
            snake.animated_body[i] = origin:lerp(snake.body[i], 0.22)
        end
    end

    snake.menu = function()
        color(0.556, 0.709, 0.274):set(true)

        gui.add_button(window / 2, vector(200, 50), 'Play', color(0.5), true)
    end

    snake.render = function()
        if not snake.is_valid() then
            snake.menu()
            return
        end

        snake.update_animations()

        local step = window / snake.map_size

        color(0.556, 0.709, 0.274):set(true)
        color(0.666, 0.843, 0.317):set()

        local skip = true

        for x = 0, window.x, step.x do
            for y = 0, window.y, step.y do
                if not skip then
                    love.graphics.rectangle('fill', x, y, step.x, step.y)
                end
                skip = not skip
            end
        end

        for i = 1, #snake.animated_body do
            local origin = snake.animated_body[i]
            local t = (i - 1) / (#snake.animated_body - 1)
            local r = 0.305 * (1 - t) + 0.1 * t
            local g = 0.486 * (1 - t) + 0.3 * t
            local b = 0.964 * (1 - t) + 0.682 * t

            color(r, g, b):set()

            love.graphics.rectangle(
                "fill",
                origin.x * step.x, origin.y * step.y,
                step.x - 2, step.y - 2,
                45, 45
            )
        end

        color(0.9, 0.2, 0.2):set()

        for _, apple in ipairs(snake.apples) do
            love.graphics.rectangle(
                "fill",
                apple.x * step.x, apple.y * step.y,
                step.x - 2, step.y - 2,
                45, 45
            )
        end
    end

    snake.main = function(dt)
        if not snake.is_valid() then
            return
        end

        snake.clmove() -- Keys pressing by the client

        snake.elapsed_time = snake.elapsed_time + dt

        if snake.elapsed_time >= snake.update_rate then
            snake.createmove() -- Calculation of movement
            snake.postmove() -- Actions after movement
            snake.elapsed_time = 0
        end
    end

    callbacks.add('load', snake.setup)
    callbacks.add('update', snake.main)
    callbacks.add('draw', snake.render)
end

callbacks.init()