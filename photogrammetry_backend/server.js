const express = require('express');
const multer = require('multer');
const mongoose = require('mongoose');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/photogrammetry', { useNewUrlParser: true, useUnifiedTopology: true });

const userSchema = new mongoose.Schema({
  userId: String,
  images: [String]
});

const User = mongoose.model('User', userSchema);

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const userId = req.body.userId;
    const userDir = path.join('uploads', userId);
    if (!fs.existsSync(userDir)) {
      fs.mkdirSync(userDir, { recursive: true });
    }
    cb(null, userDir);
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  }
});

const upload = multer({ storage: storage });

app.post('/upload', upload.single('image'), async (req, res) => {
  const userId = req.body.userId;
  const user = await User.findOne({ userId });

  if (user) {
    user.images.push(req.file.path);
    await user.save();
  } else {
    const newUser = new User({ userId, images: [req.file.path] });
    await newUser.save();
  }

  res.status(201).send('Image uploaded and stored successfully');
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
