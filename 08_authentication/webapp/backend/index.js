// A minimal set of dependencies
const cors = require("cors");
const crypto = require("crypto");
const express = require("express");
const bodyParser = require("body-parser");
const fs = require("file-system");
const jwt = require("jsonwebtoken");

/**
 * Simple authentication demo.
 * Error handling only in the form of try-catches,
 * and there's no token-requiring endpoint other than the /users/:id one
 */

const PUBLIC_KEY = "hah";
const PRIVATE_KEY = PUBLIC_KEY;
const PBKDF_ITERATIONS = 2048;
const TOKEN_EXPIRE_TIME = 100;

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Load users on startup
let users = [];
try {
  users = JSON.parse(fs.readFileSync("users.json", "utf-8"));
} catch (e) {
  try {
    fs.writeFileSync("users.json", JSON.stringify([]), "utf-8");
  } catch (e) {
    console.trace("Couldn't create file!", e);
    process.exit(1);
  }
}

// Save users before exiting
const saveAndExit = () => {
  try {
    fs.writeFileSync("users.json", JSON.stringify(users), "utf-8");
  } catch (e) {
    console.trace("Couldn't save users to file!", e);
    process.exit(1);
  }
  process.exit(0);
};

process.on("SIGTERM", saveAndExit);
process.on("SIGINT", saveAndExit);

const generateToken = username => {
  return jwt.sign({ username: username }, PRIVATE_KEY, {
    expiresIn: TOKEN_EXPIRE_TIME
  });
};

app.post("/users", (req, res) => {
  try {
    // register dat user
    const { username, clientHash } = req.body;
    if (users.find(user => user.username === username))
      // unless it already exists!
      return res.status(409).send();
    // hash it, with salt!
    const serverSalt = crypto.randomBytes(16);
    const serverHash = crypto.pbkdf2Sync(
      clientHash,
      serverSalt,
      PBKDF_ITERATIONS,
      512,
      "sha512"
    );
    users.push({ username, serverHash, serverSalt });
    const token = generateToken(username);
    res.status(201).json({ token: token, userId: users.length - 1 });
  } catch (e) {
    console.trace("POST /users", e);
    return res.status(400).send();
  }
});

app.post("/login", (req, res) => {
  try {
    const { username, clientHash } = req.body;
    const { serverHash, serverSalt } = users.find(
      user => user.username === username
    ); // simple & will break
    // hash it!
    const hashToCheck = crypto.pbkdf2Sync(
      clientHash,
      serverSalt,
      PBKDF_ITERATIONS,
      512,
      "sha512"
    );
    if (hashToCheck.equals(serverHash)) {
      res.status(201).json({ token: generateToken(username) });
    } else {
      res.status(401).send(); // reject
    }
  } catch (e) {
    console.trace("POST /login", e);
    return res.status(401).send();
  }
});

app.get("/users/:id(\\d+)", (req, res) => {
  // only acc'd if token
  const id = req.params.id;
  const token = req.headers["x-access-token"];
  if (!token || id < 0 || id > users.length) return res.status(400).send();
  try {
    const { username } = jwt.verify(token, PUBLIC_KEY);
    console.log(`${username} is verified...`);
    const newToken = generateToken(username);
    return res
      .status(200)
      .json({ token: newToken, username: users[id].username });
  } catch (e) {
    console.trace("GET /users/id", e);
    return res.status(401).send();
  }
});

app.listen(8080);

console.log("Server started");
