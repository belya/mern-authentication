var mongoose = require('mongoose');
var User = require('../../models/user');

module.exports = function() {
  beforeEach(function(done) {
    mongoose.connect('mongodb://localhost/testdb', done)
  });

  afterEach(function(done) {
    User.remove({}, function() {
      mongoose.connection.close(done)
    });
  });
}