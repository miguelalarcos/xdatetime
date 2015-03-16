Package.describe({
  name: 'miguelalarcos:xdatetime',
  summary: 'datetime widget',
  version: '0.3.3',
  git: 'https://github.com/miguelalarcos/xdatetime.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.2.1');
  api.use('coffeescript', 'client');
  api.use('underscore', 'client');
  api.use('jquery', 'client');
  api.use('session', 'client');
  api.use('templating', 'client');
  api.use('reactive-var', 'client');
  api.use('momentjs:moment@2.8.4', 'client');
  api.addFiles('xdatetime.html', 'client');
  api.addFiles('xdatetime.coffee', 'client');
  api.addFiles('xdatetime.css', 'client');
});

Package.onTest(function(api) {
    api.use('tinytest');
    api.use('miguelalarcos:xdatetime');
    api.use('coffeescript');
    api.use('momentjs:moment@2.8.4', 'client');
    //api.use('mongo', ['client', 'server']);
    //api.use('underscore', 'client');
    api.use('practicalmeteor:munit', ['client', 'server']);
    api.addFiles('test-basic.html', 'client');
    api.addFiles('test-basic.coffee', 'client');
});