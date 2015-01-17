current_input = null
show_calendar = new ReactiveVar(false)
xday = new ReactiveVar(moment.utc())
data = new Meteor.Collection null

path = (formid, name)-> formid + ':' + name

Template.xdatetime.events
  'click .show-calendar': (e, t)->
    current_input = path(this.formid, this.name)
    show_calendar.set(not show_calendar.get())

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
  week: -> (i for i in [0...6])
  day: (week) ->
    ret = []
    day=xday.get()
    ini_month = day.clone().startOf('Month')
    ini = day.clone().startOf('Month').add('days', -ini_month.day())
    end_month = day.clone().endOf('Month').startOf('Day')
    end = day.clone().endOf('Month').add('days', 7-end_month.day()).startOf('Day')

    while not ini.isSame(end)
      if ini_month.format('MM') == ini.format('MM')
        current_month_bold = 'bold'
      else
        current_month_bold = ''
      ret.push {value: ini.format('DD'), date: ini, current_month_bold: current_month_bold}
      ini.add('days', 1)
    ret[week*7...week*7+7]