---
---
window.codeArray = []
sections = []
body = []

window.editor = CodeMirror.fromTextArea d3.select('#code-markdown').node(),
  mode: "markdown"
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


editor.on 'change', (cm)->
  d3.select '#yaml'
    .html ''

  ### Add double newline for some reason ###
  jsyaml.safeLoadAll editor.getValue('\n\n'), (doc)->
    d3.select '#yaml'
      .append 'div'
      .call ()->
        window.recent = doc
        if typeof doc in ['string']
          riot.tag  "markdown", md.render doc
        else
          riot.tag  "markdown", md.render doc['html']
      .call (s)-> riot.mount s.node(), 'markdown',  doc['opts'] ? {}
