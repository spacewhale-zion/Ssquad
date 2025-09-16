import express from 'express';
import { submitBanquetRequest } from '../controllers/banquestRequestController.js';
import { protect, isAdmin } from '../middleware/authmiddleware.js';

const router = express.Router();

// --- Banquet Request Routes ---
router.post('/banquet-requests', protect, submitBanquetRequest);

export default router;
