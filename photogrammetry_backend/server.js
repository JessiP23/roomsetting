const express = require('express');
const multer = require('multer');
const mongoose = require('mongoose');
const { exec } = require('child_process');
const app = express();
const port = 3000;

// Serve static files
app.use(express.static('public'));

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/photogrammetry', { useNewUrlParser: true, useUnifiedTopology: true });

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  }
});
const upload = multer({ storage: storage });


app.post('/upload', upload.single('image'), (req, res) => {
  exec('python3 photogrammetry.py', (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      res.status(500).send('Photogrammetry processing failed');
      return;
    }
    if (stderr) {
      console.error(`Stderr: ${stderr}`);
      res.status(500).send('Photogrammetry processing error');
      return;
    }
    console.log(`Stdout: ${stdout}`);
    res.status(201).send('Images processed successfully');
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
