const rateLimit = require('express-rate-limit');

// Per-IP limit — tune based on expected usage. This protects your HF
// quota and your wallet if you move to a paid endpoint later.
const chatLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many requests, please slow down.' },
});

module.exports = { chatLimiter };
