import mongoose from 'mongoose';

const banquetRequestSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  eventType: { type: String, required: true },
  country: { type: String, required: true },
  state: { type: String, required: true },
  city: { type: String, required: true },
  eventDates: { type: [Date], required: true },
  numberOfAdults: { type: Number, required: true },
  
  cateringPreference: { type: [String] }, 
  cuisines: {
    type: [String],
    required: true
  },
  budget: { type: Number, required: true },
  offerTimeframe: { type: String },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const BanquetRequest = mongoose.model('BanquetRequest', banquetRequestSchema);

export default BanquetRequest;