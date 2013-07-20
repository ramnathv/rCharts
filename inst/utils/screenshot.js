var casper = require('casper').create({viewportSize:{width:1600,height:900}});
var args = casper.cli.args;
var imgfile = (args[1] || Math.random().toString(36).slice(2)) + '.png'
casper.start(args[0], function() {
  this.wait(args[2], function(){
    this.captureSelector(imgfile, '.rChart');
  });
});

casper.run();