## OOView.js (Object-Oriented View in Javascript)
OOView.js a light (less than 200 lines) jQuery plugin helps
to automatically create Javascript objects
and bind to specified dom elements on initial and dynamic load.
The code is written in Coffeescript but you can transpile it to Javascript
and use it with Javascript, ES6 with Babel or any way you like.

### How to use
#### 1: Copy ooview.js.coffee to your project.
(if you need Javascript file, one quick way to transpile is using
'TRY COFFEESCRIPT' from coffeescript.org)

#### 2: Create OOView HTML component (e.g. "score" component)
```html
<div class='oo-score' oo='{"score":10}'>
// Content goes here
</div>
```
Same Html can be generated from Javasript by calling
```coffeescript
html = $.oo.view("score", {score: 10}, "// Content goes here")
```

#### 3: Create OOView class and bind it
```coffeescript
class Score
  constructor: (@view)->
    @view.find("input").val(@view.data.score) # set initial score to 10
    @view.events(@,
      "click .reset": "reset"
    )
  reset:           -> setScore(0)
  getScore:        -> @view.find("input").val()
  setScore: (score)-> @view.find("input").val(score)

$.oo.bind "score", Score
```

#### 4: Use OOView
```coffeescript
score = $(".oo-view").oo("getScore")
$(".oo-view").oo("setScore", 5)
obj = $(".oo-view").oo()
obj.setScore(5)
# click .reset button to set score to 0
```

### Basic binding
COFFEESCRIPT
```coffeescript
class Score
  constructor: (@view)->

$.oo.bind "score", Score
```
HTML
```html
<div class="oo-score"></div>
```
$.oo.bind method looks dom elements having a class "oo-score"
(by convention class name starts with "oo-") and attaches new Score object
to each element found.
Each Score class is initialized with OOView object (@view in example code)

### OOView
#### @view.find
COFFEESCRIPT
```coffeescript
class Score
  constructor: (@view)->

  inputField: ->
    @view.find("input")
```
HTML
```html
<div class="oo-score score1">
  <input type="text" name="score1">
  <div class="oo-score score2">
    <input type="text" name="score2">
  </div>
</div>
```
@view.find looks for elements under the dom associated with it by calling
find method in jQuery. Only difference is that it does not search any OOView
elements (class starts with "oo-") it contains.
From the code example, call @view.find("input") from Score object attached to
"score1" class returns $('input[name="score1"]') and not $('input[name="score2"]')

#### Get OOView object from jQuery element
```coffeescript
$(".oo-score").oo() # return javascript object associated with given OOView element
$(".oo-score").oo("score") # get javascript object and call "score" method
$(".oo-score").oo("set", 10) # get javascript object and call "set" method with one argument
```

#### Attach new OOView objects to dynamically inserted HTML
```coffeescript
# full version
$("body").append('<div class="oo-score"></div>')
$.oo.update()
# shortcut (include calling $.oo.update())
$("body").ooAppend('<div class="oo-score"></div>')
$("body").ooPrepend('<div class="oo-score"></div>')
```

#### @view.events
You can set permanent events under associated element using "events" method.
Syntax was influenced by backbone.js
```coffeescript
class Score
  constructor: (@view)->
    @view.events(@,
      "click .reset": 'reset'
      "click .plus":  'plusScore'
      "mouseenter":   -> $(@).addClass("highlight")
      "mouseleave":   -> $(@).removeClass("highlight")
    )

  reset: ->
    @setScore(0)
  plusScore: ->
    @setScore(@score() + 1)

  setScore: (score)->
    @view.find("input").val(score)
  score: ->
    parseInt(@view.find("input").val())
```
Codes above generate events below
```coffeescript
element = # $(".oo-score") element
score   = # 'Score' object associated with the element

element.on("click",
  ".reset, :not([class^='oo-']) .reset",
  score["reset"].bind(score)
)
element.on("click",
  ".plus, :not([class^='oo-']) .plus",
  score["plusScore"].bind(score)
)
element.on("mouseenter", -> $(@).addClass("highlight"))
element.on("mouseleave", -> $(@).removeClass("highlight"))
```

#### resize method
Since window resize event is attached to window not the view,
the event will survive after view is removed from the dom.
Instead OOView listens to window resize event and sends resize method to
each oo objects if resize method is defined.
```coffeescript
class @Score
  constructor: (@view)->
  resize: ->
    console.debug "called on window resize"
```

#### @view.action
You can set one set of temp events to OOView object using "action" method
```coffeescript
class @Score
  constructor: (@view)->
    @view.events(@, "focus input": 'keyboardEdit')

  keyboardEdit: ->
    @view.action(@,
      "keypress": 'upDown'
      "click .reset-score-editing-now": 'reset'
    )

  upDownKey: (e)->
    @setScore(@score() + 1) if e.which == 38 #up
    @setScore(@score() - 1) if e.which == 40 #down

  reset: ->
    @setScore(0)
  setScore: (score)->
    @view.find("input").val(score)
  score: ->
    parseInt(@view.find("input").val())
```
Using this code, a user can use up and down key to change score
and click reset-score-editing-now button to reset score
after input field is focused.
* action scope is global (e.g. .reset-score-editing-now can be outside of the 'score' view)
* if no selector is given then it assigns to "document" (e.g. "keypress")
* activated action events can be removed by 3 ways
  * call another action method
  * keyup ESC
  * click anywhere

### Run tests
Qunit is used to test OOView.js
* Run tests on Firefox
  1. Open Firefox
  2. Visit about:config
  3. Set security.fileuri.strict_origin_policy to false
  4. Open ooview_test.html
* Run tests on Mac terminal
  1. brew install phantomjs
  2. phantomjs test/lib/runner.js test/ooview_test.html


