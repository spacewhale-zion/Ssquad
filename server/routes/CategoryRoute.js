const express = require('express');
const router = express.Router();
import { protect, isAdmin } from '../middleware/authmiddleware';

// Import controllers
import { getCategories, seedCategories,addCategory } from '../controllers/CategoryController'

// --- Category Routes ---
router.route('/categories')
    .get(getCategories)       // GET all categories
    .post(protect,isAdmin,addCategory);       // POST a new category

router.post('/categories/seed',protect, isAdmin, seedCategories); // Optional: For setup



module.exports = router;