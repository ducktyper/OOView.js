QUnit.test "bind class to element", (assert)->
  oo.bind "score", Score
  assert.ok $(".oo-score").oo() instanceof Score

QUnit.test "get binded instance", (assert)->
  oo.bind "score", Score
  assert.equal $(".oo-score").oo().score(), 9

QUnit.test "set event in constructor", (assert)->
  oo.bind "score", Score
  $(".oo-score .reset").click()
  assert.equal $(".oo-score").oo().score(), 0

QUnit.test "update() handle inserted html", (assert)->
  oo.bind "score", Score
  $("#qunit-fixture").append("
    <div class='new oo-score'>
      <div class='reset'></div>
      <input type='text' name='score' value='2'>
    </div>
  ")
  oo.update()
  assert.ok($(".new.oo-score").oo() instanceof Score)
  assert.equal($(".new.oo-score").oo().score(), 2)

QUnit.test "update() handle deleted html", (assert)->
  oo.bind "score", Score
  $(".oo-score").remove()
  oo.update()
  assert.ok($.isEmptyObject(oo._instances))
