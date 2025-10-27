const express = require('express');
const router = express.Router();
const {User, validateUser} = require('../models/user');
const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Joi = require('joi');
const _ = require('lodash');

router.get('/dados-protegidos', auth, (req, res) => {
  res.send('Acesso autorizado');
});

router.post('/createaccount', async (req, res) => {
    const{error} = validateUser(req.body);
    if(error) return res.status(400).send(error.details[0].message);
    let user = await User.findOne({email: req.body.email});
    if(user) return res.status(400).send('Um usuário com esse email já existe');
    user = new User(_.pick(req.body, ['name', 'email', 'password']));
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);
    const token = user.generateAuthToken();
    user.save();
    return res.send('success');
});



function validateSignIn(credentials){
    const schema = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().required(),
    });
    return schema.validate(credentials);
}

router.post('/sign-in', async(req, res) => {
    const {error}= validateSignIn(req.body);
    if(error) return res.status(400).send(error.details[0].message);
    let user = await User.findOne({email: req.body.email});
    if(!user) return res.status(400).send('Email ou senha inválido');
    const validPassword = await bcrypt.compare(req.body.password, user.password);
    if(!validPassword) return res.status(400).send('Email ou senha inválido');
    const token = user.generateAuthToken();
    response = {'token': token, 'email': user.email};
    return res.send(response);
});

module.exports = router;