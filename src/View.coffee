class View
  @setRooms = (rooms) -> ViewMatrix.setRooms rooms  

  isVisible = (dir, room) -> room?.boundaries[dir]

  showIfVisible = (dir, room, piece) -> View.Utils.show piece if isVisible dir, room

  @update = (player) -> 
    matrix = ViewMatrix.calculate player
    paths =
      front: [matrix[0][1], matrix[1][1], matrix[2][2]]
      left: [matrix[0][0], matrix[1][0], matrix[2][1]]
      right: [matrix[0][2], matrix[1][2], matrix[2][3]]
      extents:
        left: matrix[2][0]
        right: matrix[2][4]
    heading = player.orientation

    player.boundaries = paths.front[0].boundaries

    @Utils.hideGroup @Pieces.frontPieces   

    showIfVisible heading.forward, paths.front[0], @Pieces.frontPieces[1]
    showIfVisible heading.forward, paths.front[1], @Pieces.frontPieces[4]
    showIfVisible heading.forward, paths.front[2], @Pieces.frontPieces[7]

    showIfVisible heading.forward, paths.left[0], @Pieces.frontPieces[0]
    showIfVisible heading.forward, paths.left[1], @Pieces.frontPieces[3]
    showIfVisible heading.forward, paths.left[2], @Pieces.frontPieces[6]

    showIfVisible heading.forward, paths.right[0], @Pieces.frontPieces[2]
    showIfVisible heading.forward, paths.right[1], @Pieces.frontPieces[5]
    showIfVisible heading.forward, paths.right[2], @Pieces.frontPieces[8]

    showIfVisible heading.forward, paths.extents.left, @Pieces.frontPieces[9]
    showIfVisible heading.forward, paths.extents.right, @Pieces.frontPieces[10]

    @Utils.hideGroup @Pieces.sidePieces

    showIfVisible heading.right, paths.front[0], @Pieces.sidePieces[2]
    showIfVisible heading.right, paths.front[1], @Pieces.sidePieces[6]
    showIfVisible heading.right, paths.front[2], @Pieces.sidePieces[10]

    showIfVisible heading.left, paths.front[0], @Pieces.sidePieces[1]
    showIfVisible heading.left, paths.front[1], @Pieces.sidePieces[5]
    showIfVisible heading.left, paths.front[2], @Pieces.sidePieces[9]

    return paths

  class @Pieces
    @keys = ['floor', 'ceiling', 'side', 'front']
    @getClass = (className) -> (document.getElementsByClassName(className)||[])[0].children
    @floorPieces   = @getClass @keys[0]
    @ceilingPieces = @getClass @keys[1]
    @sidePieces    = @getClass @keys[2]
    @frontPieces   = @getClass @keys[3]
    @allPieces = floor: @floorPieces, ceiling: @ceilingPieces, side: @sidePieces, front: @frontPieces

  class @Utils
    @hide = (e) -> e.style.display = 'none'
    @show = (e) -> e.style.display = 'block'    
    @hideGroup = (pieces) -> View.Utils.hide piece for piece in pieces
    @showGroup = (pieces) -> View.Utils.show piece for piece in pieces    
    @hideAll = -> View.Utils.hideGroup View.Pieces.allPieces[key] for key in View.Pieces.keys
    @showAll = -> View.Utils.showGroup View.Pieces.allPieces[key] for key in View.Pieces.keys

  class ViewMatrix
    @setRooms = (@rooms) ->

    directions = [ ['l', '', 'r'], ['fl', 'f', 'fr'], ['ffll', 'ffl', 'ff', 'ffr', 'ffrr'] ]

    steps = (direction, movement, start) ->
      arr = start.split(':')
      pos = x: parseInt(arr[0],10), y: parseInt(arr[1],10)
      moves = f: 'forward', l: 'left', r: 'right'
      dirs = direction.split('')
      for dir in dirs
        mv = movement[moves[dir]]
        if mv.x? then pos.x += mv.x
        if mv.y? then pos.y += mv.y
      @rooms.getRoomAt(pos.x, pos.y)

    @calculate = (player) ->
      start = player.currentRoom
      movement = player.movement
      [
        [
          steps directions[0][0], movement, start
          steps directions[0][1], movement, start
          steps directions[0][2], movement, start
        ]
        [
          steps directions[1][0], movement, start
          steps directions[1][1], movement, start
          steps directions[1][2], movement, start
        ]
        [
          steps directions[2][0], movement, start
          steps directions[2][1], movement, start
          steps directions[2][2], movement, start
          steps directions[2][3], movement, start
          steps directions[2][4], movement, start
        ]
      ]