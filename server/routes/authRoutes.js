import express from 'express';
import { signup, login } from '../controllers/authController.js';
import rateLimit from 'express-rate-limit';

const router = express.Router();

// --- Stricter Rate Limiter for Auth Routes ---
const authLimiter = rateLimit({
    windowMs: 10 * 60 * 1000, // 10 minutes
    max: 5, // Limit each IP to 5 login/signup attempts per window
    message: 'Too many login attempts from this IP, please try again after 10 minutes',
    skipSuccessfulRequests: true, // Don't count successful authentications
});

// Apply limiter to auth routes
router.post('/signup', authLimiter, signup);
router.post('/login', authLimiter, login);

export default router;
