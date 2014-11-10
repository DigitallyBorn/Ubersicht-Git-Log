# Set your repository's local folder here
base_dir = '/Your/Path'

# How many commits would you like to see?
items_to_show = 5

# How often would you like to update the display?
refreshFrequency: 10000

# Don't touch this unless you know what's going on
command: "cd #{base_dir} && git log -n #{items_to_show} --all --format=\"%d - %h - %an - %s - %ar\""

render: (output) -> """
  <div id=\"git-log\">#{output}</div>
"""

update: (output, widget) ->
  lines = output.trim().split('\n')
  ele = $(widget).find("#git-log")
  ele.empty()
  for line in lines
    ele.append @renderItem(line)

renderItem: (data) -> 
  fields = data.split(" - ")
  branch = fields[0]
  hash = fields[1]
  name = fields[2]
  subject = fields[3]
  date = fields[4]

  """
  <div class=\"row\">
    <div class=\"name\">#{name}</div>
    <div class=\"subject\">#{subject}</div>
    <div class=\"line3\">
      <span class=\"date\">#{date}</span>
      <span class=\"hash\">[#{hash}]</span>
      <span class=\"branch\">#{branch}</span>
    </div>
  </div>
  """

style: """
  font-family: Gill Sans
  font-size: 1.4em
  color: white
  bottom: .5em
  left: .5em
  text-shadow:
   1px 1px 0 #000,
   -1px 1px 0 #000;

  row
    margin-bottom: .6em
    display: block

  .hash
  .branch
  .date
    color: #CCC
    font-size: 0.7em
    margin-top: .4em

  .name
    font-size: 1.3em
    width: 8em

  .subject
    font-size: 1em
    text-wrap: none
    margin-left: 1em

  .subject
  .line3
    margin-left: 1em

"""