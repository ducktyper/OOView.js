(($)->

  # avoid loading OOView twice
  if ($.oo != undefined)
    $.error('OOView has already been loaded!')

  ooId      = 0  # auto-increment instance id
  binds     = {}
  instances = {}

  newId =->
    "#{++ooId}"

  bindElement =(kls, dom)->
    id = newId()
    $(dom).attr("ooId", id)
    instances[id] = new kls(new OOView($(dom)))

  $.oo = {
    bind: (classname, kls)->
      binds[classname] = kls
      for dom in $(".oo-#{classname}")
        bindElement(kls, dom)

    update: ->
      for classname, kls of binds
        for dom in $(".oo-#{classname}").not("[ooId]")
          bindElement(kls, dom)
      removed = []
      for id, obj of instances
        if $("[ooId=#{id}]").length == 0
          removed.push id
      for id in removed
        delete instances[id]

    instance: (element)->
      instances[element.attr("ooId")]

    instanceCount: ->
      Object.keys(instances).length

  }

  $.fn.oo =->
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

