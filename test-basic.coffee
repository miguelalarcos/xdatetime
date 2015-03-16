describe 'test basic', ->
  el=null
  raw = "<template name='testing'>
    {{> xdatetime formid='0' name='datetime1' time=true format='DD-MM-YYYY HH:mm'}}
</template>"
  beforeEach (test)->
    el = Blaze.renderWithData(raw, {datetime1: moment('2015-01-01').toDate()}, $('body')[0])
    console.log el
    Meteor.flush()
  afterEach ->
    Blaze.remove(el)

  it 'test set get', (test) ->
    m = moment().toDate()
    $('[formid=0].xwidget').val(m)
    Meteor.flush()
    console.log $('[formid=0].xwidget')[0]
    console.log $('body')[0]
    back = moment($('[formid=0].xwidget').val())
    bool = moment(m).startOf('minute').isSame(back)
    console.log 'm', moment(m).startOf('minute').toDate()
    console.log 'back', back.toDate()
    test.isTrue bool

