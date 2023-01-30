// TODO ERROR & RESPONSE HANDLING
const port = 3000; // API Port
const dbusername = "postgres"; // User name
const dbpassword = "1899"; // Password
const dbhost = "localhost"; // Database address
const dbport = "5432"; // Database port
const dbname = "tg2"; // Database name

const express = require('express');
const http = require("http");
const fs = require("fs");
const path = require("path");
const url = require("url");
const fileUpload = require('express-fileupload');
const pgp = require('pg-promise')
const bodyParser = require('body-parser');

const app = express();
const connection = pgp()('postgres://' + dbusername + ":" + dbpassword + "@" + dbhost + ":" + dbport + "/" + dbname)

app.use(bodyParser.json());
app.use('/img', express.static('assets/img'));
app.use(
    fileUpload({
      limits: {
        fileSize: 10000000, // Around 10MB
      },
      abortOnLimit: true,
    })
);
app.listen(port, () => {
  console.log(`Server listening on the port  ${port}`);
})

// Creating server to accept image request
http.createServer((req, res) => {

  // Parsing the URL
  const request = url.parse(req.url, true);

  // Extracting the path of file
  const action = request.pathname;

  // Path Refinements
  const filePath = path.join(__dirname,
      action).split("%20").join(" ");

  // Checking if the path exists
  fs.exists(filePath, function (exists) {

    if (!exists) {
      res.writeHead(404, { "Content-Type": "text/plain" });
      res.end("404 Not Found");
      return;
    }

    // Extracting file extension
    const ext = path.extname(action);

    // Setting default Content-Type
    let contentType = "text/plain";

    // Switch Content-Type based on file extension
    switch (ext) {
      case '.png': contentType = 'image/png'; break;
      case '.jpg': contentType = 'image/jpg'; break;
      case '.jpeg': contentType = 'image/jpeg'; break;
    }

    // Setting the headers
    res.writeHead(200, { "Content-Type": contentType });

    // Reading the file
    fs.readFile(filePath, function (err, content) {
      // Serving the image
      res.end(content);
    });
  });
})

// ROOT
app.get('/', (req, res) => {
  res.json(app.settings)
});

// PASSPORT
app.post('/passport', (req, res) => {

  // Get the file that was set to our field named "image"
  const { image } = req.files;
  const { name } = req.body;
  image.name = name + '.png'

  // If no image submitted, exit
  if (!image) return res.sendStatus(400);

  /*
  // If does not have image mime type prevent from uploading
  if (/^image/.test(image.mimetype)) return res.sendStatus(400);

   */

  // Move the uploaded image to passport folder
  image.mv(__dirname + '/assets/passports/' + image.name);

  // All good
  res.sendStatus(200);
});

// COUNTRY
app.get('/country', (req, res) => connection.any('SELECT * FROM country')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// STADIUM
app.get('/stadium', (req, res) => connection.any('SELECT * FROM stadium')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// CLUB
app.get('/club', (req, res) => connection.any('SELECT * FROM club')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// MATCH
app.get('/match', (req, res) => connection.any('SELECT * FROM match')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// PLAYER
app.get('/player', (req, res) => connection.any('SELECT * FROM player')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// SCHOOLING
app.get('/schooling', (req, res) => connection.any('SELECT * FROM schooling')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// EXAM
app.get('/exam', (req, res) => connection.any('SELECT * FROM exam')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
)
app.post('/exam', (req,res) => {
  const { player_id, date, result } = req.body
  connection.none('INSERT INTO exam(player_id, date, result) VALUES($/player_id/, $/date/, $/result/)', {
    player_id: player_id,
    date: date,
    result: result
  })
      .then(r => res.json(r))
      .catch((error) => console.log('ERROR:', error));

});
app.patch('/exam', (req,res) => {
  const { id, player_id, date, result } = req.body
  connection.none('UPDATE exam SET player_id = $/player_id/, date = $/date/, result = $/result/ WHERE id = $/id/', {
    id: id,
    player_id: player_id,
    date: date,
    result: result
  })
      .then(r => res.json(r))
      .catch((error) => console.log('ERROR:', error));

});
app.delete('/exam', (req,res) => {
  const { id } = req.body
  connection.none('DELETE FROM exam WHERE id = $/id/', {
    id: id,
  })
      .then(r => res.json(r))
      .catch((error) => console.log('ERROR:', error));
});

// POSITION
app.get('/position', (req, res) => connection.any('SELECT * FROM position')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// CONTRACTS
app.get('/contract', (req, res) => connection.any('SELECT * FROM contract')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);
app.post('/contract', (req,res) => {
  const { player_id, club_id, number, position_id, period, document } = req.body
  connection.none(
      'INSERT INTO contract(player_id, club_id, number, position_id, period, document) ' +
      'VALUES($/player_id/, $/club_id/, $/number/, $/position_id/, $/period/, $/document/)',
      {
        player_id: player_id,
        club_id: club_id,
        number: number,
        position_id: position_id,
        period: period,
        document: document,
      })
      .then(r => res.json(r))
      .catch((error) => console.log('ERROR:', error));

});
app.delete('/contract', (req,res) => {
  const { id } = req.body
  connection.none('DELETE FROM contract WHERE id = $/id/', {
    id: id,
  })
      .then(r => res.json(r))
      .catch((error) => console.log('ERROR:', error));
});
