import express from 'express';
import { protect, isAdmin } from '../middleware/authmiddleware.js';
import { getCategories, seedCategories, addCategory } from '../controllers/CategoryController.js';

const router = express.Router();

router.route('/categories')
    .get(getCategories)                 
    .post(protect, isAdmin, addCategory);

router.post('/categories/seed', protect, isAdmin, seedCategories); 

export default router;
