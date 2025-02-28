# Globals stuff
window.fi =
  config: {}

window.puts = (string) -> console.log?(string) if console


class fi.Loader
  @_loading = false
  @_loaded  = false
  @_modulesOrder = ['mod1', 'mod2', 'mod3', 'mod4']

  @_defineModules: ->
    define 'mod1', [
      'javascripts/libs/jquery.js'
    ]

    define 'mod2', [
      'javascripts/libs/sugar.min.js',
      'javascripts/engine/class_attributes.js',
      'javascripts/engine/board.js'
    ]

    define 'mod3', [
      'javascripts/engine/sprite.js',
      'javascripts/engine/board_object.js',
      'javascripts/engine/keyboard.js',
      'javascripts/engine/game.js',
      'javascripts/engine/message_board.js',
      'javascripts/engine/game_board.js'
    ]

    define 'mod4', [
      'javascripts/game/player.js',
      'javascripts/game/missile.js'
      'javascripts/game/alien.js'
    ]

  @_loadModulesInOrder: (orderedModuleNames)->
    if orderedModuleNames.length == 0
      @_loaded = true
      $ => @_loadedCallback.call(document)
    else
      require orderedModuleNames.splice(0,1), => @_loadModulesInOrder orderedModuleNames

  @loadScripts: (loadedCallback)->
    return if @_loading or @_loaded
    @_loadedCallback = loadedCallback
    @_loading = true
    @_defineModules()
    @_loadModulesInOrder @_modulesOrder


fi.Loader.loadScripts ->
  fi.game = new fi.Game '#gameboard'

  fi.game.loadBoard fi.MessageBoard,
    title: "coffee-invaders"
    subtitle: "THE GAME"
    onFirePressed: ->
      fi.game.loadBoard fi.GameBoard, 1

  fi.game.startLoop()