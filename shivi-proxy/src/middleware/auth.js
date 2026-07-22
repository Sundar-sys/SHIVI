const { appSecret } = require("../config/env");

function requireAppSecret(req, res, next) {
  const provided = req.headers["x-shivi-app-key"];
  console.log("Expected:", JSON.stringify(appSecret));
  console.log("Received:", JSON.stringify(provided));
  if (!provided || provided !== appSecret) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  next();
}

module.exports = { requireAppSecret };
