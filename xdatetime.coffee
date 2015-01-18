current_input = null
show_calendar = new ReactiveVar(false)
xday = new ReactiveVar(moment())
data = new Meteor.Collection null

path = (formid, name)-> formid + ':' + name

Template.xdatetime.events
  'click .show-calendar': (e, t)->
    current_input = path(this.formid, this.name)
    show_calendar.set(not show_calendar.get())

  'click .xdatetime-day': (e, t)->
    path_ = path(t.data.formid, t.data.name)
    atts = t.data.atts or t.data
    if atts.time == 'true'
      value = $(t.find('.xdatetime-time')).val()
      date = this.date + ' ' + value
    else
      date = this.date
    data.update({path: path_}, {$set: {value: moment(date)}})
    show_calendar.set(false)
    xday.set(moment())
  'focusout .xdatetime-year, .set-year': (e,t)->
    year = $(e.target).val()
    xday.set(xday.get().year(year))
  'click .minus-month': (e,t)->
    xday.set(xday.get().subtract(1, 'months'))
  'click .plus-month': (e,t)->
    xday.set(xday.get().add(1, 'months'))


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
    if item then item.value.format(atts.format) else null

  show_calendar: -> show_calendar.get() and current_input == path(this.formid, this.name)
  show_time: ->
    atts = this.atts or this
    atts.time == 'true'
  time: -> moment().format('hh:mm')
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
    moment(value, format)

  set: (el, value)->
    formid = $(el).attr('formid')
    name = $(el).attr('name')
    path_ = path(formid, name)
    #if _.isEqual(value, [""]) or value == '' # don't know why happens
    #  xdata.update({name: name}, {$set:{value: ''}})
    #  return
    if _.isString(value)
      value = moment.utc(value, "YYYY-MM-DD[T]HH:mm:ss.SSS[Z]").local()
    else if _.isDate(value)
      value = moment(value)
    else
      value = value.local()

    data.remove({path: path_})
    data.insert({path: path_, value:value})


$.fn.xdatetime = (name)->
  this.each ->
    this.type = 'xdatetime'
  this

Template.xdatetime.rendered = ->
  $(this.find('.xwidget')).xdatetime()