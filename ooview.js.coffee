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

  $.fn.oo =(method)->
    if method?
      $.oo.instance(this)[method]()
    else
      $.oo.instance(this)

)(jQuery)

class OOView
  constructor: (@dom)->
    @event = new OOEvent @dom
  events: (rules)->
    @event.add rules
  find: (selector)->
    @dom.find selector

class OOEvent
  constructor: (@dom)->
  add: (rules)->
    for key, method of rules
      [action, selector] = @_readKey key
      @dom.on(action, selector, method)

  _readKey: (key)->
    split_index = key.indexOf ' '
    action      = key.substr 0, split_index
    selector    = key.substr split_index + 1
    [action, selector]

