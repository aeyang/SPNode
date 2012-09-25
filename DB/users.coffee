Mongoose = require 'mongoose'
DB = Mongoose.connect('mongodb://localhost/test')
#test is the name of the database in mongodb

Schema = Mongoose.Schema
ObjectId = Schema.ObjectId

# Define a schema so the application understands how to map data from MongoDB into Javascript objects.
# Schema is a part of the application, it has nothing to do with the database.
# Therefore, you need to run this code every time your app starts up. 
UserSchema = new Schema(
  login: String, 
  password: String,
  role: String
)

#User Schema to register a model with MongoDB
Mongoose.model('User', UserSchema)

#This is a model. Use this to find documents and 'create' documents
UserCollection = Mongoose.model('User')

#Documents are like this below: They are instances of models. You can create these to save them. Or use the 
#create method on a model
###
hey = new UserCollection({login: "john", password: "hey"})
hey.save (err) ->
  if err
    console.log err
  else
    console.log "Successfully saved user"###

module.exports.authenticate = UserSchema.methods.authenticate = (login, password, callback) ->
  UserCollection.findOne({login: login, password: password}, (err, user) ->
    if err
      console.log(err)
      callback(null)
      return
    if user
      callback(user.login)
      return
    callback(null)
  )