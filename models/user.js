const mongoose = require('mongoose');
const Joi = require('joi');
const jwt = require('jsonwebtoken');
require('dotenv').config();

 const mongoSchema = mongoose.Schema({
    name: {
        type: String, 
        required: true,
    },
    email:{
        type: String,
        required: true,
    },
    password:{
        type: String,
        required: true,
    },
    images: {
  type: Map,
  of: String,
  default: {},
}

 });

 mongoSchema.methods.generateAuthToken = function(){
    const token = jwt.sign({_id: this._id}, process.env.JWT_PRIVATE_KEY);
    return token;
 }

 const User = mongoose.model('User', mongoSchema);


 function validateUser(user){
    const schema = Joi.object({
        name: Joi.string().required(),
        email: Joi.string().email().required(),
        password: Joi.string().required(),
    });
    return schema.validate(user);
 }

 module.exports ={
    User,
    validateUser,
 }