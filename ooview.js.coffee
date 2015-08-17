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

    instance: (element)->
      element.data("oo")

    instanceCount: ->
      $('[class^="oo-"]').filter(-> $(this).data('oo')?).length
  }

  $.fn.oo =(method,args...)->
    instance = $.oo.instance(this)
    if method?
      instance[method].apply(instance, args)
    else
      instance

  $.fn.ooAppend =(args...)->
    out = this.append.apply(this, args)
    $.oo.update()
    out

  $.fn.ooPrepend =(args...)->
    out = this.prepend.apply(this, args)
    $.oo.update()
    out

)(jQuery)

class @OOView
  constructor: (@element)->
    @event = new OOEvent @element
  events: (rules)->
    @event.add rules
  find: (selector)->
    @element.find selector

class @OOEvent
  constructor: (@element)->
  add: (rules)->
    for key, method of rules
      [action, selector] = @_readKey key
      @element.on(action, "> #{selector}, :not([class^='oo-']) #{selector}", method)

  _readKey: (key)->
    split_index = key.indexOf ' '
    action      = key.substr 0, split_index
    selector    = key.substr split_index + 1
    $.error("oo event selector does not allow ,") if selector.indexOf(',') != -1
    [action, selector]

