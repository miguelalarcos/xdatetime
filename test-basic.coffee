dayRow = @_testing_xdatetime.dayRow
show_calendar = @_testing_xdatetime.show_calendar
data = @_testing_xdatetime.data

describe 'test dayRow',->
  it 'test', (test) ->
    list = (x.value for x in dayRow(0, moment('18-01-2015','DD-MM-YYYY')))
    test.equal list, ['29','30','31','01','02','03','04']
  it 'test 2', (test)->
    list = (x.value for x in dayRow(4, moment('18-01-2015','DD-MM-YYYY')))
    test.equal list, ['26','27','28','29','30','31','01']
  it 'test 3', (test)->
    list = (x.value for x in dayRow(5, moment('18-01-2015','DD-MM-YYYY')))
    test.equal list, []

describe.skip 'test init', ->
  el = null
  m=moment('2015-01-01')
  beforeEach (test)->
    el = Blaze.renderWithData(Template.testing, {}, $('body')[0])
    Meteor.flush()
    st = stubs.create('moment', window, 'moment')
    st.returns(m)

  afterEach (test)->
    Blaze.remove(el)
    stubs.restoreAll()

  it 'test', (test)->
    back=$('[formid=0].xwidget').val()
    test.isTrue moment(back).isSame(m)


describe 'test no degeneration', ->
  it 'test', (test)->
    el = Blaze.renderWithData(Template.testing, {datetime1: moment('2015-01-01').toDate()}, $('body')[0])
    Meteor.flush()
    date = moment().startOf('minute').toDate()
    $('[formid=0].xwidget').val(date)
    date2 = $('[formid=0].xwidget').val()
    $('[formid=0].xwidget').val(date2)
    date3 = $('[formid=0].xwidget').val()
    test.isTrue moment(date).isSame(moment(date3))
    Blaze.remove(el)

describe 'test basic', ->
  el=null
  beforeEach (test)->
    el = Blaze.renderWithData(Template.testing, {datetime1: moment('2015-01-01').toDate()}, $('body')[0])
    Meteor.flush()
  afterEach ->
    Blaze.remove(el)

  it 'test set get', (test) ->
    m = moment().toDate()
    $('[formid=0].xwidget').val(m)
    Meteor.flush()
    back = moment($('[formid=0].xwidget').val())
    bool = moment(m).startOf('minute').isSame(back)
    test.isTrue bool

  it 'test init get', (test) ->
    back = moment($('[formid=0].xwidget').val())
    bool = moment('2015-01-01').isSame(back)
    test.isTrue bool

  it 'test click day', (test)->
    $('[formid=0].xwidget').val(moment.utc().toDate())
    $('[formid=0] .show-calendar').trigger('click')
    Tracker.flush()
    $('[formid=0] .xtoday').trigger('click')
    Tracker.flush()
    back = moment($('[formid=0].xwidget').val()).startOf('day').utc()
    today = moment().startOf('day').utc()
    test.isTrue back.isSame(today)

describe 'test ui', ->
  el= null
  beforeEach ->
    show_calendar.set(false)
    el = Blaze.renderWithData(Template.testing, {datetime1: moment('2015-01-01').toDate()}, $('body')[0])
    Meteor.flush()
    $('[formid=0] .show-calendar').trigger('click')
    Meteor.flush()

  afterEach ->
    if show_calendar.get()
      $('[formid=0] .show-calendar').trigger('click')
      Meteor.flush()
    Blaze.remove(el)

  it 'test minus 1 minute', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .minus-minute').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'minutes'), 1

# ##
  it 'test plus 1 minute', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .plus-minute').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'minutes'), -1

  it 'test minus 1 hour', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .minus-hour').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'hours'), 1

  it 'test plus 1 hour', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .plus-hour').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'hours'), -1

  it 'test minus 1 month', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .minus-month').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'months'), 1

  it 'test plus 1 month', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .plus-month').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'months'), -1

  it 'test minus 1 year', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .minus-year').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'years'), 1

  it 'test plus 1 year', (test)->
    path_ = '0:datetime1'
    dt = data.findOne(path: path_).value
    $('[formid=0] .plus-year').trigger('click')
    dt2 = data.findOne(path: path_).value
    test.equal dt.diff(dt2, 'years'), -1

  it 'test change input date', (test)->
    path_ = '0:datetime1'
    $('[formid=0] .xdatetime-input').val('01-01-2015 00:00')
    $('[formid=0] .xdatetime-input').trigger('focusin')
    $('[formid=0] .xdatetime-input').trigger('focusout')
    dt_format = data.findOne(path: path_).value.format('DD-MM-YYYY HH:mm')
    test.equal dt_format, '01-01-2015 00:00'