const mongoose = require('mongoose');

const banquetRequestSchema = new mongoose.Schema({
    eventType: { type: String, required: true }, // [cite: 26]
    country: { type: String, required: true }, // [cite: 28]
    state: { type: String, required: true }, // [cite: 31]
    city: { type: String, required: true }, // [cite: 43]
    eventDates: { type: [Date], required: true }, // [cite: 45]
    numberOfAdults: { type: Number, required: true }, // [cite: 54]
    cateringPreference: { type: String }, // [cite: 55]
    cuisines: { type: [String] }, // [cite: 58]
    budget: { type: Number, required: true }, // [cite: 63]
    offerTimeframe: { type: String }, // [cite: 66]
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('BanquetRequest', banquetRequestSchema);