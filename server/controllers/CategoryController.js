import Category from "../models/Category.js";

const getCategories = async (req, res) => {
  try {
    const categories = await Category.find();
    res.json(categories);
  } catch (err) {
    res.status(500).json({ message: "Server Error" });
  }
};


const addCategory = async (req, res) => {
  try {
    const { name, image } = req.body;

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


const seedCategories = async (req, res) => {
  try {
    await Category.deleteMany({}); 
    
    const initialCategories = [
  {
    "name": "BANQUETS & VENUES",
    "image": "https://images.unsplash.com/photo-1523580494863-6f3031224c94?q=80&w=2070&auto=format&fit=crop"
  },
  {
    "name": "Travel & Stay",
    "image": "https://images.unsplash.com/photo-1439130490301-25e322d88054?q=80&w=1932&auto=format&fit=crop"
  },
 
  {
    "name": "Corporate Events",
    "image": "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?q=80&w=2070&auto=format&fit=crop"
  },

  {
      "name": "Music & Entertainment",
      "image": "https://images.unsplash.com/photo-1511379938547-c1f69419868d?q=80&w=2070&auto=format&fit=crop"
  }
];
 

    await Category.insertMany(initialCategories);
    res.status(201).json({ message: "Categories seeded successfully!" });
  } catch (err) {
    res.status(500).json({ message: "Server Error", error: err.message });
  }
};


export { getCategories, seedCategories, addCategory };
