Package.describe({
  name: 'miguelalarcos:xdatetime',
  summary: 'datetime widget',
  version: '0.1.0',
  git: 'https://github.com/miguelalarcos/xdatetime.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.2.1');
  api.use('coffeescript', 'client');
  api.addFiles('miguelalarcos:xdatetime.coffee', 'client');
});
