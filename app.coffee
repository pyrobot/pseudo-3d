class View
  class @Pieces
    @keys = ['floor', 'ceiling', 'side', 'front']
    @floorPieces   = document.getElementsByClassName('floor')[0].children
    @ceilingPieces = document.getElementsByClassName('ceiling')[0].children
    @sidePieces    = document.getElementsByClassName('side')[0].children
    @frontPieces   = document.getElementsByClassName('front')[0].children
    @allPieces = floor: @floorPieces, ceiling: @ceilingPieces, side: @sidePieces, front: @frontPieces
  class @Utils
    @hide = (e) -> e.style.display = 'none'
    @show = (e) -> e.style.display = 'block'    
    @hideGroup = (pieces) -> View.Utils.hide piece for piece in pieces
    @showGroup = (pieces) -> View.Utils.show piece for piece in pieces    
    @hideAll = -> View.Utils.hideGroup View.Pieces.allPieces[key] for key in View.Pieces.keys
    @showAll = -> View.Utils.showGroup View.Pieces.allPieces[key] for key in View.Pieces.keys

class Room
  constructor: (options) -> {@x, @y, @directionLinks, @boundary} = options
  position: -> "#{@x}:#{@y}"

class Rooms
  constructor: (@width, @height) ->
    @length = (@width+1) * (@height+1)
    for w in [0..@width]
      for h in [0..@height]
        directionLinks = north: h is 0, east: h is @width, south: h is @height, west: w is 0
        boundary = if directionLinks.north or directionLinks.east or 
                      directionLinks.south or directionLinks.west then true else false
        options = x: w, y: h, directionLinks: directionLinks, boundary: boundary
        room = new Room(options)
        @[room.position()] = room

class Player
  constructor: (options) -> @setPosition(options)
  setPosition: (options) ->
    {@x, @y, @heading} = options
    @x = @x or 0
    @y = @y or 0
    @heading = @heading or 'south'
    @currentRoom = "#{@x}:#{@y}"
  offsetPosition: (options) ->
    {x, y, heading} = options
    if x? then @x += x 
    if y? then @y += y
    if heading then @heading = heading
    @currentRoom = "#{@x}:#{@y}"

class ViewMatrix

player = new Player(x:5)
rooms = new Rooms(9, 9)