---
---
window.codeArray = []
sections = []
body = []

csShow = """
$ "#bokeh"
  .bokeh "figure",
    options: options
    sources: { mydata: data }
    glyphs: [scatter]
    guides: [xaxis, yaxis]
    tools: ["Pan", "WheelZoom", "Resize", "Reset", "BoxZoom"]
"""

window.editor = CodeMirror.fromTextArea d3.select('#code-markdown').node(),
  mode: "coffeescript"
  lineNumbers: true
  lineWrapping: true
  viewportMargin: Infinity
  theme: "night"
  extraKeys:
    "Ctrl-Q": (cm)->
      cm.foldCode cm.getCursor()
    "F11": (cm)->
      cm.setOption "fullScreen", !cm.getOption "fullScreen"
    "Esc": (cm)->
        if cm.getOption "fullScreen"
          cm.setOption "fullScreen", false
     "Ctrl-Enter": (cm)->
       $('#bokeh').html ''
       CoffeeScript.eval  """
       #{editor.getValue('\n\n')}
       #{csShow}
       """
     "Tab": (cm)->
        spaces = Array(cm.getOption("indentUnit") + 1).join(" ")
        cm.replaceSelection(spaces)
  foldGutter: true
  gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
editor.on 'gutterClick',  (e)->
  ### Map Header number to array ###
  textArray = editor.getValue().split '\n'
  currentBuffer =
    header: 0
  sectionObj =
    start: 0
    end: null
    children: []
  sections  = []

window.md = new markdownit
  html: true
  highlight: (str, lang)->
    if lang and hljs.getLanguage(lang)
      hljs.highlight(lang, str).value;
    else
      hljs.highlightAuto(str).value;
