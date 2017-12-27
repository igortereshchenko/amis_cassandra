from cassandra.cluster import Cluster

from app.cassandra_api.constants import KEYSPACE

cluster = Cluster()

session = cluster.connect(KEYSPACE)
