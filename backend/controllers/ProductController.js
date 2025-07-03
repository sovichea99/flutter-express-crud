const {poolPromise, sql} = require('../db');

//GET all products
exports.getAllProducts = async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("SELECT * FROM PRODUCTS");
        res.status(200).json(result.recordset);
    }catch(error){
        console.error("Error fetching products: ", error);
        res.status(500).json({error: "Failed to fetch products!"})
    }
}

//GET product by ID
exports.getProductById = async (req, res) => {
    try {
        const { id } = req.params;
        const pool = await poolPromise;
        const result = await pool
        .request()
        .input("id", sql.Int, id)
        .query("SELECT * FROM PRODUCTS WHERE PRODUCTID = @id");
        if(result.recordset.length === 0){
            return res.status(404).json({error: "Product not found!"});
        }
        res.status(200).json(result.recordset[0]);
    }  catch (err) {
    res.status(500).json({ error: err.message });
  }
}

//POST create a new product
exports.addProduct = async (req, res) => {
    try {
        const {productName, price, stock} = req.body;
        if (!productName || price <= 0 || stock <= 0){
            return res.status(400).json({error: 'Invalid input!'});
        }
        const pool = await poolPromise;
        await pool 
        .request()
        .input("name", sql.NVarChar(100), productName)
        .input("price", sql.Decimal(10,2), price)
        .input("stock", sql.Int, stock)
        .query("INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) VALUES (@name, @price, @stock)");
       
        res.status(201).json({message: 'Product created successfully!'});
    }catch (err){
        res.status(500).json({error: "Failed to create product!"});
    }
}

//PUT update a product
exports.updateProduct = async (req, res) => {
    try {
        const { id } = req.params;
        const { productName, price, stock } = req.body;

         if (!productName || price <= 0 || stock <= 0) {
            return res.status(400).json({ error: 'Invalid input! Product name cannot be empty, and price/stock must be positive.' });
        }

        const pool = await poolPromise;
        await pool
        .request()
        .input("id", sql.Int, id)
        .input("name", sql.NVarChar(100), productName)
        .input("price", sql.Decimal(10,2), price)
        .input("stock", sql.Int, stock)
        .query("UPDATE PRODUCTS SET PRODUCTNAME = @name, PRICE = @price, STOCK = @stock WHERE PRODUCTID = @id");
        res.status(200).json({message: 'Product updated successfully!'});
    }catch (err){
        res.status(500).json({error: "Failed to update product!"});
    }
}

//DELETE remove a product
exports.deleteProduct = async (req, res) => {
    try {
        const { id } = req.params;
        const pool = await poolPromise;
        await pool
        .request()
        .input("id", sql.Int, id)
        .query("DELETE FROM PRODUCTS WHERE PRODUCTID = @id");

        res.status(204).json({message: 'Product deleted successfully!'});
    } catch (err) {
        res.status(500).json({error: "Failed to delete product!"});
    }
}