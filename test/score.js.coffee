class @Score
  constructor: (@view)->
    @view.events(
      "click .reset": @reset
      "focus input": @editScore
    )

  reset: (e)=>
    @setScore(0)

  editScore: (e)=>
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
    @oo.view.action(
      "keypress": @upDownKey
      "cancel": @rollback
    )

  rollback: =>
    @oo.setScore(@backup)

  upDownKey: (e)=>
    if e.which == 38
      @oo.setScore(@oo.score() + 1)
    if e.which == 40
      @oo.setScore(@oo.score() - 1)
