import mongoose from 'mongoose';

const categorySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Category name is required'],
      trim: true,
      unique: true, // prevent duplicate category names
    },
    image: {
      type: String,
      required: [true, 'Category image is required'],
    },
  },
  { timestamps: true } // adds createdAt & updatedAt
);

const Category = mongoose.model('Category', categorySchema);

export default Category;
