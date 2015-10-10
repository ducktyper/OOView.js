(($)->

  # avoid loading OOView twice
  if ($.oo != undefined)
    $.error('OOView has already been loaded!')

  binds = {}

  bindElement =(kls, dom)->
    $(dom).data("oo", new kls(new OOView($(dom))))

  $.oo = {
    bind: (classname, kls)->
      binds[classname] = kls
      for dom in $(".oo-#{classname}")
        bindElement(kls, dom)

    update: ->
      for classname, kls of binds
        for dom in $(".oo-#{classname}").filter(-> !$(this).data('oo')?)
          bindElement(kls, dom)

    view: (classname, data, html="")->
      "<div class=\"oo-#{classname}\" oo=#{JSON.stringify(data)}>#{html}</div>"

    instance: (element)->
      element.data("oo") || $.error("No OOView to element(.#{element.attr('class')})")

    instanceCount: ->
      $('[class^="oo-"]').filter(-> $(this).data('oo')?).length
  }

  $.fn.oo =(method,args...)->
    return $.oo.instance(this) unless method?
    last_result = undefined
    this.each ->
      instance = $.oo.instance($(this))
      if instance[method]?
        last_result = instance[method].apply(instance, args)
      else
        $.error("No OOView Method(#{method}) to element(.#{$(this).attr('class')})")
    last_result

  $.fn.ooAppend =(args...)->
    out = this.append.apply(this, args)
    $.oo.update()
    out

  $.fn.ooPrepend =(args...)->
    out = this.prepend.apply(this, args)
    $.oo.update()
    out

)(jQuery)

class OOView
  constructor: (@element)->
    @data = {}
    if @element.attr("oo")?
      @data = JSON.parse(@element.attr("oo"))
    @event = new OOEvent @element
  events: (rules)->
    @event.add rules
  action: (rules)->
    @current_action.finish() if @current_action?
    @current_action = new OOAction rules
  find: (selector)->
    @element.find(@_directSelector(selector))
  _directSelector: (selector)->
    selector.split(",").map((s) -> ">#{s},:not([class^='oo-']) #{s}").join(",")

class OOEvent
  constructor: (@element)->
  add: (rules)->
    for key, method of rules
      [action, selector] = @_readKey key
      @element.on(action, @_directSelector(selector), method)

  _readKey: (key)->
    split_index = key.indexOf ' '
    action      = key.substr 0, split_index
    selector    = key.substr split_index + 1
    [action, selector]

  _directSelector: (selector)->
    selector.split(",").map((s) -> ">#{s},:not([class^='oo-']) #{s}").join(",")

class OOAction
  constructor: (@rules)->
    @_onEvents(@rules)
    @_onEvents(@_defaultRules())

  desctuctor: =>
    return if @desctucted
    @desctucted = true
    @_offEvents(@rules)
    @_offEvents(@_defaultRules())

  finish: =>
    @desctuctor()

  cancel: =>
    @cancel_action() if @cancel_action?
    @desctuctor()

  _cancelOnEsc: (e)=>
    @cancel() if e.which == 27 #ESC

  _defaultRules: ->
    @default_rules ||= {
      "click": @finish
      "keypress": @_cancelOnEsc
    }

  _onEvents: (rules)->
    for key, method of rules
      [action, selector] = @_readKey key
      switch action
        when "cancel" then @cancel_action = method
        else $(selector).on(action, method)

  _offEvents: (rules)->
    for key, method of rules
      [action, selector] = @_readKey key
      switch action
        when "cancel" then @cancel_action = undefined
        else $(selector).off(action, method)

  _readKey: (key)->
    split_index = key.indexOf ' '
    return [key, document] if split_index == -1
    action      = key.substr 0, split_index
    selector    = key.substr split_index + 1
    [action, selector]

  _directSelector: (selector)->
    selector.split(",").map((s) -> ">#{s},:not([class^='oo-']) #{s}").join(",")
