const express = require("express")
const router = express.Router()
const mongoPersistence = require("../services/mongo.js")
const bodyParser = require('body-parser')
const jsonParser = bodyParser.json()

router.get('/', function (req, res) {
  console.log('Get map');
  mongoPersistence.getCurrentMap(function(item) {
        res.send(item)
    });
});

router.put('/', jsonParser, function(req, res) {
  const body = req.body;

  if(!body.map || !body.map.spheres || !body.map.spheres.length ){
    return res.status(400).send({msg: 'you are bad! body has to contain map : { spheres: ... } '})
  }

  mongoPersistence.saveNewMap(req.body, function(err, item) {
    res.send(err || item);
  })
})


module.exports = router
