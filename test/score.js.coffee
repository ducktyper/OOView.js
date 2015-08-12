class @Score
  constructor: (@dom)->
    $(@dom).find(".reset").click => @reset()

  reset: ->
    @setScore(0)

  score: ->
    parseInt(@scoreField().val(), 0)

  setScore: (score)->
    @scoreField().val(score)

  scoreField: ->
    $(@dom).find("input")
