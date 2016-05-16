## OOView.js (Object-Oriented View in Javascript)
OOView.js a lightweight (less than 200 lines) jQuery plugin helps
to write component based Javascript code. It provides a way to
find elements and assign events within the partial view and also
provides a way to communicate with other components.

### 1 Minute Tutorial
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

#### 3: Create OOView class and bind to specific elements

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
After dom is loaded, OOView looks through `.oo-score` elements and binds the new Score object to each of them.
At first, each Score object reads the score data from the `oo` attribute and sets it's value to the input field.
And it attaches the click event to the `.reset` element which resets the score to 0.

#### 4: Interact with OOView objects through jQuery elements

Examples
```coffeescript
score = $(".oo-view").oo("getScore")
$(".oo-view").oo("setScore", 5)
obj = $(".oo-view").oo()
obj.setScore(5)
# click .reset button to set score to 0
```

You can call the OOView function or get the OOView object from a jQuery element.
```coffeescript
$(".oo-[OOVIEW_NAME]").oo(FUNCTION_NAME, ARGUMENT1, ARGUMENT2, ...)
```
* Find OOView elements and execute the function to each of them with argnuments.

```coffeescript
$(".oo-[OOVIEW_NAME]").oo()
```
* Get the OOView obejct from the first OOView element found.


### Full guide
#### Bind OOView objects to the view

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
The function `$.oo.bind` looks dom elements having the class `oo-score`
(the value of the OOView class starts with `oo-`) and attaches the new Score object
to each element found.

#### OOView View functions
##### @view.find
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
The function `@view.find` looks for elements under the dom associated with it by calling
`find` function in jQuery. Only difference is that it does not search any child OOView
elements it contains.
From the code example, the code `$(".score1").oo("inputField")` returns the input `score1-input` not `score2-input`.

##### @view.element
The code `@view.element` returns the root jQuery element where the OOView object is attached to such as `.oo-score`.
Use this when you need an access to the root element.

##### @view.data
Data assigned to the `oo` attribute which can be accessed by calling `@view.data.[DATE_NAME]`

HTML
```html
<div class='oo-score' oo='{"score":10}'></div>
```
COFFEESCRIPT
```coffeescript
class Score
  constructor: (@view)->
    @view.find("input").val(@view.data.score)
```

##### @view.events
You can set permanent events under the associated element using the function called `events`.
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
The codes above generate the events below
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

##### @view.action
The function `action` allows to define a temporary event. Different from the `event`
method, you can assign events to the document or any element in the document.
To avoid these events to stay in the memory forever, you need
to make sure you define when to finish the action. You can finish the action by
returning the string "finish" from the assigned function.

A good example of using the `action` feature is to allow editing a number field
using up and down buttons.

```coffeescript
class @Score
  constructor: (@view)->
    @view.events(@, "focus input": 'startEdit')

  startEdit: ->
    @view.action(@,
      "keypress": 'keypress'
      "finish":   'blurInput'
      "click":    -> "finish"
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
You can define the `resize` function to handle the resize
event.

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


