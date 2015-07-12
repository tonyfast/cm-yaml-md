---
---

d3.json 'http://api.github.com/users/tonyfast/gists', (d)->
  d3.select document
    .datum {'gist':d}

color= 'indigo'
topics =
  'gist':
    '': (node,d,i)->
      d3.select node
        .text d
    'apply': (s)->
      s.push 'ul'
        .selectAll 'li'
        .data document.__data__.gist.filter (d)-> d['description']
        .call (s)->
          s.enter()
            .push 'li'
            .each (d,i)->
              d3.select @
                .text d['description']
        .call (s)->
          s.exit()
            .remove()
  'github':
    '': (node,d,i)->
      d3.select node
        .text d
    'apply': (s)->
      s.text 'hotta'
  'nbviewer':
    '': (node,d,i)->
      d3.select node
        .text d
    'apply': (s)->
      s.text 'damn'

topics['slideshare'] =
  '': (node,d,i)->
    d3.select node
      .text d
  'apply': (s)->
    iframe = """
    <iframe src="http://www.slideshare.net/tonyfast1/slideshelf" width="#{s.style('width')}" height="470px" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:none;" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
    """
    s.html iframe


container = d3.select 'body'
  .insert 'div'
  .classed 'container', true

display = container.push 'div'
  .attr 'id', 'display'
  .text 'PartyTime'

## Create a table for the interaction ##
container.insert 'table', '#display'
  .classed 'centered', true
  .push 'tbody'
  .push 'tr'
  .selectAll 'td'
  .data d3.keys topics
  .call (s)->
    s.enter()
      .push 'td'
  .each (d,i) ->
    topics[d][''] @,d,i
    d3.select @
      .attr 'class', "#{color} darken-#{i}"
  .on 'mouseover', (d)->
    topics[d]['apply'] display
