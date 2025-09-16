import express from 'express';
import { protect, isAdmin } from '../middleware/authmiddleware.js';
import { getCategories, seedCategories, addCategory } from '../controllers/CategoryController.js';

const router = express.Router();

// --- Category Routes ---
router.route('/categories')
    .get(getCategories)                 // GET all categories
    .post(protect, isAdmin, addCategory); // POST a new category

router.post('/categories/seed', protect, isAdmin, seedCategories); // Optional: For setup

export default router;
