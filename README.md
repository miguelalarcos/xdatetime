xdatetime
=========

A datetime widget. This package is used by [afwrap-xdatetime](https://github.com/miguelalarcos/afwrap-xdatetime).

Explanation
-----------

Example:
```coffee
Template.xdatetime_view.helpers
  data: -> {datetime1: moment.utc().toDate(), datetime2: moment.utc().toDate()}
```

```html
{{#with data}}
    {{> xdatetime formid='1' name='datetime1' time=true format='DD-MM-YYYY HH:mm'}}
    <br>
    {{> xdatetime formid='1' name='datetime2' format='DD-MM-YYYY'}}
{{/with}}
```

Note that the pair *formid* and *name* has to be unique in the whole app. The name attribute is the object attribute you are displaying.

The widget is DST aware. If you navigate to a date-time which is a repetition (e.g. Spain 25-10-2015 repetition of 02:30), the color of the time will be red. Of course date-time will be returned always as a Date object from UTC moment.

In the examples folder you have a working example and a battery of tests with ```Jasmine```.

Contributors
------------

* @amazingBastard

