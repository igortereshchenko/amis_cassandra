const async = require('async');
const connection = require('../../server/bin/connection')();
const consistency = connection.getDriver().types.consistencies;

const uuid = connection.getDriver().types.Uuid;
const app = require('../../server/server');
const keyspace = app.get('keyspace');
const client = connection.getClient();
client.keyspace = keyspace;

module.exports =  function(Bankoperation) {
    Bankoperation.create = ( userId, bankId, creditId, remaining, userBalAcc, opDate,  cb) => {
        const bankOpId = uuid.random();
        const date = new Date();
        async.series([
            (callback) => {
                if ((userId && bankId && creditId && !remaining && userBalAcc)) {
                    const result = lastCreditInfo(userId, bankId, creditId)
                    result.then((data) => {
                        callback(null, data[0]);
                    }).catch((err) => {
                        callback(err, null);
                    })
                } else {
                    callback(null, null);
                }
            }
        ],
        function(err, results) {
            if (remaining) remaining = remaining;
            // console.log("Remaining 1", remaining);
            if (!remaining && results && results[0] && results[0].remaining && userBalAcc) {
                remaining =parseInt(results[0].remaining) - parseInt(userBalAcc);
                // console.log("Remaining 2", remaining);
            }

            if (!remaining && !userBalAcc) remaining = 0;
            // console.log("Remaining 2", remaining);
            // console.log("userBalAcc 1", userBalAcc);
            if (!userBalAcc) userBalAcc=0;
            // console.log("userBalAcc 2", userBalAcc);

            const bankOperation = {
                bank_operation_id: bankOpId,
                bank_id: bankId,
                user_id: userId,
                credit_id: creditId,
                remaining: parseInt(remaining),
                user_balance_account: userBalAcc,
                operation_date: date
            }

            // console.log("bankOperation", bankOperation);

            const result = createBankOperation(bankOperation, connection);
            result.then((data) => {
                cb(null, bankOperation);
            }).catch((err) => {
                cb(err, null);
            })

        });

    };

    Bankoperation.findAll = (cb)  => {
        const result = findBankOperations(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findWishLists = (cb)  => {
        const result = findWishLists(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findCredits = (cb)  => {
        const result = findAllCredits(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.countUserBanks = (cb)  => {
        const result = countUserBank(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.deleteById = (bankOpId, cb)  => {
        const result = deleteBankOperation(bankOpId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findPayingProcess = (userId, cb)  => {
        const result = findPayingProcess(userId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findAllbyBankId = (bankId, cb)  => {
        const result = findAllyBankId(bankId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findAllbyCreditId = (creditId, cb)  => {
        // console.log("findAllbyCreditId", creditId);
        const result = findAllyCreditId(creditId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findClosedCredits = (userId, cb)  => {
        const result = findClosedCredits(userId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.findNewCredits = (userId, cb)  => {
        const result = findNewCredits(userId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.updateById = (bankOpId, userId, bankId, creditId, remaining, userBalAcc, opDate, cb)  => {
        const bankOperation = {
            bank_id: bankId,
            user_id: userId,
            credit_id: creditId,
            remaining: remaining,
            user_balance_account: userBalAcc,
            operation_date: opDate
        }
        const result = updateBankOperation(bankOpId, bankOperation, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.bankMoneyInfo = (bank_id, cb)  => {

        const result = groupBySum(bank_id, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.userBanks = (userId, cb)  => {
        const result = groupBy(userId, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bankoperation.remoteMethod('create', {
        accepts: [
            {arg: 'userId', type: 'string'},
            {arg: 'bankId', type: 'string'},
            {arg: 'creditId', type: 'string'},
            {arg: 'remaining', type: 'number'},
            {arg: 'userBalAcc', type: 'number'},
            {arg: 'opDate', type: 'date'}
        ],
        http: {verb: 'post'},
        returns: {type: 'object', root: true},
    });

    Bankoperation.remoteMethod('findAll', {
        accepts: [],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('bankMoneyInfo', {
        accepts: [
             {arg: 'bankId', type: 'string'},
        ],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('findAllbyBankId', {
        accepts: [
             {arg: 'bankId', type: 'string'},
        ],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('findAllbyCreditId', {
        accepts: [
             {arg: 'creditId', type: 'string'},
        ],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('userBanks', {
        accepts: [
             {arg: 'userId', type: 'string'},
        ],
        http: {verb: 'get'},
        returns: {type: 'object', root: true},
    });


    Bankoperation.remoteMethod('findWishLists', {
        accepts: [],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('findCredits', {
        accepts: [],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('deleteById', {
        accepts: [{arg: 'bankOpId', type: 'string'}],
        http: {verb: 'delete'},
        returns: {type: 'object', root: true},
    });

    Bankoperation.remoteMethod('findClosedCredits', {
        accepts: [{arg: 'userId', type: 'string'}],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('findNewCredits', {
        accepts: [{arg: 'userId', type: 'string'}],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('findPayingProcess', {
        accepts: [{arg: 'userId', type: 'string'}],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bankoperation.remoteMethod('updateById', {
        accepts: [
                {arg: 'bankOpId', type: 'string'},
                {arg: 'userId', type: 'string'},
                {arg: 'bankId', type: 'string'},
                {arg: 'creditId', type: 'string'},
                {arg: 'remaining', type: 'number'},
                {arg: 'userBalAcc', type: 'number'},
                {arg: 'opDate', type: 'date'}
            ],
        http: {verb: 'put'},
        returns: {type: 'object', root: true},
    });

};

function createBankOperation(bankOperation, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .insert(bankOperation)
            .from('bankoperation')
            .exec({consistency:consistency.quorum}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result){
                        resolve(result);
                    } else {
                        resolve([]);
                    }
                }
        })
    });
}

function findBankOperations(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function deleteBankOperation(bankOpId, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .delete()
            .from("bankoperation")
            .where('bank_operation_id','=',bankOpId)
            .exec({consistency:consistency.quorum}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result){
                        resolve(result);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function updateBankOperation(bankOpId, body, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .update("bankoperation")
            .set('user_id',body.user_id)
            .set('bank_id',body.bank_id)
            .set('credit_id',body.credit_id)
            .set('remaining',body.remaining)
            .set('user_balance_account',body.user_balance_account)
            .set('operation_date',body.operation_date)
            .where('bank_operation_id','=',bankOpId)
            .exec({consistency:consistency.quorum}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result){
                        resolve(result);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findWishLists(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("remaining","=",0)
            .where("user_balance_account","=",0)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findAllCredits(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("user_balance_account","=",0)
            .where("remaining",">",0)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findClosedCredits(userId, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("user_id","=",userId)
            .where("remaining","=",0)
            .where("user_balance_account",">",0)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findNewCredits(userId, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("user_id","=",userId)
            .where("user_balance_account","=",0)
            .where("remaining",">",0)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findPayingProcess(userId, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("user_id","=",userId)
            .where("user_balance_account",">",0)
            .where("remaining",">",0)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findAllyBankId(bankId, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("bank_id","=",bankId)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findAllyCreditId(creditId, connection) {
    return new Promise( (resolve, reject) => {
        // console.log("creditId",creditId);
        connection(keyspace)
            .select("*")
            .where("credit_id","=",creditId)
            .allowFiltering()
            .from('bankoperation')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows);
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function groupBySum(bank_id, connection) {
    return new Promise( (resolve, reject) => {
        const query = 'SELECT groupBySum(credit_id,user_balance_account,remaining) FROM bankOperation WHERE bank_id = ?';
        client.execute(query, [bank_id], { prepare: true, consistency:consistency.quorum }, function(err, result) {
            if (err) reject(err);
            if (result && result.rows ) resolve(result.rows);
            else resolve([0,0]);
        });
  });
}

function groupBy(user_id, connection) {
  return new Promise( (resolve, reject) => {
      const query = 'SELECT groupBy(bank_id,credit_id,user_balance_account,remaining) FROM bankOperation WHERE user_id = ?';
      client.execute(query, [user_id], { prepare: true, consistency:consistency.quorum }, function(err, result) {
          if (err) reject(err);
          resolve(result);
      });
  });
}

function lastCreditInfo(user_id, bank_id, credit_id, connection) {
  return new Promise( (resolve, reject) => {
      const query = 'SELECT max(operation_date), remaining FROM bankOperation WHERE user_id = ? AND bank_id = ?  AND credit_id = ?  ALLOW FILTERING';
      client.execute(query, [user_id, bank_id, credit_id], { prepare: true, consistency:consistency.one }, function(err, result) {
          if (err) reject(err);
          resolve(result.rows);
      });
  });
}
