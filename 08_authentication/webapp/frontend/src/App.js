import React, { useState } from "react";
import axios from "axios";
import { pbkdf2Sync } from "crypto";
import "./App.css";

function App() {
  const [loggedIn, setLoggedIn] = useState(false);
  const [token, setToken] = useState(null);
  const [flip, setFlip] = useState(false);
  return (
    <div className="App" id={flip ? "grey" : "white"}>
      {loggedIn ? (
        <BigButton toggle={handleLogOut} wiggle={handleDoSomething} />
      ) : (
        <LoginForm setLoggedIn={setLoggedIn} setToken={setToken} />
      )}
    </div>
  );

  // yes, there's no reason to handle stuff *this* differently, but...
  function handleLogOut() {
    setLoggedIn(false);
    setToken(null);
  }

  async function handleDoSomething() {
    try {
      const result = await axios.get("http://localhost:8080/users/0", {
        headers: {
          "x-access-token": token
        }
      });
      setToken(result.data.token);
      setFlip(!flip); // just change _something_
    } catch (e) {
      console.trace("Failed at itttt", e);
      setLoggedIn(false);
      setToken(null);
    }
  }
}

function LoginForm({ setLoggedIn, setToken }) {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [isLoggingIn, setIsLoggingIn] = useState(false);
  const [error, setError] = useState("");

  return (
    <>
      <h1>Hello there, {username || "visitor"}</h1>
      <button onClick={() => setIsLoggingIn(!isLoggingIn)}>
        {(isLoggingIn ? "Register" : "Log in") + " instead"}
      </button>
      <form onSubmit={handleSubmit}>
        <br />
        <legend>Username</legend>
        <input
          type="text"
          placeholder="Username"
          onChange={handleUsernameChange}
        />
        <legend>Password</legend>
        <input
          type="password"
          placeholder="Password"
          onChange={handlePasswordChange}
        />
        <br />
        <input type="submit" value={isLoggingIn ? "Log In" : "Register"} />
        <br />
        <span className="error">{error}</span>
      </form>
    </>
  );

  function handleUsernameChange(event) {
    if (!event.target || event.target.value === null) return;
    setUsername(event.target.value);
  }

  function handlePasswordChange(event) {
    if (!event.target || event.target.value === null) return;
    setPassword(event.target.value);
  }

  async function handleSubmit(event) {
    event.preventDefault();
    if (!username || !password) {
      setError("Empty username or password");
      return;
    }
    try {
      let result;
      // Simply hash with the username as salt - it is deterministic
      // The OpenSSL bindings seem to work somehow...
      const clientHash = pbkdf2Sync(
        password,
        username,
        1024,
        512,
        "sha512"
      ).toString();
      if (isLoggingIn) {
        result = await axios.post("http://localhost:8080/login", {
          username,
          clientHash
        });
      } else {
        // registering instead
        result = await axios.post("http://localhost:8080/users", {
          username,
          clientHash
        });
      }
      setToken(result.data.token);
      setLoggedIn(true);
    } catch (e) {
      if (e.response && e.response.status === 401) {
        setError("Incorrect username or password.\ndu fæ itj logge inn gitt");
      } else if (e.response.status === 409) {
        setError("This user already exists.");
      } else {
        setError(`An error occurred (${e.message})`);
      }
    }
  }
}

function BigButton({ toggle, wiggle }) {
  return (
    <>
      <h1>Hey there!</h1>
      <button onClick={wiggle}>Do... something</button>
      <br />
      <button onClick={toggle}>Log Out</button>
    </>
  );
}
export default App;
