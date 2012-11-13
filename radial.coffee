
class MenuItem
  constructor : (@text, @angle,@radius, @originNode) ->
    @originNode.style.display = 'none'

  setPaper : (@paper) ->

  render : ->
    @paper.setStart()
    @textElement = @paper.text @radius, 0, " #{@text} "
    @textElement.attr
      'font-size' : 15
      'text-anchor' : 'start'
    boxDimensions = @textElement.getBBox()
    @boxElement = @paper.rect boxDimensions.x, boxDimensions.y, boxDimensions.width, boxDimensions.height
    @boxElement.attr
      fill : '#99f'
      stroke : 0
    @textElement.toFront()
    @set = @paper.setFinish()
    @set.attr
      cursor : 'pointer'
    unless @eventsBound?
      do @bindEvents

  bindEvents : ->
    @eventsBound = true
    @set.mouseover =>
      boxAttrs =
        fill : '#44f'
      @boxElement.animate boxAttrs, 400, '<>'
    @set.mouseout =>
      boxAttrs =
        fill : '#99f'
      @boxElement.animate boxAttrs, 400, '<>'
        

  setAngle : (@angle) ->
    do @show
  hide : ->
    newAttributes = 
      transform : "r-10,0,0"
    @set.animate newAttributes, 800, "<"

  show : ->
    newAttributes = 
      transform : "r#{@angle},0,0"
    @set.animate newAttributes, 800, "<>"

    


class Radial
  constructor : (@domSource, @domTarget = @domSource, @radius, @width = 200, @height = 200) ->
    @items = []
    for liNode in @domSource.childNodes
      if liNode.nodeName isnt 'LI'
        throw new Error "Expected, <li> child nodes, found #{liNode.nodeName}"
      for aNode in liNode.childNodes
        if aNode.nodeName isnt 'A'
          throw new Error "Expected, <a> grandchild node, found #{aNode.nodeName}"
        @addItem aNode
    _menuRef = @
    @itemsShown = false
    new Raphael @domTarget, @width, @height, ->
      _menuRef.paper = this
      do _menuRef.render

  render : ->
    @center = @paper.ellipse 0, 0, @radius, @radius
    @center.attr
      fill : "r#55f-#99f"
      stroke : 0
    totalAvailable = 80
    individualSpan = totalAvailable / @items.length
    currentAngle = 10
    for item, idx in @items
      item.setPaper @paper
      item.render()
      item.setAngle currentAngle
      currentAngle += individualSpan
    @center.toFront()
    @itemsShown = true
    @center.click =>
      do @toggleItems

  toggleItems : ->
      item.hide() for item in @items if @itemsShown
      item.show() for item in @items if not @itemsShown
      @itemsShown = not @itemsShown

  addItem : (aNode) ->
    @items.push new MenuItem aNode.text, 0, @radius, aNode

window.Radial = Radial
