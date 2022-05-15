const express = require('express');
const app = express();
const mysql = require('mysql');
//const session = require('express-session')
const path = require('path')


const cors = require('cors');


app.use(cors());
/*app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "https://fallenangel-bank-api.herokuapp.com/"); // update to match the domain you will make the request from
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });*/
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

    const dict = "API Version 2"
    res.send(dict)
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

app.get('/list/product',(req,res)=>{
    db.query("SELECT * FROM `subscription-product`",(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})


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



app.post(`/transaction/month`,(req,res)=>{

    const citizenId = req.body.citizenId
    const month = req.body.month	
    
db.query("SELECT ba.citizenId,t.fromAccount,t.toAccount,t.value,t.`dateAndTime` FROM `transaction` t,`book-account`ba WHERE ba.`accountNum` = t.`fromAccount` AND ba.citizenId = ? AND month(dateAndTime) = ?",
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
                
                db.query("SELECT t.transactionId t.fromAccount,t.toAccount,t.value,t.dateAndTime,t.note FROM `customer-Identification` p,`book-Account` Ba,`transaction`t WHERE p.citizenId = Ba.citizenId AND Ba.accountNum = t.fromAccount AND p.citizenId = ?",
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
	
	db.query("SELECT Ci.citizenId,Ba.accountNum,Cc.cardId,Ct.cardType,Cc.currentLimit,Cc.cvv FROM `customer-Identification` Ci,`book-Account` Ba, `customer-Card` Cc,`card-Type` Ct WHERE Ci.citizenId = Ba.citizenId AND Ba.accountNum = Cc.accountNum AND Cc.cardTypeId = Ct.cardTypeId AND Ci.citizenId = ?",
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
    db.query("SELECT Cp.subProductId,Cp.productName,Cp.monthlyPay FROM `customer-Card` Cc,`card-Subscription` Cs,`subscription-Product` Cp WHERE Cc.cardId = Cs.cardId AND Cs.subProductId = Cp.subProductId AND Cc.cardId = ?",
    [cardId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post(`/check/product`,(req,res)=>{

    const subProductId = req.body.subProductId
    db.query("SELECT * FROM `subscription-product` WHERE subProductId = ?",
    [subProductId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/check/kyc',(req,res)=>{
    const email = req.body.email
    const password = req.body.password
    db.query("SELECT kycStatus FROM `customer-identification` WHERE email = ? AND password = ?",
    [email,password],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/check/card',(req,res)=>{
    const cardId = req.body.cardId
    db.query("SELECT cardId,currentLimit FROM `customer-card` WHERE cardId = ?",[cardId],(err,result)=>{
            if(err){
                console.log(err)
            }else{
                res.send(result)
            }
    })
})

//----------------------------------------------------------------insert zone ----------------------------------------------------------

app.post('/register',(req,res)=>{
    const prefix = req.body.prefix;
    const fName = req.body.fName;
    const lName = req.body.lName;
    const phoneNumber = req.body.phoneNumber;
    const gender = req.body.gender;
    const dob = req.body.dob;
    const citizenId = req.body.citizenId;
    const email = req.body.email;
    const password = req.body.password;
    const address = req.body.address;
    const pin = req.body.pin;
    db.query("INSERT INTO `customer-identification`(prefix,fName,lName,phoneNumber,gender,dob,citizenId,email,password,address,pin) VALUES(?,?,?,?,?,?,?,?,?,?,?)",
    [prefix,fName,lName,phoneNumber,gender,dob,citizenId,email,password,address,pin],((err,result)=>{
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
    const cvv = Math.floor(Math.random() * (999 - 100 +1)) + 100
    db.query("INSERT INTO `customer-card`(cardId,accountNum,cvv) VALUES (?,?,?)",[cardId,accountNum,cvv],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/create/transaction',(req,res)=>{
    
    const fromAccount = req.body.fromAccount
    const toAccount = req.body.toAccount
    const value = req.body.value
    const note = req.body.note
    const categoryId = req.body.categoryId
    const transactionTypeId = req.body.transactionTypeId

    db.query("INSERT INTO `transaction`(fromAccount,toAccount,value,note,categoryId,transactionTypeId) VALUES (?,?,?,?,?,?)",
    [fromAccount,toAccount,value,note,categoryId,transactionTypeId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/create/transaction/card',(req,res)=>{
    
    const fromCreditCardId = req.body.fromCreditCardId
    const value = req.body.value
    const note = req.body.note
    const categoryId = req.body.categoryId
    const transactionTypeId = req.body.transactionTypeId
    const PaymentDueDate = req.body.PaymentDueDate
    const InstallmentPlan = req.body.InstallmentPlan 
    const Interest = req.body.Interest

    db.query("INSERT INTO `credit-card-transaction`(fromCreditCardId,value,note,categoryId,transactionTypeId,PaymentDueDate,InstallmentPlan,Interest) VALUES (?,?,?,?,?,?,?,?)",
    [fromCreditCardId,value,note,categoryId,transactionTypeId,PaymentDueDate,InstallmentPlan,Interest],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})


app.post('/create/customer/foreign/currencies',(req,res)=>{
    
    const citizenId = req.body.citizenId
    const currencyId = req.body.currencyId
    const balanceCurrency = req.body.balanceCurrency

    db.query("INSERT INTO `customer's-foreign-currencies`(citizenId,currencyId,balanceCurrency) VALUES (?,?,?)",
    [citizenId,currencyId,balanceCurrency],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/create/transaction/currency',(req,res)=>{
    const citizenId = req.body.citizenId
    const fromCurrency = req.body.fromCurrency
    const toCurrency = req.body.toCurrency
    const value = req.body.value
    const note = req.body.note
    const rate = req.body.rate
    const fee = req.body.fee
    

    db.query("INSERT INTO `currency-exchange-transaction`(citizenId,fromCurrency,toCurrency,value,note,rate,fee) VALUES (?,?,?,?,?,?,?)",
    [citizenId,fromCurrency,toCurrency,value,note,rate,fee],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})


app.post('/create/card/subscription',(req,res)=>{
    
    const cardId = req.body.cardId
    const subProductId = req.body.subProductId

    db.query("INSERT INTO `card-subscription`(cardId,subProductId) VALUES (?,?)",
    [cardId,subProductId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.post('/create/product',(req,res)=>{
    
    const subProductId = req.body.subProductId
    const monthlyPay = req.body.monthlyPay
    const productName = req.body.productName

    db.query("INSERT INTO `subscription-product`(subProductId,monthlyPay,productName) VALUES (?,?,?)",
    [subProductId,monthlyPay,productName],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})




//------------------------------------update zone----------------------------------------------------

app.put('/update/balance',(req,res)=>{
    const accountNum = req.body.accountNum
    const balance = req.body.balance
    db.query("UPDATE `book-account` SET balance = ? WHERE accountNum = ?",[balance,accountNum],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.put('/update/currency/balance',(req,res)=>{
    const citizenId = req.body.citizenId
    const currencyId = req.body.currencyId
    const balanceCurrency = req.body.balanceCurrency
    db.query("UPDATE `customer's-foreign-currencies` SET balanceCurrency = ? WHERE citizenId = ? AND currencyId = ? ",[balanceCurrency,citizenId,currencyId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})

app.put(`/update/card/currentlimit`,(req,res)=>{
    const cardId = req.body.cardId
    const currentLimit = req.body.currentLimit
    db.query("UPDATE `customer-card` SET currentLimit = ? WHERE cardId = ?",
    [currentLimit,cardId],(err,result)=>{
            if(err){
                console.log(err)
            }else{
                res.send(result)
            }
    })
})

app.put('/update/kyc',(req,res)=>{
    const citizenId = req.body.citizenId
    
    db.query("UPDATE `customer-identification` SET kycStatus = 1 WHERE citizenId = ?",
    [citizenId],(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})
//--------------------- delete zone------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------- Analytic report zone-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

app.get('/report/citizenId/account/currency',(req,res)=>{
    db.query("SELECT Ci.citizenId, count(DISTINCT currencyId) as numberOfCurrency, count(DISTINCT accountNum) as numberOfAccount FROM `customer-identification` Ci LEFT JOIN `book-account` Ba ON Ba.citizenId = Ci.citizenId LEFT JOIN `customer's-foreign-currencies` Cc ON Cc.citizenId = Ci.citizenId GROUP BY Ci.citizenId;",
    (err,result)=>{
        if(err){
            console.log(err)
            
        }else{
            res.send(result)
        }
    })
})

app.post('/report/citizenid/spend/month',(req,res)=>{

    const citizenId = req.body.citizenId
    db.query("SELECT bc.accountNum,ct.category,sum(t.`value`) AS totalValue FROM `book-Account` bc, `category-Type` ct, `transaction` t WHERE bc.accountNum = t.fromAccount AND ct.categoryId = t.categoryId AND bc.citizenId = ? GROUP BY (ct.category) ORDER BY (totalValue) DESC",
    [citizenId],(err,result)=>{
        if(err){
            console.log(err)
            
        }else{
            res.send(result)
        }
    })
})

app.get('/report/admin/card/all-user/spend',(req,res)=>{
    db.query("SELECT cc.cardId, sum(cct.`value`) as totalValue, ct.monthlyLimit, (sum(cct.`value`) / ct.monthlyLimit) * 100 AS percentToUse FROM `customer-card` cc, `credit-card-transaction` cct, `card-type` ct WHERE cc.cardId = cct.fromCreditCardId AND cc.cardTypeId = ct.cardTypeId GROUP BY (cc.cardId) ORDER BY(percentToUse) DESC",
(err,result)=>{
        if(err){
            console.log(err)
            
        }else{
            res.send(result)
        }
    }) 
})

app.get('/report/admin/totalbalance/currency',(req,res)=>{
    db.query("SELECT cc.cardId,sum(cct.`value`) as totalValue,ct.monthlyLimit, (sum(cct.`value`) / ct.monthlyLimit) * 100 AS percentToUse FROM `customer-card` cc, `credit-card-transaction` cct, `card-type` ct WHERE cc.cardId = cct.fromCreditCardId AND cc.cardTypeId = ct.cardTypeId GROUP BY (cc.cardId) ORDER BY(percentToUse) DESC",
(err,result)=>{
        if(err){
            console.log(err)
        }else{
            res.send(result)
        }
    })
})
///---------------------------------------------------------------------------------------------------------------------------------------------
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