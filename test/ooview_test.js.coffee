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
  $(".oo-score").ooAppend("<div class='oo-other'><div class='reset'></div></div>")
  $(".oo-score .oo-other .reset").click()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "OOView does not find child oo view", (assert)->
  beforeEach()
  $(".oo-score").ooAppend("<div class='oo-other'><input></div>")
  assert.equal $(".oo-score").oo("scoreField").length, 1

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

QUnit.test "ooAppend to append and update", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.ooAppend(htmlScore)
  assert.equal $(".oo-score:last").oo("score"), 9

QUnit.test "ooPrepend to prepend and update", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.ooPrepend(htmlScore)
  assert.equal $(".oo-score:first").oo("score"), 9

QUnit.test "update() handle deleted html", (assert)->
  beforeEach()
  $(".oo-score").remove()
  $.oo.update()
  assert.equal $.oo.instanceCount(), 0

QUnit.test "error on accessing oo instance not exist", (assert)->
  beforeEach()
  $(".oo-score").ooAppend("<div class='oo-other'><div class='reset'></div></div>")
  assert.throws(-> $(".oo-other").oo())

QUnit.test "error on sending message not exist", (assert)->
  beforeEach()
  assert.throws(-> $(".oo-score").oo("notDefined"))
