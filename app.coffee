# gameWindow = document.getElementsByClassName('game-window')[0]
# toggleValue = false
# setPerspective = (value) -> 
#   for prefix in ['-webkit-', '-moz-', '-ms-', '-o-', ''] 
#     gameWindow.style["#{prefix}perspective"] = value

# setInterval ->
#   toggleValue = !toggleValue
#   setPerspective if toggleValue is false then "50px" else "450px"
# , 2000