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
