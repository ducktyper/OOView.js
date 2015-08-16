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

QUnit.test "bind class to element", (assert)->
  beforeEach()
  assert.ok $(".oo-score").oo() instanceof Score

QUnit.test "get binded instance", (assert)->
  beforeEach()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "set event in constructor", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  assert.equal $(".oo-score").oo("score"), 0

QUnit.test "do not fire events in other oo element", (assert)->
  beforeEach()
  $(".oo-score").append("<div class='oo-other'><div class='reset'></div></div>")
  $(".oo-score .oo-other .reset").click()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "do not allow , in events rule", (assert)->
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
