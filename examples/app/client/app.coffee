Template.xdatetime_view.helpers
  data: -> {datetime1: moment.utc().toDate(), datetime2: moment.utc().toDate()}

Template.xdatetime_view.events
  'click .log': (e,t)->
    for el in t.findAll('.xwidget')
      console.log $(el).val()