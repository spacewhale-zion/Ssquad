import BanquetRequest from "../models/banquestRequest.js";

// @desc    Submit a new banquet & venue request
// @route   POST /api/banquet-requests
const submitBanquetRequest = async (req, res) => {
  try {
    // The request body should match the schema
    const newRequest = new BanquetRequest(req.body);
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

export  { submitBanquetRequest };
