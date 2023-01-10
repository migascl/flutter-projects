// TODO IMPLEMENT CRUD
// TODO IMPLEMENT ASSET FETCHING

const bodyParser = require('body-parser');

const express = require('express')();
express.use(bodyParser.json());
const port = 3000;

const pgp = require('pg-promise')()
const dbusername = "postgres"; // User name
const dbpassword = "1899"; // Password
const dbhost = "localhost"; // Database address
const dbport = "5432"; // Database port
const dbname = "tg2"; // Database name
const connection = pgp('postgres://' + dbusername + ":" + dbpassword + "@" + dbhost + ":" + dbport + "/" + dbname)

express.listen(port, () => {
    console.log(`Server listening on the port  ${port}`);
})

// ROOT
express.get('/', (req, res) => {
    res.json(express.settings)
});

// COUNTRY
express.get('/country', (req, res) => connection.any('SELECT * FROM country')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// STADIUM
express.get('/stadium', (req, res) => connection.any('SELECT * FROM stadium')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// CLUB
express.get('/club', (req, res) => connection.any('SELECT * FROM club')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// MATCH
express.get('/match', (req, res) => connection.any('SELECT * FROM match')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// PLAYER
express.get('/player', (req, res) => connection.any('SELECT * FROM player')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// SCHOOLING
express.get('/schooling', (req, res) => connection.any('SELECT * FROM schooling')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// EXAM
express.get('/exam', (req, res) => connection.any('SELECT * FROM exam')
    .then((data) => res.json(data)) 
    .catch((error) => console.log('ERROR:', error))
)
express.post('/exam', (req,res) => {
    const { player_id, date, result } = req.body
    connection.none('INSERT INTO exam(player_id, date, result) VALUES($/player_id/, $/date/, $/result/)', {
        player_id: player_id,
        date: date,
        result: result
    }).then(r => res.json(r));

});
express.patch('/exam', (req,res) => {
    const { id, player_id, date, result } = req.body
    connection.none('UPDATE exam SET player_id = $/player_id/, date = $/date/, result = $/result/ WHERE id = $/id/', {
        id: id,
        player_id: player_id,
        date: date,
        result: result
    }).then(r => res.json(r));

});
express.delete('/exam', (req,res) => {
    const { id } = req.body
    connection.none('DELETE FROM exam WHERE id = $/id/', {
        id: id,
    }).then(r => res.json(r))

});

// POSITION
express.get('/position', (req, res) => connection.any('SELECT * FROM position')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

// CONTRACTS
express.get('/contract', (req, res) => connection.any('SELECT * FROM contract')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);
