# TODO add tests
# For login
#  authenticated check
#  user data check
#  wrong credentials check
#  redirect check
#  redirect when authenticated
# For registration
#  new user check
#  authenticated check
#  redirect check
#  redirect when authenticated
# For logout
#  delete user from session
#  redirect

User = require '../../models/user'
assert = require 'assert'
supertest = require 'supertest'
app = require '../../app'
setup = require '../support/database'

describe "Authentication", ->
  setup()

  describe "Login", ->
    request = ->
      supertest(app)
        .post('/users/login')
        .set('Accept', 'application/json')
        .send({username: "username", password: "password"})

    describe "valid parameters", ->
      beforeEach (done) ->

      it "checks success", (done) ->
        request().expect(200, done)

      it "checks json", (done) ->
        request()
        .expect('Content-Type', /json/, done)

      it "checks authenticated", (done) ->
        request()
        .expect (response) ->
          response.request.isAuthenticated()
        .expect(200, done)

  describe "Register", ->
    request = ->
      supertest(app)
        .post('/users/register')

    describe "valid parameters", ->
      it "checks success", (done) ->
        request().expect(200, done)

      it "checks json", (done) ->
        request()
        .expect('Content-Type', /json/, done)

      it "checks user", (done) ->
        request().expect ->
          console.log(User.count());
          User.count() == 1
        , done