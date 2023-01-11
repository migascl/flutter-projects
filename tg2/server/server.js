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
const pgp = require('pg-promise')
const bodyParser = require('body-parser');

const app = express();
const connection = pgp()('postgres://' + dbusername + ":" + dbpassword + "@" + dbhost + ":" + dbport + "/" + dbname)

app.use(bodyParser.json());
app.use('/img', express.static('assets/img'));

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
    }).then(r => res.json(r));

});
app.patch('/exam', (req,res) => {
    const { id, player_id, date, result } = req.body
    connection.none('UPDATE exam SET player_id = $/player_id/, date = $/date/, result = $/result/ WHERE id = $/id/', {
        id: id,
        player_id: player_id,
        date: date,
        result: result
    }).then(r => res.json(r));

});
app.delete('/exam', (req,res) => {
    const { id } = req.body
    connection.none('DELETE FROM exam WHERE id = $/id/', {
        id: id,
    }).then(r => res.json(r))

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
