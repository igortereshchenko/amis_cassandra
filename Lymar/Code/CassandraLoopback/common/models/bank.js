'use strict';
const async = require('async');
const connection = require('../../server/bin/connection')();
const consistency = connection.getDriver().types.consistencies;
const uuid = connection.getDriver().types.Uuid;
const app = require('../../server/server');
const keyspace = app.get('keyspace');
const client = connection.getClient();
client.keyspace = keyspace;

module.exports = function(Bank) {

    Bank.create = (bankname,  cb)  => {
        const bankId = uuid.random();
        const bank = {
            bank_id: bankId,
            bank_name: bankname
        }

        const result = createBank(bank, connection);
        result.then((data) => {
            cb(null, bank);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bank.findAll = (cb)  => {
        const result = findBanks(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bank.deleteById = (bankId, cb)  => {
        async.series([
            (callback) => {
                Bank.app.models.BankOperation.findAllbyBankId(bankId,(err,data)=> {
                    if (err) return callback(err,null);
                    if (data && data.length) return callback(null,data);
                    return callback(null,null);
                })
            }
        ],
        function(err, results) {
            const bankOpIds = (results[0] && results[0][0]) ? results[0].map((bankOp) => {
                return bankOp.bank_operation_id;
            }) : [];

            const result = deleteBank(bankId, bankOpIds, connection);
            result.then((data) => {
                cb(null, data);
            }).catch((err) => {
                cb(err, null);
            })
        });

    };

    Bank.updateById = (bankId, bankname, cb)  => {
        const bank = {
            bank_name: bankname
        }
        const result = updateBank(bankId, bank, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bank.addUser = (bankId, userId, cb)  => {
        const bank = {
            bank_id: bankId,
            user: userId
        }

        const result = addUser(bank, connection);
        result.then((data) => {
            cb(null, bank);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bank.removeUser = (bankId, userId, cb)  => {
        const bank = {
            bank_id: bankId,
            user: userId
        }

        const result = removeUser(bank, connection);
        result.then((data) => {
            cb(null, bank);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Bank.remoteMethod('create', {
        accepts: [
            {arg: 'bankname', type: 'string'}
        ],
        http: {verb: 'post'},
        returns: {type: 'object', root: true},
    });

    Bank.remoteMethod('findAll', {
        accepts: [],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Bank.remoteMethod('deleteById', {
        accepts: [{arg: 'bankId', type: 'string'}],
        http: {verb: 'delete'},
        returns: {type: 'object', root: true},
    });

    Bank.remoteMethod('updateById', {
        accepts: [
                {arg: 'bankId', type: 'string'},
                {arg: 'bankname', type: 'string'}
            ],
        http: {verb: 'put'},
        returns: {type: 'object', root: true},
    });

    Bank.remoteMethod('addUser', {
        accepts: [
                {arg: 'bankId', type: 'string'},
                {arg: 'userId', type: 'string'}
            ],
        http: {verb: 'post'},
        returns: {type: 'object', root: true},
    });

    Bank.remoteMethod('removeUser', {
        accepts: [
                {arg: 'bankId', type: 'string'},
                {arg: 'userId', type: 'string'}
            ],
        http: {verb: 'delete'},
        returns: {type: 'object', root: true},
    });

}

function createBank(bank, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .insert(bank)
            .from('bank')
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

function findBanks(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .from('bank')
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

function deleteBank(bankId, bankOpIds, banconnection) {
    return new Promise( (resolve, reject) => {
        const query1 = connection(keyspace)
                    .delete()
                    .from("bank")
                    .where('bank_id','=',bankId)
                    .cql();
        const queries = [
           { query: query1, params: [bankId] }
        ];
        // console.log(bankOpIds);
        for (let i=0; i <bankOpIds.length; i++ ) {
            const query = connection(keyspace)
                        .delete()
                        .from('bankoperation')
                        .where('bank_operation_id','=',bankOpIds[i])
                        .cql();
            queries.push({query:query, params:[bankOpIds[i]] })
        }

        // console.log("queries",queries);

        client.batch(queries, { prepare: true, consistency:consistency.quorum })
          .then(function(data) {
              resolve(data);
          })
          .catch(function(err) {
            reject(err);
          });
        });
}

function updateBank(bankId, body, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .update("bank")
            .set('bank_name',body.bank_name)
            .where('bank_id','=',bankId)
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

function addUser(body, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .update("bank")
            .add("users",[[body.user]])
            .where('bank_id','=',body.bank_id)
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

function removeUser(body, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .update("bank")
            .remove("users",[body.user])
            .where('bank_id','=',body.bank_id)
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
