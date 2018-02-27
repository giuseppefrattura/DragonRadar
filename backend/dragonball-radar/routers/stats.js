const express = require("express")
const router = express.Router()
const persistence = require("../services/persistence")
const bodyParser = require('body-parser')
const jsonParser = bodyParser.json()

// define the home page route
router.get('/', function (req, res) {
  res.send(persistence.getCurrentStats())
})

module.exports = router
