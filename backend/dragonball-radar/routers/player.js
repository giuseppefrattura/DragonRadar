const express = require("express")
const router = express.Router()
const persistence = require("../services/persistence")
const bodyParser = require('body-parser')
const jsonParser = bodyParser.json()

// define the home page route
router.post('/:playerName/join', jsonParser, function (req, res) {
  if (persistence.getPlayer(req.params.playerName)) {
    res.status(400).send('Already existing');
  }
  persistence.addPlayer(req.params.playerName);
  res.send(persistence.getCurrentStats())
})

router.post('/:playerName/collect/:sphereId', jsonParser, function(req, res) {
  persistence.collectSphereForPlayer(req.params.playerName, req.params.sphereId)
  var playerSpheres = persistence.getPlayer(req.params.playerName);
  var game = persistence.getCurrentMap();
  var mapIds = game.map.spheres.map(toId);
  console.dir(mapIds);
  console.dir(playerSpheres);
  var missingSpheres = mapIds.length - Object.keys(playerSpheres.spheres).length;
  playerSpheres.missingSpheres = missingSpheres;
  if (missingSpheres == 0) {
    playerSpheres.status = "completed"
  } else {
    playerSpheres.status = missingSpheres + " to go"
  }
  res.send(playerSpheres)
})

function toId(sphere) {
  return sphere.id;
}
module.exports = router
