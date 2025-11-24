const express = require('express');
const router = express.Router();
const { User, validateUser } = require('../models/user');
const auth = require('../middleware/auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const Joi = require('joi');
const _ = require('lodash');
const { GoogleGenAI } = require("@google/genai");
const fs = require("fs");
const path = require("path");
const { Storage } = require('@google-cloud/storage');

// Configuração do bucket
const storage = new Storage({
  keyFilename: path.join(__dirname, '../credencial/gen-lang-client-0366626204-08f09f25f94c.json'),
});
const bucketName = 'poliedro-pi-ia';
const bucket = storage.bucket(bucketName);

// Proteção simples
router.get('/dados-protegidos', auth, (req, res) => {
  res.send('Acesso autorizado');
});

// Criar conta
router.post('/createaccount', async (req, res) => {
  const { error } = validateUser(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  let user = await User.findOne({ email: req.body.email });
  if (user) return res.status(400).send('Um usuário com esse email já existe');

  user = new User(_.pick(req.body, ['name', 'email', 'password']));
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  const token = user.generateAuthToken();
  await user.save();

  return res.send({ token, email: user.email });
});

// Login
function validateSignIn(credentials) {
  const schema = Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  });
  return schema.validate(credentials);
}

router.post('/sign-in', async (req, res) => {
  const { error } = validateSignIn(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const user = await User.findOne({ email: req.body.email });
  if (!user) return res.status(400).send('Email ou senha inválido');

  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) return res.status(400).send('Email ou senha inválido');

  const token = user.generateAuthToken();
  return res.send({ token, email: user.email });
});

// Gerar imagem local
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

        // 🔹 Atualiza no banco a última imagem do usuário
        await User.findByIdAndUpdate(req.user._id, {
          $set: { lastImage: filename }
        });

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


router.post('/edit-image', auth, async (req, res) => {
  try {
    let { filename, prompt } = req.body;
    const isContinue = prompt && prompt.toLowerCase().includes("continue editando");

    const user = await User.findById(req.user._id);
    const targetFile = filename || (isContinue ? user.lastImage : null);
    if (!targetFile) return res.status(400).send({ error: 'Nenhuma imagem alvo encontrada' });

    const filePath = path.join(__dirname, '../public', targetFile);
    if (!fs.existsSync(filePath)) return res.status(404).send({ error: 'Imagem não encontrada' });

    const buffer = fs.readFileSync(filePath);
    const base64Image = buffer.toString("base64");

    if (isContinue) {
      prompt = prompt.replace(/continue editando/gi, "").trim() || "continue editando a imagem";
    }

    const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash-image",
      contents: [{
        role: "user",
        parts: [
          { inlineData: { data: base64Image, mimeType: "image/png" } },
          { text: prompt }
        ]
      }]
    });

    for (const part of response.candidates[0].content.parts) {
      if (part.inlineData) {
        const newBuffer = Buffer.from(part.inlineData.data, "base64");
        const newFilename = `edited_${Date.now()}.png`;

        // salva localmente
        const localPath = path.join(__dirname, '../public', newFilename);
        fs.writeFileSync(localPath, newBuffer);

        // atualiza lastImage para suportar "continue editando"
        await User.findByIdAndUpdate(req.user._id, { $set: { lastImage: newFilename } });

        return res.send({
          message: 'Imagem editada com sucesso',
          name: newFilename,
          filename: newFilename,   
          url: '/' + newFilename,  
          prompt,
          createdAt: new Date().toISOString()
        });
      }
    }

    return res.status(500).send({ error: 'Nenhuma edição foi gerada pela IA' });
  } catch (err) {
    console.error("❌ Erro ao editar imagem:", err.message);
    return res.status(500).send({ error: 'Erro ao editar imagem' });
  }
});



router.post('/add-to-gallery', auth, async (req, res) => {
  try {
    const { filename, key } = req.body;
    if (!filename || !key) return res.status(400).send({ error: 'Nome da imagem e chave são obrigatórios' });

    const localPath = path.join(__dirname, '../public', filename);
    if (!fs.existsSync(localPath)) return res.status(404).send({ error: 'Imagem não encontrada no servidor' });

    const buffer = fs.readFileSync(localPath);
    const file = bucket.file(filename);
    await file.save(buffer, { contentType: 'image/png', public: false });

    const [signedUrl] = await file.getSignedUrl({
  action: 'read',
  expires: new Date(Date.now() + 60 * 60 * 1000), 
});


    await User.findByIdAndUpdate(req.user._id, { $set: { [`images.${key}`]: filename } });

    return res.send({
      message: 'Imagem adicionada à galeria com sucesso',
      name: filename,
      url: signedUrl,
      key
    });
  } catch (err) {
    console.error('❌ Erro ao adicionar à galeria:', err.message);
    return res.status(500).send({ error: 'Erro ao enviar imagem para o bucket' });
  }
});

// Listar galeria do usuário com Signed URLs gerados na hora
router.get('/gallery', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
    const imagesMap = user.images || {};
    const images = imagesMap instanceof Map ? Object.fromEntries(imagesMap) : imagesMap; // ✅ garante objeto

    const signedUrls = await Promise.all(
      Object.entries(images).map(async ([key, filename]) => {
        const file = bucket.file(filename);
        const [url] = await file.getSignedUrl({
          action: 'read',
          expires: new Date(Date.now() + 60 * 60 * 1000), 
        });
        return { name: filename, key, url };
      })
    );

    res.json(signedUrls);
  } catch (err) {
    console.error('❌ Erro ao listar imagens:', err);
    res.status(500).send({ error: 'Erro ao listar imagens' });
  }
});




// Excluir imagem do usuário (não remove do bucket)
router.delete('/delete-image', auth, async (req, res) => {
  try {
    const { key } = req.body;
    if (!key) return res.status(400).send({ error: 'A chave da imagem é obrigatória' });

    await User.findByIdAndUpdate(req.user._id, {
      $unset: { [`images.${key}`]: "" }
    });

    return res.send({ message: 'Imagem excluída com sucesso', key });
  } catch (err) {
    console.error('❌ Erro ao excluir imagem:', err.message);
    return res.status(500).send({ error: 'Erro ao excluir imagem do usuário' });
  }
});

// Dados do usuário
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
