require("dotenv").config();

module.exports = {
  hfToken: process.env.HF_API_TOKEN,
  port: process.env.PORT || 3000,
  appSecret: process.env.SHIVI_APP_SECRET,
  hfModel: "deepseek/deepseek-r1:free",
  hfRouterUrl: `https://openrouter.ai/api/v1/chat/completions`,
};
