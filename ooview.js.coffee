ooId = 0
@oo = {
  bind: (classname, kls)->
    oo._binds[classname] = kls
    for dom in $(".oo-#{classname}")
      oo._bindElement(kls, dom)

  update: ->
    for classname, kls of oo._binds
      for dom in $(".oo-#{classname}").not("[ooId]")
        oo._bindElement(kls, dom)
    removed = []
    for id, obj of oo._instances
      if $("[ooId=#{id}]").length == 0
        removed.push id
    for id in removed
      delete oo._instances[id]

  instance: (element)=>
    oo._instances[element.attr("ooId")]

  _binds: {}

  _instances: {}

  _newId: ->
    "#{++ooId}"

  _bindElement: (kls, dom) ->
    id = oo._newId()
    $(dom).attr("ooId", id)
    oo._instances[id] = new kls($(dom))
}

$.fn.oo =->
  oo.instance(this)
