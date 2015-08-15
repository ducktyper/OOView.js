class @Score
  constructor: (@view)->
    @view.events(
      "click .reset": @reset
    )

  reset: (e)=>
    @setScore(0)

  score: ->
    parseInt(@scoreField().val(), 0)

  setScore: (score)->
    @scoreField().val(score)

  scoreField: ->
    @view.find("input")
