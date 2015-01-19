dayRow = @_testing_xdatetime.dayRow
xday = @_testing_xdatetime.xday

describe 'test dayRow',->
  beforeEach ->
    xday.set(moment('18-01-2015','DD-MM-YYYY'))
  it 'test', ->
    list = (x.value for x in dayRow(0))
    expect(list).toEqual(['29','30','31','01','02','03','04'])
  it 'test 2', ->
    list = (x.value for x in dayRow(4))
    expect(list).toEqual(['26','27','28','29','30','31','01'])
  it 'test 3', ->
    list = (x.value for x in dayRow(5))
    expect(list).toEqual([])

describe 'test init', ->
  it 'test', ->
    m=moment('2015-01-01')
    spyOn(moment, 'utc').and.returnValue(m)
    el = Blaze.renderWithData(Template.testing, {}, $('body')[0])
    Meteor.flush()
    back=$('[formid=0].xwidget').val()
    bool = moment(back).isSame(m)
    expect(bool).toBe(true)
    Blaze.remove(el)

describe 'test...', ->
  el= null
  beforeEach ->
    el = Blaze.renderWithData(Template.testing, {datetime1: moment('2015-01-01').toDate()}, $('body')[0])
    Meteor.flush()
  afterEach ->
    Blaze.remove(el)

  it 'test set get', ->
    m = moment.utc()
    $('[formid=0].xwidget').val(m)
    Meteor.flush()
    back = moment($('[formid=0].xwidget').val())
    bool = moment(m).startOf('minute').isSame(back)
    expect(bool).toBe(true)

  it 'test init get', ->
    back = moment($('[formid=0].xwidget').val())
    bool = moment('2015-01-01').isSame(back)
    expect(bool).toBe(true)

  it 'test click day', ->
    $('[formid=0] .show-calendar').trigger('click')
    Meteor.flush()
    $('[formid=0] .xtoday').trigger('click')
    Meteor.flush()
    back = moment.utc($('[formid=0].xwidget').val()).startOf('day')
    today = moment.utc().startOf('day')
    expect(back.isSame(today)).toBe(true)

  it 'test minus 1 minute', ->
    dt = xday.get()
    $('[formid=0] .show-calendar').trigger('click')
    Meteor.flush()
    $('[formid=0] .minus-minute').trigger('click')
    dt2 = xday.get() # ojo en algun momento xday deja de estar en utc. Invesigarlo
    expect(dt.diff(dt2, 'minutes')).toBe(1)
    $('[formid=0] .show-calendar').trigger('click')
    Meteor.flush()

  it 'test change year', ->
    dt = xday.get()
    $('[formid=0] .show-calendar').trigger('click')
    Meteor.flush()
    current_year = parseInt($('[formid=0] .xdatetime-year').val())
    $('[formid=0] .xdatetime-year').val(current_year+1)
    $('[formid=0] .set-year').trigger('click')

    dt2 = xday.get()
    expect(dt2.diff(dt, 'years')).toBe(1)
    $('[formid=0] .show-calendar').trigger('click')
    Meteor.flush()


