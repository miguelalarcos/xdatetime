@_testing_xdatetime = {}
current_input = null
show_calendar = new ReactiveVar(false)
@_testing_xdatetime.show_calendar = show_calendar
data = new Meteor.Collection null
@_testing_xdatetime.data = data

path = (formid, name)-> formid + ':' + name

isLocalRepeated = (m) ->
  dateLocal = m
  dateLocalMinus1h = m.clone().add(-1, 'hours')
  if dateLocal.format('HH') == dateLocalMinus1h.format('HH')
    true
  else
    false


Template.xdatetime.events
  'focusout .xdatetime-input': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    txtdate = $(t.find('.xdatetime-input')).val()
    date = moment(txtdate, atts.format, true) #.utc()
    if not date.isValid()
      if atts.time
        date = moment()
      else
        date = moment().startOf('day')
      $(t.find('.xdatetime-input')).val(date.format(atts.format))
    if date.isSame(data.findOne(path: path_).value.startOf('day'))
      $(t.find('.xdatetime-input')).val(date.format(atts.format))

    data.update({path: path_}, {$set: {value: date}})

  'click .show-calendar': (e, t)->
    atts = t.data.atts or t.data
    current_input = path(atts.formid, atts.name)
    show_calendar.set(not show_calendar.get())

  'click .xdatetime-day': (e, t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    if atts.time == true
      #value = data.findOne(path: path_).value.clone().local().format('HH:mm')
      value = data.findOne(path: path_).value.format('HH:mm')
      date = this.date + ' ' + value
    else
      date = this.date
    m_ = moment(date, 'YYYY-MM-DD HH:mm')
    data.update({path: path_}, {$set: {value: m_}})
    unless atts.time == true
      show_calendar.set(false)

  'click .minus-month': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.subtract(1, 'months')
    data.update({path: path_}, {$set: {value: date}})

  'click .plus-month': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.add(1, 'months')
    data.update({path: path_}, {$set: {value: date}})

  'click .minus-year': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.subtract(1, 'years')
    data.update({path: path_}, {$set: {value: date}})

  'click .plus-year': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.add(1, 'years')
    data.update({path: path_}, {$set: {value: date}})

  'click .minus-hour': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.subtract(1, 'hours')
    data.update({path: path_}, {$set: {value: date}})

  'click .plus-hour': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.add(1, 'hours')
    data.update({path: path_}, {$set: {value: date}})

  'click .minus-minute': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.subtract(1, 'minutes')
    data.update({path: path_}, {$set: {value: date}})

  'click .plus-minute': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value.clone()
    date.add(1, 'minutes')
    data.update({path: path_}, {$set: {value: date}})


dayRow = (week, date)->
  ret = []
  day = date.clone()
  ini_month = day.clone().startOf('Month')
  ini = day.clone().startOf('Month').add(1-ini_month.isoWeekday(), 'days')

  ini = ini.add(week, 'weeks')

  dt = ini_month.clone().add(1, 'month')
  if ini.isAfter(dt) or ini.isSame(dt)
    return []
  end = ini.clone().add(7, 'days')

  while not ini.isSame(end)
    if ini_month.format('MM') == ini.format('MM')
      if ini.isSame(moment().startOf('day'))
        decoration = 'xbold xunderline xtoday'
      else
        decoration = 'xbold'
    else
      decoration = 'xcursive'

    ret.push {value: ini.format('DD'), date: ini.format('YYYY-MM-DD'), decoration: decoration}
    ini.add(1, 'days')
  ret

@_testing_xdatetime.dayRow = dayRow

Template.xdatetime.helpers

  init: (obj)->
    atts = this.atts or this
    path_ = path(atts.formid, atts.name)
    data.remove(path: path_)
    value = this.value or obj[atts.name]
    if value is undefined or value is null
      if atts.time == true
        value = moment().startOf('minute')
      else
        value = moment().startOf('day')
    else
      if atts.time == true
        value = moment(value).startOf('minute')
      else
        value = moment(value).startOf('day')
    data.insert({path:path_, value:value})
    null

  value: ->
    atts = this.atts or this
    item = data.findOne(path: path(atts.formid, atts.name))
    if item
      item.value.format(atts.format)
    else
      null

  show_calendar: ->
    atts = this.atts or this
    show_calendar.get() and current_input == path(atts.formid, atts.name)

  show_time: ->
    atts = this.atts or this
    atts.time == true

  time: ->
    atts = this.atts or this
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value
    date.format('HH:mm')

  year: ->
    atts = this.atts or this
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value
    date.format('YYYY')

  month: ->
    atts = this.atts or this
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value
    date.format('MM')

  week: -> (i for i in [0...6])

  day: (week, atts) ->
    atts = atts.atts or atts
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value
    dayRow(week, date.clone())

  checkDST: ->
    atts = this.atts or this
    path_ = path(atts.formid, atts.name)
    date = data.findOne(path: path_).value
    if isLocalRepeated date.clone() then 'red' else ''


$.valHooks['xdatetime'] =
  get: (el)->
    formid = $(el).attr('formid')
    name = $(el).attr('name')
    path_ = path(formid, name)
    data.findOne(path: path_).value.toDate()

  set: (el, value)->
    formid = $(el).attr('formid')
    name = $(el).attr('name')
    path_ = path(formid, name)
    data.remove({path: path_})
    value = moment(value).startOf('minute')
    data.insert({path: path_, value:value})

$.fn.xdatetime = (name)->
  this.each ->
    this.type = 'xdatetime'
  this

Template.xdatetime.rendered = ->
  $(this.find('.xwidget')).xdatetime()
