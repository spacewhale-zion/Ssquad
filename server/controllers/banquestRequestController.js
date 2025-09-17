import BanquetRequest from "../models/banquestRequest.js";

// @desc    Submit a new banquet & venue request
// @route   POST /api/banquet-requests
const submitBanquetRequest = async (req, res) => {
  try {
    // The request body should match the schema
     const newRequest = new BanquetRequest({
      ...req.body,
      user: req.user._id, // <-- attach logged-in user
    });
    const savedRequest = await newRequest.save();
    res
      .status(201)
      .json({ message: "Request submitted successfully!", data: savedRequest });
  } catch (err) {
    res
      .status(400)
      .json({ message: "Error submitting request", error: err.message });
  }
};

// @desc    Get all banquet requests (Admin only)
// @route   GET /api/banquet-requests
const getAllBanquetRequests = async (req, res) => {
    try {
        const requests = await BanquetRequest.find({}).populate('user', 'name email');
        res.status(200).json(requests);
    } catch (err) {
        res.status(500).json({ message: 'Server Error', error: err.message });
    }
};

export  { submitBanquetRequest,getAllBanquetRequests};
