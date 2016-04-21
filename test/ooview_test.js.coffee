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

# get object
QUnit.test "get object", (assert)->
  beforeEach()
  assert.ok $(".oo-score").oo() instanceof Score

QUnit.test "can't get object not exist", (assert)->
  beforeEach()
  assert.throws(-> $(".oo-other").oo())

# send message
QUnit.test "send message to object", (assert)->
  beforeEach()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "send message with args to objects", (assert)->
  beforeEach()
  fixture.ooAppend(htmlScore)
  $(".oo-score").oo("setScore", 5)
  $(".oo-score").each -> assert.equal $(this).oo("score"), 5

QUnit.test "can't send message to object don't know", (assert)->
  beforeEach()
  assert.throws(-> $(".oo-score").oo("notDefined"))

# initial data
QUnit.test "#data reads data from 'oo' attributes", (assert)->
  $.oo.update()
  fixture.append(htmlScore)
  $(".oo-score").attr("oo", JSON.stringify(name: "bob"))
  $.oo.bind "score", Score
  assert.equal $(".oo-score").oo().view.data.name, "bob"

# find()
QUnit.test "#find does not search child oo views", (assert)->
  beforeEach()
  $(".oo-score").ooAppend("<div class='oo-other'><input></div>")
  assert.equal $(".oo-score").oo().view.find("input").length, 1

# dynamic content
QUnit.test "#update assigns object to inserted html", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.append(htmlScore)
  $.oo.update()
  assert.equal $(".oo-score:last").oo("score"), 9

QUnit.test "#update handle deleted html", (assert)->
  beforeEach()
  $(".oo-score").remove()
  $.oo.update()
  assert.equal $.oo.instanceCount(), 0

QUnit.test "#ooAppend to append and #update", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.ooAppend(htmlScore)
  assert.equal $(".oo-score:last").oo("score"), 9

QUnit.test "#ooPrepend to prepend and #update", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.ooPrepend(htmlScore)
  assert.equal $(".oo-score:first").oo("score"), 9

# html builder
QUnit.test "#view generates default html with data", (assert)->
  html = $.oo.view("score", score: 1, name: "score1")
  assert.equal html, '<div class="oo-score" oo={"score":1,"name":"score1"}></div>'

QUnit.test "#view generates default html with data and content", (assert)->
  html = $.oo.view("score", score: 1, name: "score1", "<div>content</div>")
  assert.equal html,
    '<div class="oo-score" oo={"score":1,"name":"score1"}><div>content</div></div>'

# events()
QUnit.test "set events", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  assert.equal $(".oo-score").oo("score"), 0

QUnit.test "set events to self", (assert)->
  beforeEach()
  $(".oo-score").oo().view.events(@,
    "mouseenter": -> $(@).addClass("highlight")
    "mouseleave": -> $(@).removeClass("highlight")
  )
  $(".oo-score").mouseenter()
  assert.equal $(".oo-score").hasClass("highlight"), true
  $(".oo-score").mouseleave()
  assert.equal $(".oo-score").hasClass("highlight"), false


QUnit.test "ignore events propagated from child objects", (assert)->
  beforeEach()
  $(".oo-score").ooAppend("<div class='oo-other'><div class='reset'></div></div>")
  $(".oo-score .oo-other .reset").click()
  assert.equal $(".oo-score").oo("score"), 9

# action()
QUnit.test "action can listen document events", (assert)->
  beforeEach()
  fixture.find("input").focus()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 10
  e.which = 40 # down
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "action ends on clicking anywhere", (assert)->
  beforeEach()
  fixture.find("input").focus()
  $(".oo-score").click()
  e = $.Event("keypress")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "action ends when action method returns string, finish'", (assert)->
  beforeEach()
  fixture.find("input").focus()
  up = $.Event("keypress")
  up.which = 38 # up
  enter = $.Event("keypress")
  enter.which = 13 # enter
  fixture.find("input").trigger(up)
  fixture.find("input").trigger(enter)
  assert.equal $(".oo-score").oo("score"), 10
  fixture.find("input").trigger(up)
  assert.equal $(".oo-score").oo("score"), 10

QUnit.test "action ends on esc", (assert)->
  beforeEach()
  fixture.find("input").focus()
  e = $.Event("keyup")
  e.which = 38 # up
  fixture.find("input").trigger(e)
  e.which = 27 # esc
  fixture.find("input").trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "object can have only one active action", (assert)->
  beforeEach()
  fixture.find("input").focus()
  fixture.find("input").focus() # finish prev action
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
