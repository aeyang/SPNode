Mongoose = require 'mongoose'
bcrypt = require 'bcrypt'
DB = Mongoose.connect('mongodb://localhost/test')
SALT_WORK_FACTOR = 10;

Schema = Mongoose.Schema
ObjectId = Schema.ObjectId

# Define a schema so the application understands how to map data from MongoDB into Javascript objects.
# Schema is a part of the application, it has nothing to do with the database.
# Therefore, you need to run this code every time your app starts up. 
UserSchema = new Schema(
  login: {type: String, required: true, index: {unique: true} }, 
  password: {type: String, required: true }
)

UserSchema.pre('save', (next) ->
  console.log("in pre save")
  user = this;
  if(!user.isModified('password')) then return next();

  bcrypt.genSalt(SALT_WORK_FACTOR, (err, salt) ->
    if(err)
      console.log("in pre save/bcrypt.gensalt " + err )
      return next(err)

    bcrypt.hash(user.password, salt, (err, hash) ->
      if(err)
        console.log("in pre save/bcrypt.gensalt/bcrypt.hash " + err )
        return next(err)
      user.password = hash
      next()
    )
  )
)

#User Schema to register a model with MongoDB
Mongoose.model('User', UserSchema)

#This is a model. Use this to find documents and 'create' documents
UserCollection = Mongoose.model('User')

module.exports.authenticate = UserSchema.methods.authenticate = (login, password, callback) ->
  console.log("in authenticate")
  UserCollection.findOne({login: login}, (err, user) ->
    if err
      console.log(err)
      callback(err, null)
    if user
      bcrypt.compare(password, user.password, (err, isMatch) ->
        if err
          console.log("Error after bcrypt compare")
          callback(err, null)
        else if isMatch
          callback(null,user.login)
        else
          callback("Your credentials do not match our records :(", null)
      )
    else
      callback("No user named " + login, null)
  )

module.exports.save = UserSchema.methods.save = (login, password, callback) ->
  UserCollection.create {login: login, password: password}, (err) ->
    console.log("in save")
    if err
      console.log("in save " + err)
      callback(err)