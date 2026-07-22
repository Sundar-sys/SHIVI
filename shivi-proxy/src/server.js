const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const { port } = require("./config/env");
const { requireAppSecret } = require("./middleware/auth");
const { chatLimiter } = require("./middleware/rateLimiter");
const chatRoutes = require("./routes/chat");

const app = express();
console.log("Loaded secret:", process.env.SHIVI_APP_SECRET);

app.use(helmet());
app.use(cors()); // lock this down to your app's origin(s) in production
app.use(express.json({ limit: "100kb" }));

app.get("/health", (_req, res) => res.json({ status: "ok" }));

app.use("/api", requireAppSecret, chatLimiter, chatRoutes);

app.listen(port, () => {
  console.log(`Shivi proxy running on port ${port}`);
});
