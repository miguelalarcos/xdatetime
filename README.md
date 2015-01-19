xdatetime
=========

A datetime widget. This package is used by [afwrap-xdatetime](https://github.com/miguelalarcos/afwrap-xdatetime).

In the examples folder you have a working example and a battery of tests with ```Jasmine```.

Example:
```coffee
Template.xdatetime_view.helpers
  data: -> {datetime1: moment.utc().toDate(), datetime2: moment.utc().toDate()}
```

```html
{{#with data}}
    {{> xdatetime formid='1' name='datetime1' time='true' format='DD-MM-YYYY HH:mm'}}
    <br>
    {{> xdatetime formid='1' name='datetime2' format='DD-MM-YYYY'}}
{{/with}}
```

Note that the pair *formid* and *name* has to be unique in the whole app. The name attribute is the object attribute you are displaying.

