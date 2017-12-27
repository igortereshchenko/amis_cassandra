"use strict";
const async = require('async');
const connection = require('../../server/bin/connection')();
const consistency = connection.getDriver().types.consistencies;
const uuid = connection.getDriver().types.Uuid;
const app = require('../../server/server');
const keyspace = app.get('keyspace');
const client = connection.getClient();
client.keyspace = keyspace;

module.exports = (Client) => {
    Client.findById = (userId, cb)  => {
        const client = findUserById(userId, connection);
        client.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Client.create = (firstname, middlename, lastname, cb)  => {
        const balance = 0;
        const userId = uuid.random();
        const client = {
            user_id: userId,
            fio: {
                firstname: firstname,
                middlename: middlename,
                lastname: lastname
            },
            balance: balance
        }

        const result = createClient(client, connection);
        result.then((data) => {
            cb(null, client);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Client.findMaxId = (cb)  => {
        const result = findClientIds(connection);
        result.then((data) => {
            cb(null, Math.max(...data));
        }).catch((err) => {
            cb(err, null);
        })
    };

    Client.findAll = (cb)  => {

        const result = findClients(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })

    };

    Client.updateById = (userId, firstname, middlename, lastname, balance, cb)  => {
        const client = {
            fio: {
                firstname: firstname,
                middlename: middlename,
                lastname: lastname
            },
            balance: balance
        }
        const result = updateClient(userId, client, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Client.deleteById = (userId, cb)  => {

        async.series([
            (callback) => {
                Client.app.models.Bank.findAll((err,data)=> {
                    if (err) return callback(err,null);
                    if (data && data.length) return callback(null,data);
                    return callback(null,null);
                })
            }
        ],
        function(err, results) {
            const bankIds = (results[0] && results[0][0]) ? results.map((bank) => {
                return bank.bank_id;
            }) : [];

            const result = deleteClient(userId,bankIds, connection);
            result.then((data) => {
                cb(null, data);
            }).catch((err) => {
                cb(err, null);
            })

        });


    };

    Client.remoteMethod('findById', {
        accepts: [{arg: 'userId', type: 'string'}],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Client.remoteMethod('create', {
        accepts: [
            {arg: 'firstname', type: 'string'},
            {arg: 'middlename', type: 'string'},
            {arg: 'lastname', type: 'string'},
        ],
        http: {verb: 'post'},
        returns: {type: 'object', root: true},
    });

    Client.remoteMethod('findMaxId', {
        accepts: [],
        http: {verb: 'get'},
        returns: {type: 'object', root:true },
    });

    Client.remoteMethod('findAll', {
        accepts: [],
        http: {verb: 'get'},
        returns: {type: 'array', root: true},
    });

    Client.remoteMethod('updateById', {
        accepts: [
                {arg: 'userId', type: 'string'},
                {arg: 'firstname', type: 'string'},
                {arg: 'middlename', type: 'string'},
                {arg: 'lastname', type: 'string'},
                {arg: 'balance', type: 'number'}
            ],
        http: {verb: 'put'},
        returns: {type: 'object', root: true},
    });

    Client.remoteMethod('deleteById', {
        accepts: [{arg: 'userId', type: 'string'}],
        http: {verb: 'get'},
        returns: {type: 'object', root: true},
    });

};

function createClient(client, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .insert(client)
            .from('user')
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

function findUserById(userId, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("user_id","=",userId.toString())
            .from('user')
            .exec({consistency:consistency.one}, (err,result) => {
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

function findClientIds(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("user_id")
            .from('user')
            .exec({consistency:consistency.one}, (err,result) => {
                if (err) reject(err);
                else  {
                    if (result && result.rows){
                        resolve(result.rows.map((value) => value.user_id));
                    } else {
                        resolve([]);
                    }
                }
            })
        });
}

function findClients(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .from('user')
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

function updateClient(userId, body, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .update("user")
            .set('balance',body.balance)
            .set('fio',body.fio)
            .where('user_id','=',userId)
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

function deleteClient(userId,bankIds, connection) {
    return new Promise( (resolve, reject) => {

        const query1 = connection(keyspace)
                    .delete()
                    .from("user")
                    .where('user_id','=',userId)
                    .cql();

        const queries = [
           { query: query1, params: [userId] }
        ];
        for (let i=0; i <bankIds.length; i++ ) {
            const query = connection(keyspace)
                        .update("bank")
                        .remove("users",[userId])
                        .where('bank_id','=',bankIds[i])
                        .cql();
            queries.push({query:query, params:[[userId],bankIds[i]] })
        }

        // Promise-based call
        client.batch(queries, { prepare: true, consistency:consistency.quorum })
          .then(function(data) {
              resolve(data);
          })
          .catch(function(err) {
            reject(err);
          });
      })
}
