import express from 'express';
import { submitBanquetRequest,getAllBanquetRequests } from '../controllers/banquestRequestController.js';
import { protect, isAdmin } from '../middleware/authmiddleware.js';

const router = express.Router();

// --- Banquet Request Routes ---
router.post('/banquet-requests', protect, submitBanquetRequest);
router.get('/banquet-requests',protect, isAdmin, getAllBanquetRequests)

export default router;
