# Set your repository's local folder here
base_dir = '/Your/Path'

# How many commits would you like to see?
items_to_show = 5

# How often would you like to update the display?
refreshFrequency: '2m'
# You can specify refreshFrequency in milliseconds, or as a string, like '2 days', '1d', '10h', '2.5 hrs', '2h', '1m', or '5s'

# Project Variables
project =
  branch    : 'master' # The git branch of the project to show the log from, e.g. 'master'
  title     : 'Project Name'  # Project's title to display at the top of the widget, e.g. 'Project Name'
  id        : 'element'  # CSS id to use to wrap the widget element, e.g. 'project-name'
  width     : '300px' # Width of widget, in pixels, e.g. '300px'
  # Initial screen position variables
  position  : 'top'   # Position the widget from top or bottom edge of screen, e.g. 'top' or 'bottom'
  align     : 'right' # Position the widget from left or right edge of screen, e.g. 'left' or 'right'
  initial_x : '10px'  # Pixels horizontal away from the screen 'align' variable, e.g. '10px'
  initial_y : '10px'  # Pixels vertical away from the screen 'position' variable, e.g. '10px'

# ===================================================================================
#           Don't touch below this line unless you know what's going on
# ===================================================================================
command: "cd #{base_dir} && git log origin/#{project.branch} -n #{items_to_show} --all --pretty=format:\"%D -- %h -- %cn -- %s -- %cr\""

project: project # enable variables

render: (output) ->
  if(!output)
    return
  """
  <div id="#{@project.id}">
    <div class="header">
      <span class="project-title">#{@project.title}</span>
      <div class="controls"></div>
    </div>
    <div class="git-log">#{output}</div>
  </div>
  """

renderItem: (data) ->
  fields = data.split(' -- ')
  if(fields[0].length > 40)
    branch = fields[0].substring(0,40) + '...' # limit string length to container
  else
    branch = fields[0]
  hash = fields[1]
  name = fields[2]
  subject = fields[3]
  date = fields[4]

  """
  <div class="row">
    <div class="subject">#{subject}</div>
    <div class="line2">
      <span class="date">#{date}</span>
      <span class="branch">#{branch}</span>
    </div>
    <div class="line3">
      <span class="name">by #{name}</span>
      <span class="hash">#{hash}</span>
    </div>
  </div>
  """

update: (output, widget) ->
  # this is a bit of a hack until jQuery UI is included natively
  $.getScript("https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js", () ->
    $(widget).draggable()
    return
  )
  lines = output.trim().split('\n')
  ele = $(widget).find('.git-log')
  ele.empty()

  for line in lines
    ele.append @renderItem(line)

  $(ele).find('.date').each ->
    dateArray = $(this).text().split(' ')
    number = dateArray[0]

    # less than 1 hour
    if(
      ($(this).text().search('seconds') > 0) ||
      ($(this).text().search('minutes') > 0 && number < 61)
      )
        $(this).closest('.row').addClass('recent')

    # less than 2 hours
    else if($(this).text().search('minutes') > 0)
        $(this).closest('.row').addClass('recent older')

    # less than 3 hours
    else if($(this).text().search('hours') > 0 && number < 3)
        $(this).closest('.row').addClass('recent oldest')

style: """
  font-family: Helvetica Neue
  font-size: 12px
  font-weight: 300
  line-height: 18px
  color: white
  background-color: rgba(0,0,0,0.6)
  #{project.align}: #{project.initial_x}  /* right */
  #{project.position}: #{project.initial_y} /* top */
  padding: 10px
  width: #{project.width}
  border-radius:4px

  .header
    padding-bottom: 5px
    border-bottom: 1px solid #ddd
    margin-bottom: 5px

  .controls
    float: right

  .project-title
    font-size: 16px
    font-weight: 500
    text-transform: uppercase

  .row
    margin-bottom: 5px
    display: block
    padding: 2px 4px

  .name
  .branch
  .date
  .hash
    color: #ccc
    font-size: 10px
    margin-left: 15px

  .row:not(:last-child)
    padding-bottom: 5px
    border-bottom: 1px solid #ddd

  .row:last-child
    margin-bottom: 0

  .row.recent
    background-color: rgba(63, 191, 137, 0.75)
    border: 1px solid rgba(61, 174, 125, 0.75)
    border-bottom: none
    border-radius: 2px
    margin-top: 10px

  .row.recent.older
    background-color: rgba(63, 191, 137, 0.50)
    border: 1px solid rgba(61, 174, 125, 0.50)

  .row.recent.oldest
    background-color: rgba(63, 191, 137, 0.25)
    border: 1px solid rgba(61, 174, 125, 0.25)

  .row.recent:not(:last-child)
    margin-bottom: 5px

  .row.recent .name
  .row.recent .branch
  .row.recent .date
  .row.recent .hash
    color: white

  .subject
    font-weight: 400
    margin-left: 0

  .branch
  .hash
    float: right

"""