const express = require('express');
const router = express.Router();


const user = require('./user_Router.js');
const book = require('./book_Router.js');
const card = require('./card_Router.js');
const wallet = require('./wallet_Router.js');
const system = require('./system_Router.js');

router.use('/user', user);
router.use('/wallet', wallet);
router.use('/book', book);
router.use('/card', card);
router.use('/report', system);

router.get('/', (req, res,next) => {
    const welcome= "<h2>This is API for Online Banking System.</h2><p> follow MVC pattern.</p><p> edit by Phuettipol <b>11/03/2023</b></p>"
    //     res.send(welcome)
    res.send(welcome);
    next((err)=>{
        console.log(err,"next")
    })
})


module.exports = router;
