class Room
  constructor: (options) -> {@x, @y, @boundaries} = options
  position: -> "#{@x}:#{@y}"

class Rooms
  constructor: (@width, @height) ->
    for w in [0..@width]
      for h in [0..@height]
        boundaries = 
          north: h is 0
          east:  w is @width
          south: h is @height
          west:  w is 0
        options = x: w, y: h, boundaries: boundaries
        room = new Room(options)
        @[room.position()] = room
    View.setRooms @

  getRoomAt: (x, y) -> @["#{x}:#{y}"]

  getRelativeRoom: (start, steps...) -> 
    positionArray = start.split ':'
    position = x: positionArray[0], y: positionArray[1]
    for step in steps
      if step.x? then position.x += step.x
      if step.y? then position.y += step.y
    @["#{x}:#{y}"]