## OOView.js (Object-Oriented View in Javascript)
OOView.js a light (less than 200 lines) jQuery plugin helps
to automatically create Javascript objects
and bind to specified dom elements on initial and dynamic load.
The code is written in Coffeescript but you can transpile it to Javascript
and use it with Javascript, ES6 with Babel or any way you like.

### 1 Min Tutorial
#### 1: Copy ooview.js.coffee to your project.
(if you need a Javascript file, one quick way to transpile is using
'TRY COFFEESCRIPT' from coffeescript.org)

#### 2: Create OOView HTML component (e.g. "score" component)
```html
<div class='oo-score' oo='{"score":10}'>
// Content goes here
</div>
```
The same Html can be generated using javascipt.
```coffeescript
html = $.oo.view("score", {score: 10}, "// Content goes here")
```

#### 3: Create OOView class and bind to the specific elements

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
After dom is loaded, OOView looks through `.oo-score` elements and binds a Score object to each of them.
At first, each Score object reads the score data from `oo` attribute and sets it's value to the input field.
And it attaches the click event to `.reset` element which resets the score to 0.

#### 4: Interact with OOView objects through jQuery elements

Examples
```coffeescript
score = $(".oo-view").oo("getScore")
$(".oo-view").oo("setScore", 5)
obj = $(".oo-view").oo()
obj.setScore(5)
# click .reset button to set score to 0
```

You can call a OOView function of get the OOView object from jQuery element.
```coffeescript
$(".oo-[OOView name]").oo("[function name]", [first argument], [second argument], ...)
```
* Find OOView elements and execute a function to each of them with argnuments.

```coffeescript
$(".oo-[OOView name]").oo()
```
* Get an OOView obejct from the first OOView element.


### Full guide
#### Bind OOView class to the specfic elements

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
`$.oo.bind` function looks dom elements having a class `oo-score`
(by convention class name starts with `oo-`) and attaches a new Score object
to each element found.
Each Score class is initialized with OOView View object

#### OOView View functions
* find
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
  <input type="text" class="score1-input">
  <div class="oo-score score2">
    <input type="text" class="score2-input">
  </div>
</div>
```
`@view.find` looks for elements under the dom associated with it by calling
find function in jQuery. Only difference is that it does not search any child OOView
elements (class starts with "oo-") it contains.
From the code example, the code `$(".score1").oo("inputField")` returns `.score1-input` not `score2-input`

* events
You can set permanent events under associated element using `events` function.
The syntax was influenced by backbone.js
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

* action
`action` function allows to attach an event to a document or element outside of
the OOView element. To avoid these events to stay in the memory forever, the
events will be removed by several actions including keyup ESC. You can also bind a function
on finish to clear the action.

A good example of using `action` function is to allow up and down buttons to a number
field on focus and blur on finish.

```coffeescript
class @Score
  constructor: (@view)->
    @view.events(@, "focus input": 'startEdit')

  startEdit: ->
    @view.action(@,
      "keypress": 'keypress'
      "finish":   'blurInput'
    )

  keypress: (e)->
    switch e.which
      when 38 then @setScore(@score() + 1) # up
      when 40 then @setScore(@score() - 1) # down
      when 13 then "finish" # enter

  blurInput: ->
    @oo.view.find("input").blur()

  setScore: (score)->
    @view.find("input").val(score)
  score: ->
    parseInt(@view.find("input").val())
```

There are 4 ways to finish `action`.
  * Call another `action` function
  * Keyup ESC
  * Click anywhere
  * Return "finish" from the function binded in a `action` function

#### Get OOView object from jQuery element
```coffeescript
$(".oo-score").oo() # return javascript object associated with given OOView element
$(".oo-score").oo("score") # get javascript object and call "score" function
$(".oo-score").oo("set", 10) # get javascript object and call "set" function with one argument
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

#### resize function
Since window resize event is attached to window not the view,
the event will survive after view is removed from the dom.
Instead OOView listens to window resize event and sends resize function to
each oo objects if resize function is defined.
```coffeescript
class @Score
  constructor: (@view)->
  resize: ->
    console.debug "called on window resize"
```

#### Run tests
Qunit is used to test OOView.js
* Run tests on Firefox
  1. Open Firefox
  2. Visit about:config
  3. Set security.fileuri.strict_origin_policy to false
  4. Open ooview_test.html
* Run tests on Mac terminal
  1. brew install phantomjs
  2. phantomjs test/lib/runner.js test/ooview_test.html


