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

# get OOView object
QUnit.test "$(...).oo: Get OOView object", (assert)->
  beforeEach()
  assert.ok $(".oo-score").oo() instanceof Score

QUnit.test "$(...).oo: Can't get OOView object not exist", (assert)->
  beforeEach()
  assert.throws(-> $(".oo-other").oo())

# call OOView function
QUnit.test "$(...).oo: Call OOView function to jQuery element", (assert)->
  beforeEach()
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "$(...).oo: Call OOView function to jQuery element with an argument", (assert)->
  beforeEach()
  fixture.ooAppend(htmlScore)
  $(".oo-score").oo("setScore", 5)
  $(".oo-score").each -> assert.equal $(this).oo("score"), 5

QUnit.test "$(...).oo: Can't call OOView function not exists", (assert)->
  beforeEach()
  assert.throws(-> $(".oo-score").oo("notDefined"))

# initial data
QUnit.test "@view.data: Read data from 'oo' attributes", (assert)->
  $.oo.update()
  fixture.append(htmlScore)
  $(".oo-score").attr("oo", JSON.stringify(name: "bob"))
  $.oo.bind "score", Score
  assert.equal $(".oo-score").oo().view.data.name, "bob"

# find()
QUnit.test "@view.find: Do not search the child OOView elements", (assert)->
  beforeEach()
  $(".oo-score").ooAppend("<div class='oo-other'><input></div>")
  assert.equal $(".oo-score").oo().view.find("input").length, 1

# dynamic content
QUnit.test "$.oo.update: Assign OOView objects to the inserted html", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.append(htmlScore)
  $.oo.update()
  assert.equal $(".oo-score:last").oo("score"), 9

QUnit.test "$.oo.update: Handle a deleted OOView element", (assert)->
  beforeEach()
  $(".oo-score").remove()
  $.oo.update()
  assert.equal $.oo.instanceCount(), 0

QUnit.test "$(...).ooAppend: Append and update", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.ooAppend(htmlScore)
  assert.equal $(".oo-score:last").oo("score"), 9

QUnit.test "$(...).ooPrepend: Prepend and update", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  fixture.ooPrepend(htmlScore)
  assert.equal $(".oo-score:first").oo("score"), 9

# html builder
QUnit.test "$.oo.view: Generate OOView element with data", (assert)->
  html = $.oo.view("score", score: 1, name: "score1")
  assert.equal html, '<div class="oo-score" oo={"score":1,"name":"score1"}></div>'

QUnit.test "$.oo.view: Generate OOView element with content", (assert)->
  html = $.oo.view("score", score: 1, name: "score1", "<div>content</div>")
  assert.equal html,
    '<div class="oo-score" oo={"score":1,"name":"score1"}><div>content</div></div>'

# events()
QUnit.test "@view.events: Call function by name", (assert)->
  beforeEach()
  $(".oo-score .reset").click()
  assert.equal $(".oo-score").oo("score"), 0

QUnit.test "@view.events: Call closure", (assert)->
  beforeEach()
  $(".oo-score").oo().view.events(@,
    "mouseenter": -> $(@).addClass("highlight")
    "mouseleave": -> $(@).removeClass("highlight")
  )
  $(".oo-score").mouseenter()
  assert.equal $(".oo-score").hasClass("highlight"), true
  $(".oo-score").mouseleave()
  assert.equal $(".oo-score").hasClass("highlight"), false


QUnit.test "@view.events: Do not call function triggered from a child OOView element", (assert)->
  beforeEach()
  $(".oo-score").ooAppend("<div class='oo-other'><div class='reset'></div></div>")
  $(".oo-score .oo-other .reset").click()
  assert.equal $(".oo-score").oo("score"), 9

# action()
QUnit.test "@view.action: Can listen document events", (assert)->
  beforeEach()
  fixture.find("input").focus()
  e = $.Event("keypress")
  e.which = 38 # up
  $(document).trigger(e)
  assert.equal $(".oo-score").oo("score"), 10
  e.which = 40 # down
  $(document).trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "@view.action: Finish on click anywhere", (assert)->
  beforeEach()
  fixture.find("input").focus()
  $(".oo-score").click()
  e = $.Event("keypress")
  e.which = 38 # up
  $(document).trigger(e)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "@view.action: Finish if binded function returns \"finish\"", (assert)->
  beforeEach()
  fixture.find("input").focus()
  up = $.Event("keypress")
  up.which = 38 # up
  enter = $.Event("keypress")
  enter.which = 13 # enter
  $(document).trigger(up)
  $(document).trigger(enter)
  assert.equal $(".oo-score").oo("score"), 10
  $(document).trigger(up)
  assert.equal $(".oo-score").oo("score"), 10

QUnit.test "@view.action: Call function binded to \"finish\" on finish", (assert)->
  beforeEach()
  fixture.find("input").focus()
  assert.equal $("input").is(":focus"), true
  enter = $.Event("keypress")
  enter.which = 13 # enter
  $(document).trigger(enter)
  assert.equal $("input").is(":focus"), false

QUnit.test "@view.action: Finish on ESC keyup", (assert)->
  beforeEach()
  fixture.find("input").focus()
  esc = $.Event("keyup")
  esc.which = 27 # esc
  $(document).trigger(esc)
  up = $.Event("keypress")
  up.which = 38 # up
  $(document).trigger(up)
  assert.equal $(".oo-score").oo("score"), 9

QUnit.test "@view.action: Allow one action at a time", (assert)->
  beforeEach()
  fixture.find("input").focus()
  fixture.find("input").focus() # finish prev action
  e = $.Event("keypress")
  e.which = 38 # up
  $(document).trigger(e)
  assert.equal $(".oo-score").oo("score"), 10

QUnit.test "#resize: Call on window resize", (assert)->
  beforeEach()
  oo = fixture.find(".oo-score").oo()
  oo.resize =-> oo.setScore(100)
  $(window).resize()
  assert.equal $(".oo-score").oo("score"), 100

QUnit.test "#resize: Do not call if not defined", (assert)->
  beforeEach()
  assert.ok($(window).resize())
