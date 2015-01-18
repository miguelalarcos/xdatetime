current_input = null
show_calendar = new ReactiveVar(false)
xday = new ReactiveVar(moment.utc())
data = new Meteor.Collection null

path = (formid, name)-> formid + ':' + name

Template.xdatetime.events
  'click .show-calendar': (e, t)->
    current_input = path(this.formid, this.name)
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
    xday.set(moment.utc())
  'focusout .xdatetime-year': (e,t)->
    year = $(e.target).val()
    xday.set(xday.get().year(year))
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



Template.xdatetime.helpers
  init: (obj)->
    atts = this.atts or this
    path_ = path(atts.formid, atts.name)
    data.remove(path: path_)
    value = this.value or obj[atts.name]
    data.insert({path:path_, value:value})
    null
  value: ->
    atts = this.atts or this
    item = data.findOne(path: path(atts.formid, atts.name))
    if item then item.value.local().format(atts.format) else null

  show_calendar: -> show_calendar.get() and current_input == path(this.formid, this.name)
  show_time: ->
    atts = this.atts or this
    atts.time == 'true'
  time: -> xday.get().local().format('HH:mm')
  year: -> xday.get().format('YYYY')
  month: -> xday.get().format('MM')
  week: -> (i for i in [0...6])
  day: (week) ->
    ret = []
    day=xday.get()
    ini_month = day.clone().startOf('Month')
    ini = day.clone().startOf('Month').add('days', 1-ini_month.isoWeekday())
    end_month = day.clone().endOf('Month').startOf('Day')
    end = day.clone().endOf('Month').add('days', 8-end_month.isoWeekday()).startOf('Day')

    while not ini.isSame(end)
      if ini_month.format('MM') == ini.format('MM')
        day_class = 'xbold'
      else
        day_class = 'xcursive'

      ret.push {value: ini.format('DD'), date: ini.format('YYYY-MM-DD'), day_class: day_class}
      ini.add('days', 1)
    ret[week*7...week*7+7]

$.valHooks['xdatetime'] =
  get: (el)->
    value = $(el).find('.xdatetime-input').val()
    if not value
      return null
    format = $(el).attr('format')
    moment.utc(moment(value, format))

  set: (el, value)->
    formid = $(el).attr('formid')
    name = $(el).attr('name')
    path_ = path(formid, name)
    data.remove({path: path_})
    data.insert({path: path_, value:value})


$.fn.xdatetime = (name)->
  this.each ->
    this.type = 'xdatetime'
  this

Template.xdatetime.rendered = ->
  $(this.find('.xwidget')).xdatetime()