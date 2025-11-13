const express = require('express');
const router = express.Router();
const {User, validateUser} = require('../models/user');
const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Joi = require('joi');
const _ = require('lodash');
const { GoogleGenAI } = require("@google/genai");
const fs = require("fs");
const path = require("path");

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
    return res.send({ token, email: user.email });
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


router.post('/generate-image', auth, async (req, res) => {
  try {
    const prompt = req.body.prompt || "A Dragon spitting fire";

    const ai = new GoogleGenAI({
      apiKey: process.env.GEMINI_API_KEY
    });

    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash-image",
      contents: prompt
    });

    for (const part of response.candidates[0].content.parts) {
      if (part.inlineData) {
        const imageData = part.inlineData.data;
        const buffer = Buffer.from(imageData, "base64");

        const filename = `image_${Date.now()}.png`;
        const filePath = path.join(__dirname, '../public', filename);
        fs.writeFileSync(filePath, buffer);

        return res.send({
          message: 'Imagem gerada com sucesso',
          url: '/' + filename,
          prompt: prompt
        });
      }
    }

    return res.status(500).send({ error: 'Nenhuma imagem foi gerada' });
  } catch (err) {
    console.error("❌ Erro ao gerar imagem:", err.message);
    return res.status(500).send({ error: 'Erro ao gerar imagem' });
  }
});

router.post('/add-image', auth, async (req, res) => {
  try {
    const { key, url } = req.body;

    if (!key) {
      return res.status(400).send({ error: 'A chave da imagem é obrigatória' });
    }

    await User.findByIdAndUpdate(req.user._id, {
      $set: { [`images.${key}`]: url }
    });

    return res.send({ message: 'Imagem adicionada com sucesso', key, url });
  } catch (err) {
    console.error('❌ Erro ao adicionar imagem:', err.message);
    return res.status(500).send({ error: 'Erro ao adicionar imagem ao usuário' });
  }
});

router.delete('/delete-image', auth, async (req, res) => {
  try {
    const { key } = req.body;

    if (!key) {
      return res.status(400).send({ error: 'A chave da imagem é obrigatória' });
    }

    await User.findByIdAndUpdate(req.user._id, {
      $unset: { [`images.${key}`]: "" }
    });

    return res.send({ message: 'Imagem excluída com sucesso', key });
  } catch (err) {
    console.error('❌ Erro ao excluir imagem:', err.message);
    return res.status(500).send({ error: 'Erro ao excluir imagem do usuário' });
  }
});



router.get('/me', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-password');
    if (!user) return res.status(404).send({ error: 'Usuário não encontrado' });

    res.send(user);
  } catch (err) {
    console.error('❌ Erro ao buscar usuário:', err.message);
    res.status(500).send({ error: 'Erro ao buscar dados do usuário' });
  }
});




module.exports = router;