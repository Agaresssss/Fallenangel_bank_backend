const express = require('express');
const app = express();
const mysql = require('mysql');
//const session = require('express-session')
const path = require('path')


const cors = require('cors');


app.use(cors());
app.use(express.json());


    var db_config = {
        user: "b619d601f59301",
        host: "us-cdbr-east-05.cleardb.net",
        database: "heroku_dde927264163b31",
        password: "76bcefda",
      };
      
      var connection;
      var db;
      
      function handleDisconnect() {
        db = mysql.createConnection(db_config);                                 // Recreate the connection, since
                                                                                // the old one cannot be reused.
      
        db.connect(function (err) {
                                                                                // The server is either down
          if (err) {
                                                                                // or restarting (takes a while sometimes).
            console.log("error when connecting to db:", err);
            setTimeout(handleDisconnect, 2000);                                 // We introduce a delay before attempting to reconnect,
          }                                                                     // to avoid a hot loop, and to allow our node script to
        });                                                                     // process asynchronous requests in the meantime.
                                                                                // If you're also serving http, display a 503 error.
        db.on("error", function (err) {
          console.log("db error", err);
          if (err.code === "PROTOCOL_CONNECTION_LOST") {
                                                                                // Connection to the MySQL server is usually
            handleDisconnect();                                                 // lost due to either server restart, or a
          } else {
                                                                                // connnection idle timeout (the wait_timeout
            throw err;                                                          // server variable configures this)
          }
        });
      }
      
      handleDisconnect();
    


//-------------------------------------------------------- get zone -----------------------------------------------------------------------
app.get(`/`,(req,res)=>{
    res.send("home server")
})



app.get('/customer',(req, res) => {
    db.query("SELECT * FROM `customer-identification`",(err,result) => {
        if (err){
           res.send(err);
        }else{
           res.send(result);
        }
    });
});




//-------------------------------------------------------- view zone -----------------------------------------------------------------------

app.post('/login',(req,res)=>{
    const email = req.body.email
    const password = req.body.password
    db.query("SELECT *  FROM `customer-Identification` WHERE email = ? AND password = ?",
    [email,password],((err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    }))
})


app.post('/register/check',(req,res)=>{
    const email = req.body.email
    const citizenId = req.body.citizenId
    db.query("SELECT *  FROM `customer-Identification` WHERE email = ? AND citizenId = ?",
    [email,citizenId],((err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    }))
})

app.post('/account/check',(req,res)=>{
    const accountNum = req.body.accountNum
    db.query("SELECT Ci.fName,Ci.lName,Ba.accountNum,Ba.balance FROM `book-account`Ba,`customer-identification` Ci WHERE Ba.citizenId = Ci.citizenId AND Ba.accountNum = ?",
    [accountNum], (err,result)=>{
            if(err){
                console.log(err)
            }else{
                res.send(result)
            }
    })
})



app.post(`/transaction`,(req,res)=>{

    const citizenId = req.body.citizenId
    const month = req.body.month	
    
db.query("SELECT ba.citizenId,t.fromAccount,t.toAccount,t.value,t.`dateAndTime` FROM `transaction` t,`book-account`ba WHERE ba.`accountNum` = t.`fromAccount` AND ba.citizenId = '?' AND month(dateAndTime) = ?",
[citizenId,month],(err,result)=>{
    if(err){
        console.log(err)
        }else {
        res.send(result)
        }
    })       
})


app.post('/customer/currency/balance',(req,res)=>{
    
	
    const citizenId = req.body.citizenId
        db.query("SELECT * FROM `customer's-Foreign-Currencies` WHERE citizenId = ?",[citizenId],(err,result)=>{
            if(err){
            console.log(err)    
            }else {
            res.send(result)
            }
        })
    })
    


    app.post('/wallet',(req,res)=>{

        const citizenId = req.body.citizenId
                    
        db.query("SELECT b.`accountNum`,b.`balance`FROM`customer-Identification`c,`book-Account` b WHERE c.citizenId = b.citizenId  AND c.citizenId = ?",
        [citizenId],(err,result)=>{
                if(err){
                console.log(err)
                }else {
                res.send(result)
                }
            })
        })
        
        app.post(`/transaction-all`,(req,res)=>{

            const citizenId = req.body.citizenId
                
                db.query("SELECT t.fromAccount,t.toAccount,t.value,t.dateAndTime,t.note FROM `customer-Identification` p,`book-Account` Ba,`transaction`t WHERE p.citizenId = Ba.citizenId AND Ba.accountNum = t.fromAccount AND p.citizenId = ?",
                [citizenId],(err,result)=>{
                    if(err){
                    console.log(err)
                    }else {
                    res.send(result)
                    }
                })
            })
            

app.post(`/customer/card`,(req,res)=>{

const citizenId = req.body.citizenId
	
	db.query("SELECT Ci.citizenId,Ba.accountNum,Cc.cardId,Ct.cardType,Cc.currentLimit FROM `customer-Identification` Ci,`book-Account` Ba, `customer-Card` Cc,`card-Type` Ct WHERE Ci.citizenId = Ba.citizenId AND Ba.accountNum = Cc.accountNum AND Cc.cardTypeId = Ct.cardTypeId AND Ci.citizenId = ?",
    [citizenId],(err,result)=>{
		if(err){
		console.log(err)
		}else {
		res.send(result)
		}
	})
})

