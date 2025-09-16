const express = require('express');
const router = express.Router();
const { signup, login } = require('../controllers/authController');
const rateLimit = require('express-rate-limit');

// --- Stricter Rate Limiter for Auth Routes ---
const authLimiter = rateLimit({
    windowMs: 10 * 60 * 1000, // 10 minutes
    max: 5, // Limit each IP to 5 login/signup attempts per window
    message: 'Too many login attempts from this IP, please try again after 10 minutes',
    skipSuccessfulRequests: true, // Don't count successful authentications
});

router.post('/signup', signup);
router.post('/login', login);

module.exports = router;