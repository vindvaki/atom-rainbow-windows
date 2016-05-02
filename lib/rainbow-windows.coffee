{CompositeDisposable} = require 'atom'

module.exports = RainbowWindows =
  subscriptions: null
  classNameBase: 'rainbow-windows'
  colorCount: 7 # TODO: Programmatically generate the colors

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'rainbow-windows:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  toggle: ->
    if @isEnabled()
      @disable()
    else
      @enable()

  enable: ->
    @bodyClassList().add(@currentWindowClassName())
    atom.getCurrentWindow()

  disable: ->
    @bodyClassList().remove(@currentWindowClassName())

  isEnabled: ->
    @bodyClassList().contains(@currentWindowClassName())

  bodyClassList: ->
    atom.window.document.body.classList

  currentWindowClassName: ->
    "#{@classNameBase}-#{atom.getCurrentWindow().id % @colorCount}"
