@_testing_xdatetime = {}
current_input = null
show_calendar = new ReactiveVar(false)
@_testing_xdatetime.show_calendar = show_calendar
xday = new ReactiveVar(moment.utc().startOf('minute'))
@_testing_xdatetime.xday = xday
data = new Meteor.Collection null

path = (formid, name)-> formid + ':' + name

Template.xdatetime.events
  'click .show-calendar': (e, t)->
    atts = t.data.atts or t.data
    xday.set(moment.utc().startOf('minute'))
    current_input = path(atts.formid, atts.name)
    show_calendar.set(not show_calendar.get())
  'click .xdatetime-day': (e, t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    if atts.time == 'true'
      value = $(t.find('.xdatetime-time')).val()
      date = this.date + ' ' + value
    else
      date = this.date
    data.update({path: path_}, {$set: {value: moment(date, 'YYYY-MM-DD HH:mm').utc()}})
    show_calendar.set(false)
    xday.set(moment.utc().startOf('minute'))
  'click .set-year': (e,t) ->
    year = $(t.find('.xdatetime-year')).val()
    xday.set(xday.get().year(year))
  'click .set-time': (e,t)->
    atts = t.data.atts or t.data
    path_ = path(atts.formid, atts.name)
    time = $(t.find('.xdatetime-time')).val()
    date = moment($(t.find('.xdatetime-input')).val(), atts.format)
    date = date.format('YYYY-MM-DD')
    datetime = date + ' ' + time
    data.update({path: path_}, {$set: {value: moment(datetime, 'YYYY-MM-DD HH:mm').utc()}})
  'click .minus-month': (e,t)->
    xday.set(xday.get().subtract(1, 'months'))
  'click .plus-month': (e,t)->
    xday.set(xday.get().add(1, 'months'))
  'click .minus-year': (e,t)->
    xday.set(xday.get().subtract(1, 'years'))
  'click .plus-year': (e,t)->
    xday.set(xday.get().add(1, 'years'))

  'click .minus-hour': (e,t)->
    xday.set(xday.get().subtract(1, 'hours'))
  'click .plus-hour': (e,t)->
    xday.set(xday.get().add(1, 'hours'))

  'click .minus-minute': (e,t)->
    xday.set(xday.get().subtract(1, 'minutes'))
  'click .plus-minute': (e,t)->
    xday.set(xday.get().add(1, 'minutes'))

dayRow = (week)->
  ret = []
  day=xday.get().local()
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
        day_class = 'xbold xunderline xtoday'
      else
        day_class = 'xbold'
    else
      day_class = 'xcursive'

    ret.push {value: ini.format('DD'), date: ini.format('YYYY-MM-DD'), day_class: day_class}
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
      value = moment.utc().seconds(0).milliseconds(0)
    else
      value = moment(value).seconds(0).milliseconds(0)
    data.insert({path:path_, value:value})
    null
  value: ->
    atts = this.atts or this
    item = data.findOne(path: path(atts.formid, atts.name))
    if item
      item.value.local().format(atts.format)
    else
      null

  show_calendar: ->
    atts = this.atts or this
    show_calendar.get() and current_input == path(atts.formid, atts.name)

  show_time: ->
    atts = this.atts or this
    atts.time == 'true'
  time: -> xday.get().local().format('HH:mm')
  year: -> xday.get().local().format('YYYY')
  month: -> xday.get().local().format('MM')
  week: -> (i for i in [0...6])
  day: (week) -> dayRow(week)


$.valHooks['xdatetime'] =
  get: (el)->
    value = $(el).find('.xdatetime-input').val()
    if not value
      return null
    format = $(el).attr('format')
    moment.utc(moment(value, format)).toDate()

  set: (el, value)->
    formid = $(el).attr('formid')
    name = $(el).attr('name')
    path_ = path(formid, name)
    data.remove({path: path_})
    value = moment(value).startOf('minute') #seconds(0).milliseconds(0)
    data.insert({path: path_, value:value})

$.fn.xdatetime = (name)->
  this.each ->
    this.type = 'xdatetime'
  this

Template.xdatetime.rendered = ->
  $(this.find('.xwidget')).xdatetime()