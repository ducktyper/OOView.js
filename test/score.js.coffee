class @Score
  constructor: (@view)->
    @view.events(
      "click .reset": @reset
      "focus input": @editScore
    )

  reset: (e)=>
    @setScore(0)

  editScore: (e)=>
    @view.action(
      "keypress": @upDownKey
    )

  upDownKey: (e)=>
    if e.which == 38
      @setScore(@score() + 1)
    if e.which == 40
      @setScore(@score() - 1)

  score: ->
    parseInt(@scoreField().val(), 0)

  setScore: (score)->
    @scoreField().val(score)

  scoreField: ->
    @view.find("input")
