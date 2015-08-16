fixture = $("#qunit-fixture")
htmlScore = '
  <div class="oo-score">
    <div class="reset"></div>
    <input type="text" name="score" value="9">
  </div>
  '
beforeEach =->
  $.oo.update()
  fixture.append(htmlScore)
  $.oo.bind "score", Score

QUnit.test "bind view object to element", (assert)->
  beforeEach()
  assert.ok $(".oo-score").oo() instanceof Score

QUnit.test "get view object", (assert)->
  beforeEach()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "send message to view object", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  assert.equal $(".oo-score").oo("score"), 0

QUnit.test "events not valid to child oo view", (assert)->
  beforeEach()
  $(".oo-score").append("<div class='oo-other'><div class='reset'></div></div>")
  $(".oo-score .oo-other .reset").click()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "event rule does not allow ,", (assert)->
  beforeEach()
  event = new OOEvent($(".oo-score"))
  assert.throws(->event.add("click .reset, .zero": (->)))

QUnit.test "send method with argument", (assert)->
  beforeEach()
  $(".oo-score").oo("setScore", 2)
  assert.equal $(".oo-score").oo("score"), 2

QUnit.test "update() handle inserted html", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.append(htmlScore)
  $.oo.update()
  assert.equal $(".oo-score:last").oo("score"), 9

QUnit.test "update() handle deleted html", (assert)->
  beforeEach()
  $(".oo-score").remove()
  $.oo.update()
  assert.equal $.oo.instanceCount(), 0
