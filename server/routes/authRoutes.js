import express from 'express';
import { signup, login,getUser } from '../controllers/authController.js';
import rateLimit from 'express-rate-limit';
import { protect, isAdmin } from '../middleware/authmiddleware.js';

const router = express.Router();

const authLimiter = rateLimit({
    windowMs: 10 * 60 * 1000, 
    max: 5, 
    message: 'Too many login attempts from this IP, please try again after 10 minutes',
    skipSuccessfulRequests: true,
});

router.post('/signup', authLimiter, signup);
router.post('/login', authLimiter, login);

router.get('/me', protect, getUser );

export default router;
