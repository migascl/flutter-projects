// TODO IMPLEMENT CRUD
// TODO IMPLEMENT CRUD FOR IMAGE FILES

const bodyParser = require('body-parser');

const express = require('express')();
express.use(bodyParser.json());
const port = 3000;

const pgp = require('pg-promise')()
const dbusername = "postgres";
const dbpassword = "1899";
const dbhost = "localhost";
const dbport = "5432";
const dbname = "tg2";
const connection = pgp('postgres://' + dbusername + ":" + dbpassword + "@" + dbhost + ":" + dbport + "/" + dbname)

express.listen(port, () => {
    console.log(`Server listening on the port  ${port}`);
})

express.get('/', (req, res) => {
    res.json(express.settings)
});

express.get('/country', (req, res) => connection.any('SELECT * FROM country')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/stadium', (req, res) => connection.any('SELECT * FROM stadium')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/club', (req, res) => connection.any('SELECT * FROM club')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/match', (req, res) => connection.any('SELECT * FROM match')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/player', (req, res) => connection.any('SELECT * FROM player')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/schooling', (req, res) => connection.any('SELECT * FROM schooling')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/exam', (req, res) => connection.any('SELECT * FROM exam')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);
express.post('/exam', (req,res) => {
    const { player_id, date, result } = req.body
    connection.none('INSERT INTO exam(player_id, date, result) VALUES($/player_id/, $/date/, $/result/)', {
        player_id: player_id,
        date: date,
        result: result
    }).then(r => res.status(200));

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
    }).then(r => res.json(r));

});

express.get('/position', (req, res) => connection.any('SELECT * FROM position')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);

express.get('/contract', (req, res) => connection.any('SELECT * FROM contract')
    .then((data) => res.json(data))
    .catch((error) => console.log('ERROR:', error))
);
