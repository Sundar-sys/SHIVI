const express = require("express");
const axios = require("axios");
const { hfToken, hfRouterUrl } = require("../config/env");

const router = express.Router();

const SYSTEM_PROMPTS = {
  companion: `You are Shivi, a calm, empathetic bilingual (Hindi-English/Hinglish) voice
companion. Your goal is to reduce the user's anxiety, help them practice
communication, and keep them company. Speak warmly and briefly (1-3 sentences),
in a natural spoken style, mixing Hindi and English the way the user does.
Never give medical advice; gently suggest professional help for serious distress.`,

  quizMaster: `You are Shivi, a warm, energetic bilingual (Hindi-English/Hinglish) quiz
host. Keep questions short, fun, and suited for spoken delivery. Mix Hindi and
English naturally like a friendly Indian host would. Never be sarcastic or mean.
Keep responses under 3 sentences unless asked to elaborate.`,

  playfulBanter: `You are Shivi, a witty, lighthearted bilingual (Hindi-English/Hinglish)
friend. Tease gently, keep things playful and warm, never insulting. Match the
user's language mix. Keep responses under 3 sentences, conversational tone.`,
};

router.post("/chat", async (req, res) => {
  try {
    const { messages, persona } = req.body;

    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ error: "messages array is required" });
    }

    // Basic shape validation — don't trust the client payload blindly
    const validRoles = ["user", "assistant"];
    const cleanMessages = messages
      .filter(
        (m) => validRoles.includes(m.role) && typeof m.content === "string",
      )
      .map((m) => ({ role: m.role, content: m.content.slice(0, 2000) })); // cap length

    const systemPrompt = SYSTEM_PROMPTS[persona] || SYSTEM_PROMPTS.companion;

    const payload = {
      model: "deepseek/deepseek-r1:free",
      messages: [{ role: "system", content: systemPrompt }, ...cleanMessages],
      max_tokens: 200,
      temperature: persona === "companion" ? 0.7 : 0.9,
      stream: false,
    };

    const response = await axios.post(hfRouterUrl, payload, {
      headers: {
        Authorization: `Bearer ${hfToken}`,
        "Content-Type": "application/json",
      },
      timeout: 30000,
    });

    const content = response.data?.choices?.[0]?.message?.content;

    if (!content) {
      return res.status(502).json({ error: "Empty response from model" });
    }

    return res.json({ reply: content.trim() });
  } catch (err) {
    if (err.response?.status === 503) {
      return res.status(503).json({
        error: "Model is warming up, please retry shortly",
        retryable: true,
      });
    }
    console.error(
      "HF proxy error:",
      err.response?.status,
      JSON.stringify(err.response?.data),
    );
    return res
      .status(500)
      .json({ error: "Something went wrong", retryable: true });
  }
});

module.exports = router;
