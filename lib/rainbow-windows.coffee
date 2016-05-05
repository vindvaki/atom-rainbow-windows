{CompositeDisposable} = require 'atom'

module.exports = RainbowWindows =
  config:
    enabledByDefault:
      description: 'Show the color bar automatically on new windows (you can still toggle it on a per window basis).'
      type: 'boolean'
      default: true
    width:
      description: 'The width of the color bar in pixels (between 1 and 20)'
      type: 'integer'
      default: 5
      minimum: 1
      maximum: 20

  subscriptions: null
  className: 'rainbow-windows'
  colorList: ['crimson', 'dodgerblue', 'limegreen', 'yellow', 'purple', 'orange', 'hotpink']
  colorIndex: 0

  activate: (state) ->
    @colorIndex = state.colorIndex
    @colorIndex ?= atom.getCurrentWindow().id % @colorCount()
    @initSubscriptions()
    @initStyle()
    atom.config.onDidChange 'rainbow-windows.width', (event) =>
      @reload()
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

  nextColor: ->
    @colorIndex = (@colorIndex + 1) % @colorCount()
    @reload()

  previousColor: ->
    @colorIndex = (@colorIndex - 1 + @colorCount()) % @colorCount()
    @reload()

  colorCount: ->
    @colorList.length

  borderWidth: ->
    "#{atom.config.get('rainbow-windows.width')}px"

  borderColor: ->
    @colorList[@colorIndex]

  initStyle: ->
    @style = atom.window.document.createElement('style')
    @style.type = 'text/css'
    atom.window.document.head.appendChild(@style)
    @reload()

  reload: ->
    @style.innerHTML = ".#{@className} { border-top: #{@borderWidth()} solid #{@borderColor()}; }"

  initSubscriptions: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:next-color': => @nextColor()
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:previous-color': => @previousColor()
