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
    return $.error("No OOView Method(#{method}) to undefined") if this.length == 0
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
  events: (obj, rules)->
    @event.add obj, rules
  action: (obj, rules)->
    @current_action.finish() if @current_action?
    @current_action = new OOAction obj, rules
  find: (selector)->
    @element.find(@_directSelector(selector))
  _directSelector: (selector)->
    selector.split(",").map((s) -> ">#{s},:not([class^='oo-']) #{s}").join(",")

convertMethod = (obj, method)->
  if typeof method == "string"
    obj[method].bind(obj)
  else
    method

class OOEvent
  constructor: (@element)->
  add: (obj, rules)->
    for key, method of rules
      [action, selector] = @_readKey key
      @element.on(action, @_directSelector(selector), convertMethod(obj, method))

  _readKey: (key)->
    split_index = key.indexOf ' '
    action      = key.substr 0, split_index
    selector    = key.substr split_index + 1
    [action, selector]

  _directSelector: (selector)->
    selector.split(",").map((s) -> ">#{s},:not([class^='oo-']) #{s}").join(",")

class OOAction
  constructor: (@obj, rules)->
    @rules = @_parseRules(rules)
    @_onEvents(@rules)
    @_onEvents(@_defaultRules())

  desctuctor: ->
    return if @desctucted
    @desctucted = true
    @_offEvents(@rules)
    @_offEvents(@_defaultRules())

  finish: ->
    @desctuctor()

  cancel: ->
    @cancel_action() if @cancel_action?
    @desctuctor()

  _parseRules: (rules)->
    new_rules = {}
    for k, v of rules
      new_rules[k] = convertMethod(@obj, v)
    new_rules

  _cancelOnEsc: (e)=>
    @cancel() if e.which == 27 #ESC

  _defaultRules: ->
    @default_rules ||= {
      "click":    @finish.bind(@)
      "keypress": @_cancelOnEsc.bind(@)
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
