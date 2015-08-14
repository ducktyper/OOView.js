(($)->

  if ($.oo != undefined)
    $.error('OOView has already been loaded!')

  ooId      = 0
  binds     = {}
  instances = {}

  newId =->
    "#{++ooId}"

  bindElement =(kls, dom)->
    id = newId()
    $(dom).attr("ooId", id)
    instances[id] = new kls($(dom))

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
