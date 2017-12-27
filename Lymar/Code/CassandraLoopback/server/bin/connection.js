'use strict';
const async = require('async');
const cassanKnex = require("cassanknex")({
    connection: {
        contactPoints: ['localhost']
    },
    debug: false
});
const cache = {};
cassanKnex.on("ready", (err) => {
    console.log("Cassandra connection is established");
});

function CassandraConnection() {
    if (cache.isCached) {
        return cache.cassandra;
    } else {
        cache.isCached = true;
        cache.cassandra = cassanKnex;
        return  cassanKnex;
    }

}

module.exports = CassandraConnection;
