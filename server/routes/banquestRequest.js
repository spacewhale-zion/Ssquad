const express = require('express');
const router = express.Router();
import { submitBanquetRequest } from '../controllers/banquetRequestController'

import  {protect, isAdmin}  from 'middleware/authMiddleware';


// --- Banquet Request Routes ---
router.post('/banquet-requests', protect, submitBanquetRequest);

