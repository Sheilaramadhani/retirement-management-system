const express = require('express');
const { Server } = require('ws');
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://retirement-management-system-default-rtdb.firebaseio.com'
});

// Create an Express.js app
const app = express();

// Define your API endpoints

// Example endpoint: Suggest investment firms based on user preferences
app.get('/api/suggest-investment-firms', (req, res) => {
  // Access the Firestore database
  const db = admin.firestore();

  // Extract user preferences from the request query parameters
  const { location, minimumInvestment } = req.query;

  // Query the investment firms collection based on user preferences
  let query = db.collection('investmentFirms');

  // Filter by location if provided
  if (location) {
    query = query.where('location', '==', location);
  }

  // Filter by minimum investment if provided
  if (minimumInvestment) {
    query = query.where('minimumInvestment', '>=', parseInt(minimumInvestment, 10));
  }

  // Execute the query
  query
    .get()
    .then((snapshot) => {
      // Process the query snapshot and extract the suggested investment firms
      const suggestedFirms = [];
      snapshot.forEach((doc) => {
        const firm = doc.data();
        suggestedFirms.push(firm);
      });
      // Send the suggested investment firms as a response
      res.json(suggestedFirms);
    })
    .catch((error) => {
      console.log('Error suggesting investment firms:', error);
      res.status(500).send('Internal Server Error');
    });
});

// Example endpoint: Add a new investment firm
app.post('/api/investment-firms', (req, res) => {
  // Access the Firestore database
  const db = admin.firestore();

  // Extract the firm details from the request body
  const { name, description, location, minimumInvestment } = req.body;

  // Create a new document in the investment firms collection
  const firmData = { name, description, location, minimumInvestment };
  db.collection('investmentFirms')
    .add(firmData)
    .then((docRef) => {
      // Send the ID of the newly created firm as a response
      res.status(201).json({ id: docRef.id });
    })
    .catch((error) => {
      console.log('Error creating investment firm:', error);
      res.status(500).send('Internal Server Error');
    });
});

// Start the Express.js server
const port = process.env.PORT || 3000; // Choose a port number
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// Start the WebSocket server
const wss = new Server({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected');
  ws.on('message', (message) => console.log(`Received: ${message}`));
  ws.on('close', () => console.log('Client disconnected'));
});
