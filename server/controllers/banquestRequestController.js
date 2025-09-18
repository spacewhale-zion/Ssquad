import BanquetRequest from "../models/banquestRequest.js";


const submitBanquetRequest = async (req, res) => {
  try {
     const newRequest = new BanquetRequest({
      ...req.body,
      user: req.user._id, 
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


const getAllBanquetRequests = async (req, res) => {
    try {
        const requests = await BanquetRequest.find({}).populate('user', 'name email');
        res.status(200).json(requests);
    } catch (err) {
        res.status(500).json({ message: 'Server Error', error: err.message });
    }
};

export  { submitBanquetRequest,getAllBanquetRequests};
