Package.describe({
  name: 'miguelalarcos:xdatetime',
  summary: 'datetime widget',
  version: '0.1.2',
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
