class Player
  constructor: (options) -> @setPosition(options)

  movements =
    north: forward: { y: -1 }, right: { x:  1 }, back: { y:  1 }, left: { x: -1 }
    east:  forward: { x:  1 }, right: { y:  1 }, back: { x: -1 }, left: { y: -1 }
    south: forward: { y:  1 }, right: { x: -1 }, back: { y: -1 }, left: { x:  1 }
    west:  forward: { x: -1 }, right: { y: -1 }, back: { x:  1 }, left: { y:  1 }

  orientation = 
      north: forward: 'north', right: 'east',  left: 'west',  back: 'south'
      east:  forward: 'east' , right: 'south', left: 'north', back: 'west'
      south: forward: 'south', right: 'west',  left: 'east',  back: 'north'
      west:  forward: 'west',  right: 'north', left: 'south', back: 'east'

  setPosition: (options) ->
    options = options or {}
    {x, y, heading} = options
    @x = x or @x or 0
    @y = y or @y or 0
    @heading = heading or @heading or 'south'
    @update()

  offsetPosition: (options) ->
    options = options or {}
    {x, y, heading} = options
    if x? then @x += x 
    if y? then @y += y
    if heading? then @heading = heading
    @update()

  canMoveForward: -> not @boundaries[@orientation.forward]
  canMoveBackward: -> not @boundaries[@orientation.back]
  canMoveRight: -> not @boundaries[@orientation.right]
  canMoveLeft: -> not @boundaries[@orientation.left]

  move: (dir) -> @offsetPosition @movement[dir]
  moveForward: -> @move 'forward' if @canMoveForward()
  moveBackward: -> @move 'back' if @canMoveBackward()
  moveRight: -> @move 'right' if @canMoveRight()
  moveLeft: -> @move 'left' if @canMoveLeft()
  
  turn: (dir) -> @offsetPosition heading: @orientation[dir]
  turnLeft: -> @turn 'left'
  turnRight: -> @turn 'right'

  update: ->
    @movement = movements[@heading]
    @orientation = orientation[@heading]
    @currentRoom = "#{@x}:#{@y}"
    View.update @