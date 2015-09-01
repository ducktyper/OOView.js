## OOView.js (Object-Oriented View in Javascript)
OOView.js a jQuery plugin helps to automatically create javascript objects
and bind to specified dom elements on initial and dynamic load.

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
class @Score
  constructor: (@view)->
    @view.events(@,
      "click .reset": 'reset'
      "click .plus":  'plusScore'
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
events method sets click events to reset and add score by one.

#### @view.action
You can set temp events under associated element using "action" method
```coffeescript
class @Score
  constructor: (@view)->
    @view.events(@, "focus input": 'keyboardEdit')

  keyboardEdit: ->
    @view.action(@,
      "keypress": 'upDown'
    )

  upDownKey: (e)->
    @setScore(@score() + 1) if e.which == 38 #up
    @setScore(@score() - 1) if e.which == 40 #down

  setScore: (score)->
    @view.find("input").val(score)
  score: ->
    parseInt(@view.find("input").val())
```
Using this code, a user can use up and down key to change score
after input field is focused.
* if no selector is given then it assign to "document" (e.g. "keypress")
* activated action events can be removed by 3 ways
  * call another action method
  * press ESC key
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


