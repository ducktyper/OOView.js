class @Score
  constructor: (@view)->
    @view.events(@,
      "click .reset": "reset"
      "focus input":  "editScore"
    )

  reset: (e)->
    @setScore(0)

  editScore: (e)->
    new EditScore(@)

  score: ->
    parseInt(@scoreField().val(), 0)

  setScore: (score)->
    @scoreField().val(score)

  scoreField: ->
    @view.find("input")

class EditScore
  constructor: (@oo)->
    @backup = @oo.score()
    @oo.view.action(@,
      "keypress": "keypress"
      "finish":   "blurInput"
      "click":    -> "finish"
    )

  keypress: (e)->
    switch e.which
      when 38 then @oo.setScore(@oo.score() + 1) # up
      when 40 then @oo.setScore(@oo.score() - 1) # down
      when 13 then "finish" # enter

  blurInput: ->
    @oo.view.find("input").blur()

