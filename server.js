require("dotenv").config();
const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Environment variables
const API_KEY = process.env.API_KEY || "default-api-key";
const NODE_ENV = process.env.NODE_ENV || "development";

// Endpoint 1: Health check
app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    environment: NODE_ENV,
    timestamp: new Date().toISOString(),
  });
});

// Endpoint 2: API info
app.get("/api/info", (req, res) => {
  res.json({
    message: "API is running",
    apiKey: API_KEY.substring(0, 4) + "...", // Show only first 4 chars for security
    port: PORT,
    environment: NODE_ENV,
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Environment: ${NODE_ENV}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`API info: http://localhost:${PORT}/api/info`);
});
