const express = require("express")
const router = express.Router()
const persistence = require("../services/persistence")

// define the home page route
router.get('/', function (req, res) {
  res.send('Info')
  persistence.save();
})

module.exports = router
