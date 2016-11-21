var mongoose = require('mongoose');
var bcrypt = require('bcryptjs');

var UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: [true, "No username provided"]
  },
  password: {
    type: String,
    required: [true, "No password provided"],
    minlength: [8, "Password should contains at least 8 symbols"],
    validate: {
      validator: function(value) {
        return this.passwordConfirmation == value;
      },
      message: "Password is not confirmed"
    }
  },

  passwordConfirmation: String
});

UserSchema.pre('save', function(next) {
  this.hashPassword();
  next();
})

UserSchema.methods.hashPassword = function() {
  this.password = bcrypt.hashSync(this.password, UserSchema.SALT_LENGTH);
}

UserSchema.SALT_LENGTH = 8;

module.exports = mongoose.model('User', UserSchema)