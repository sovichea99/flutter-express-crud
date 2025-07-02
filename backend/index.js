const express = require("express");
const cors = require("cors");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());

const productRoutes = require("./routes/ProductRoutes");
app.use("/products", productRoutes)

const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=> console.log(`Server is running on port ${PORT}`));