app.post(`/transaction/card`,(req,res)=>{

    const cardId= req.body.cardId        
    
        db.query("SELECT  Cc.cardId, T.toAccount, T.value, T.dateAndTime, T.note FROM `customer-Card` Cc,`book-Account` Ab,`credit-card-transaction` T WHERE Cc.cardId = T.fromCreditCardId AND T.toAccount = Ab.accountNum AND Cc.cardId = ?",
    [cardId],(err,result)=>{
            if(err){
            console.log(err)
            }else {
            res.send(result)
            }
        })
    })


app.post(`/card/subscription`,(req,res)=>{

    const cardId = req.body.cardId
    db.query("SELECT Cc.cardId,Cp.productName,Cp.monthlyPay FROM `customer-Card` Cc,`card-Subscription` Cs,`subscription-Product` Cp WHERE Cc.cardId = Cs.cardId AND Cs.subProductId = Cp.subProductId AND Cc.cardId = ?",
    [cardId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

//----------------------------------------------------------------insert zone ----------------------------------------------------------

app.post('/create',(req,res)=>{
    const prefix = req.body.prefix;
    const fName = req.body.fName;
    const lName = req.body.lName;
    const phoneNumber = req.body.phoneNumber;
    const gender = req.body.gender;
    const dob = req.body.dob;
    const citizenid = req.body.citizenid;
    const email = req.body.email;
    const password = req.body.password;
    const address = req.body.address;
    const pin = req.body.pin;
    const role = req.body.role
    db.query("INSERT INTO `customer-identification`(prefix,fName,lName,phoneNumber,gender,dob,citizenid,email,password,address,pin,role) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
    [prefix,fName,lName,phoneNumber,gender,dob,citizenid,email,password,address,pin,role],((err,result)=>{
        if(err){
            console.log(err);
        }else{
            res.send("Value inserted")
        }
    }));
})




app.post('/create/book',(req,res)=>{
    
    const citizenId = req.body.citizenId;
    const accountNum =req.body.accountNum
    

    db.query("INSERT INTO `book-account`(citizenId,accountNum) VALUES (?,?)",[citizenId,accountNum],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/create/card',(req,res)=>{
    
    const accountNum = req.body.accountNum
    const cardId = req.body.cardId

    db.query("INSERT INTO `customer-card`(cardId,accountNum) VALUES (?,?)",[cardId,accountNum],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})





//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
app.post('/getTotalCurrency',(req,res)=>{
    const citizenId = req.body.citizenId
    db.query("SELECT   FROM `customer-identification` WHERE email = ? AND password = ?",
    [citizenId],((err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    }))
})


app.post('/Currency',(req,res)=>{
    const  citizenId = req.body.citizenId
    db.query("SELECT   FROM `customer-identification` WHERE email = ? AND password = ?",
    [citizenId],((err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    }))
})
*/



//c10_OnlineBankingDB




/*
db.connect(function(err){
    if(err) throw err;
    db.query("SELECT * FROM citizen",function(err,result,fields){
        if(err) throw err;
        console.log(result);
    });
});*/

/*
const db2 = mysql2.createConnection({
    user: "cpe231_c10",
    host: "c10.cpe231.cpe.kmutt.ac.th",
    password: "5esjp9tc",
    database: "c10_OnlineBankingDB",
});

*//*
const db2 = mysql.createConnection({
    user: "root",
    host: "localhost",
    database: "angelbank"
});*/

const port = process.env.PORT || 3001
app.listen(port,() =>{
    console.log("server is running on port 3001");
})
/*
db.query("SELECT * FROM `citizen`",function(err,results){
    console.log(results);
    
   
    
});

*/



/*
const db = mysql.createConnection({
    user: "cpe231_c10",
    host: "c10.cpe231.cpe.kmutt.ac.th",
    password: "5esjp9tc",
    database: "c10_Test"
});
*/



//app.set('view engine',`ejs`)
/*app.use(session({
    secret: "session-key",
    resave: false,
    saveUninitialized: false
}))*/
/*
app.use(session({
    secret:"testsession",
    resave:true,
    saveUninitialized:true 
}))
*/


/*
app.use(express.urlencoded({extended: true}))
app.use(express.static(path.join(__dirname,'static')))
*/
/*
const db = mysql.createConnection({
    user: "root",
    host: "localhost",
    database: "angelbank"
});


app.get('/customer',(req, res) => {
    db.query("SELECT * FROM citizen",(err,result) => {
        if (err){
           console.log(err);
        }else{
           res.send(result);
        }
    });
});
*/

/*
const db = mysql.createConnection({
    user: "root",
    host: "localhost",
    database: "c10_OnlineBankingDB",
    
});
*/

/*
    const db = mysql.createConnection({
        user: "b619d601f59301",
        host: "us-cdbr-east-05.cleardb.net",
        database: "heroku_dde927264163b31",
        password:"76bcefda"
        
    });
*/