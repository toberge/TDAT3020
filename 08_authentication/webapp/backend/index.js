// A minimal set of dependencies
const crypto = require('crypto');
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('file-system');
const jwt = require('jsonwebtoken');

const PUBLIC_KEY = 'hah';
const PRIVATE_KEY = PUBLIC_KEY;
const PBKDF_ITERATIONS = 2048;

const app = express();
app.use(bodyParser.json());

const users = JSON.parse(fs.readFileSync('users.json', 'utf-8'));

app.post('/users', (req, res) => {
  try {
    // log in dat user
    const { username, clientHash, clientSalt } = req.body;
    const serverSalt = crypto.randomBytes(16);
    const serverHash = crypto.pbkdf2Sync(clientHash, serverSalt, PBKDF_ITERATIONS, 512, 'sha512');
    users.push({ username, serverHash, clientSalt, serverSalt });
    res.status(201).json({ userId: users.length - 1 });
  } catch (e) {
    console.trace('POST /users', e);
    return res.status(400).send();
  }
});

app.post('/login', (req, res) => {
  try {
    const { userId, clientHash } = req.body;
    const { serverHash, serverSalt } = users[userId]; // simple & will break
    const hashToCheck = crypto.pbkdf2Sync(clientHash, serverSalt, PBKDF_ITERATIONS, 512, 'sha512');
    if (hashToCheck.equals(serverHash)) {
      res.status(201).json({ token: 'yesbutactuallyno' }); // TODO return token too...
    } else {
      console.log(hashToCheck, serverHash)
      res.status(401).send(); // reject
    }
  } catch (e) {
    console.trace('POST /login', e);
    return res.status(401).send();
  }
});

app.get('/users/:id(\\d+)', (req, res) => {
  const id = req.params.id;
  if (id < 0 || id > users.length)
    return res.status(400).send();
  return res.status(200).json({ username: users[id].username });
})

app.listen(8080);

console.log('Server started');
