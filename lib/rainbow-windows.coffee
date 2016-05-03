{CompositeDisposable} = require 'atom'

module.exports = RainbowWindows =
  config:
    enabledByDefault:
      description: 'Show the color bar automatically on new windows (you can still toggle it on a per window basis).'
      type: 'boolean'
      default: true

  subscriptions: null
  className: 'rainbow-windows'
  colorList: ['crimson', 'dodgerblue', 'limegreen', 'yellow', 'purple', 'orange', 'hotpink']
  colorIndex: 0

  activate: (state) ->
    @colorIndex = state.colorIndex
    @colorIndex ?= atom.getCurrentWindow().id % @colorCount()
    @initSubscriptions()
    @initStyle()
    if atom.config.get('rainbow-windows.enabledByDefault')
      @enable()

  serialize: ->
    { colorIndex: @colorIndex }

  deactivate: ->
    @disable()
    @subscriptions.dispose()

  toggle: ->
    @bodyClassList().toggle(@className)

  enable: ->
    @bodyClassList().add(@className)

  disable: ->
    atom.window.document.head.removeChild(@style)
    @bodyClassList().remove(@className)

  bodyClassList: ->
    atom.window.document.body.classList

  reload: ->
    @updateStyle()

  nextColor: ->
    @colorIndex = (@colorIndex + 1) % @colorCount()
    @reload()

  previousColor: ->
    @colorIndex = (@colorIndex - 1 + @colorCount()) % @colorCount()
    @reload()

  colorCount: ->
    @colorList.length

  borderWidth: ->
    '5px'

  borderColor: ->
    console.log(@colorIndex)
    @colorList[@colorIndex]

  initStyle: ->
    @style = atom.window.document.createElement('style')
    @style.type = 'text/css'
    atom.window.document.head.appendChild(@style)
    @updateStyle()

  updateStyle: ->
    @style.innerHTML = ".#{@className} { border-top: #{@borderWidth()} solid #{@borderColor()}; }"

  initSubscriptions: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:next-color': => @nextColor()
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:previous-color': => @previousColor()
