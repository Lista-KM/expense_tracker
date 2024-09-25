const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

// Callback endpoint
app.post('/callback', (req, res) => {
  console.log('Received callback:', req.body);
  // Handle the response from MPesa here
  // e.g., update your database with payment status
  
  // Respond to MPesa
  res.status(200).send('Callback received');
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
