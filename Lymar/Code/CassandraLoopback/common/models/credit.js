'use strict';
const async = require('async');
const connection = require('../../server/bin/connection')();
const consistency = connection.getDriver().types.consistencies;
const uuid = connection.getDriver().types.Uuid;
const app = require('../../server/server');
const keyspace = app.get('keyspace');
const client = connection.getClient();
client.keyspace = keyspace;

module.exports = function(Credit) {
    Credit.create = (percent, term, debt, cb)  => {
        const creditId = uuid.random();
        const credit = {
            credit_id: creditId,
            percent: percent,
            term: term,
            debt: debt
        };
        const result = createCredit(credit, connection);
        result.then((data) => {
            cb(null, credit);
        }).catch((err) => {
            cb(err, null);
        });
    };

    Credit.findById = (credit_id, cb)  => {
        const result = findCreditById(credit_id, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Credit.findAll = (cb)  => {
        const result = findCredits(connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Credit.updateById = (creditId, percent, term, debt, cb)  => {
        const credit = {
            percent: percent,
            term: term,
            debt: debt
        }
        const result = updateCredit(creditId, credit, connection);
        result.then((data) => {
            cb(null, data);
        }).catch((err) => {
            cb(err, null);
        })
    };

    Credit.deleteById = (creditId, cb)  => {
        async.series([
            (callback) => {
                Credit.app.models.BankOperation.findAllbyCreditId(creditId,(err,data)=> {
                    if (err) return callback(err,null);
                    if (data && data.length) return callback(null,data);
                    return callback(null,null);
                });
            }
        ],
        function(err, results) {
            const bankOpIds = (results[0] && results[0][0]) ? results.map((bankOp) => {
                return bankOp.bank_operation_id;
            }) : [];

            const result = deleteCredit(creditId, bankOpIds, connection);
            result.then((data) => {
                cb(null, data);
            }).catch((err) => {
                cb(err, null);
            })
        });

    };


    Credit.remoteMethod('create', {
      accepts: [
            {arg: 'percent', type: 'number'},
            {arg: 'term', type: 'number'},
            {arg: 'debt', type: 'number'}
        ],
      http: {verb: 'post'},
      returns: {type: 'object', root: true},
    });

    Credit.remoteMethod('findById', {
      accepts: [
            {arg: 'credit_id', type: 'number'}
        ],
      http: {verb: 'get'},
      returns: {type: 'array', root: true},
    });

    Credit.remoteMethod('findAll', {
      accepts: [],
      http: {verb: 'get'},
      returns: {type: 'array', root: true},
    });

    Credit.remoteMethod('updateById', {
        accepts: [
                {arg: 'creditId', type: 'string'},
                {arg: 'percent', type: 'number'},
                {arg: 'term', type: 'number'},
                {arg: 'debt', type: 'number'}
            ],
        http: {verb: 'put'},
        returns: {type: 'object', root: true},
    });

    Credit.remoteMethod('deleteById', {
        accepts: [
                {arg: 'creditId', type: 'string'},
            ],
        http: {verb: 'delete'},
        returns: {type: 'object', root: true},
    });
};

function createCredit(credit, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .insert(credit)
            .from('credit')
            .exec({consistency:consistency.quorum}, (err,result) => {
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

function findCreditById(credit_id, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .where("credit_id","=",credit_id)
            .from('credit')
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

function findCredits(connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .select("*")
            .from('credit')
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

function updateCredit(creditId, body, connection) {
    return new Promise( (resolve, reject) => {
        connection(keyspace)
            .update("credit")
            .set('percent',body.percent)
            .set('term',body.term)
            .set('debt',body.debt)
            .where('credit_id','=',creditId)
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

function deleteCredit(creditId, bankOpIds, connection) {
    return new Promise( (resolve, reject) => {
        const query1 = connection(keyspace)
                        .delete()
                        .from("credit")
                        .where('credit_id','=',creditId)
                        .cql();
        const queries = [
           { query: query1, params: [creditId] }
        ];
        if (bankOpIds.length) {
            for (let i=0; i <bankOpIds.length; i++ ) {
                const query = connection(keyspace)
                            .delete()
                            .from('bankoperation')
                            .where('bank_operation_id','=',bankOpIds[i])
                            .cql();
                queries.push({query:query, params:[bankOpIds[i]] })
            }
        }

        client.batch(queries, { prepare: true, consistency:consistency.quorum })
          .then(function(data) {
              resolve(data);
          })
          .catch(function(err) {
            reject(err);
          });
    });

}
