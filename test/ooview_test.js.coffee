fixture = $("#qunit-fixture")
htmlScore = '
  <div class="oo-score">
    <div class="reset"></div>
    <input type="text" name="score" value="9">
  </div>
  '
beforeEach =->
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

QUnit.test "send message to view object", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  assert.equal $(".oo-score").oo("score"), 0

QUnit.test "send message apply to all matched element", (assert)->
  beforeEach()
  fixture.ooAppend(htmlScore)
  $(".oo-score").oo("setScore", 5)
  $(".oo-score").each -> assert.equal $(this).oo("score"), 5

QUnit.test "error on sending message to element not exist", (assert)->
  beforeEach()
  assert.throws(-> $(".oo-other").oo())

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

QUnit.test "oo attributes to data", (assert)->
  $.oo.update()
  fixture.append(htmlScore)
  $(".oo-score").attr("oo", JSON.stringify(name: "bob"))
  $.oo.bind "score", Score
  assert.equal $(".oo-score").oo().view.data.name, "bob"

QUnit.test "oo.view generates html", (assert)->
  html = $.oo.view("score", score: 1, name: "score1")
  assert.equal html, '<div class="oo-score" oo={"score":1,"name":"score1"}></div>'

QUnit.test "oo.view generates html with content", (assert)->
  html = $.oo.view("score", score: 1, name: "score1", "<div>content</div>")
  assert.equal html,
    '<div class="oo-score" oo={"score":1,"name":"score1"}><div>content</div></div>'

QUnit.test "view.action adds temp events", (assert)->
  beforeEach()
  fixture.find("input").focus()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 10
  e.which = 40 # down
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "view.action finishes on click by default", (assert)->
  beforeEach()
  fixture.find("input").focus()
  $(".oo-score").click()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "cancel view.action by click esc", (assert)->
  beforeEach()
  fixture.find("input").focus()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  e.which = 27 # esc
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "cancel view.action calls callback", (assert)->
  beforeEach()
  fixture.find("input").focus()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  e.which = 27 # ESC
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "new view.action finishes old one", (assert)->
  beforeEach()
  fixture.find("input").focus()
  fixture.find("input").focus()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 10

QUnit.test "window resize call resize method", (assert)->
  beforeEach()
  oo = fixture.find(".oo-score").oo()
  oo.resize =-> oo.setScore(100)
  $(window).resize()
  assert.equal $(".oo-score").oo("score"), 100

QUnit.test "window resize ignore oo views not have resize method", (assert)->
  beforeEach()
  assert.ok($(window).resize())
