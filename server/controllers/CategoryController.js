import Category from "../models/Category.js";

// @desc    Get all categories for the home screen
// @route   GET /api/categories
const getCategories = async (req, res) => {
  try {
    const categories = await Category.find();
    res.json(categories);
  } catch (err) {
    res.status(500).json({ message: "Server Error" });
  }
};

// @desc    Add a new category
// @route   POST /api/categories
const addCategory = async (req, res) => {
  try {
    const { name, image } = req.body;

    // Basic validation
    if (!name || !image) {
      return res
        .status(400)
        .json({ message: "Please provide a name and an image." });
    }

    const newCategory = new Category({
      name,
      image,
    });

    const savedCategory = await newCategory.save();
    res.status(201).json(savedCategory);
  } catch (err) {
    res.status(500).json({ message: "Server Error", error: err.message });
  }
};

// @desc    Seed initial category data (for setup)
// @route   POST /api/categories/seed
const seedCategories = async (req, res) => {
  try {
    await Category.deleteMany({}); // Clear existing categories

    const initialCategories = [
      { name: "Travel & Stay", image: "https://i.imgur.com/example1.jpg" },
      { name: "BANQUETS & VENUES", image: "https://i.imgur.com/example2.jpg" },
      { name: "Retail stores & Shops", image: "https://i.imgur.com/example3.jpg" },
    ];

    await Category.insertMany(initialCategories);
    res.status(201).json({ message: "Categories seeded successfully!" });
  } catch (err) {
    res.status(500).json({ message: "Server Error", error: err.message });
  }
};

export { getCategories, seedCategories, addCategory };
