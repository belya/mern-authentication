mongoose = require 'mongoose'
User = require '../../models/user'
bcrypt = require 'bcryptjs'
fixtures = require 'pow-mongoose-fixtures'
setup = require '../support/database'

validUser = ->
  new User {
    username: "username",
    password: "password",
    passwordConfirmation: "password"
  }

describe "User", ->
  setup()
  
  it "checks username presence", ->
    user = new User {username: ""}
    expect(user.validateSync().errors.username.message)
    .toEqual("No username provided")

  it "checks password presence", ->
    user = new User {password: ""};
    expect(user.validateSync().errors.password.message)
    .toEqual("No password provided")

  it "checks password length", ->
    user = new User {password: "123456"}
    expect(user.validateSync().errors.password.message)
    .toEqual("Password should contains at least 8 symbols")

  it "checks password confirmation", ->
    user = new User {
      password: "12345678", 
      passwordConfirmation: "12345"
    }
    expect(user.validateSync().errors.password.message)
    .toEqual("Password is not confirmed")

  it "checks completely valid user", ->
    user = validUser();
    expect(user.validateSync()).not.toBeDefined()

  describe "password hashing", ->
    beforeEach ->
      this.user = validUser()

    it "checks hashing result", ->
      this.user.hashPassword();
      expect(this.user.password).not.toEqual("password")

    it "checks password decryption", ->
      this.user.hashPassword()
      expect(bcrypt.compareSync('password', this.user.password)).toBeTruthy()

    it "checks method call after save", ->
      spyOn this.user, 'hashPassword'
      this.user.save =>
        expect(this.user.hashPassword).toHaveBeenCalled()