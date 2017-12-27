package main

import (
	"flag"
	"github.com/gocql/gocql"
	"github.com/gorilla/mux"
	_ "github.com/scylladb/gocqlx"
	"log"
	"net/http"
)

func main() {
	var staticPath string = "../frontend/"
	var address string = "0.0.0.0:8080"

	flag.StringVar(&staticPath, "ui", staticPath, "Change path to directory with frontend")
	flag.StringVar(&address, "bind", address, "Change the address to bind on")
	var cassAddress = flag.String("cass_address", "127.0.0.1", "Specify cass address")
	var cassKeyspace = flag.String("cass_keyspace", "moskal", "Specify cass keyspace")

	flag.Parse()

	session, err := ConnectToCass(*cassAddress, *cassKeyspace)
	if err != nil {
		log.Fatal(err)
	}
	r := mux.NewRouter()
	r.PathPrefix("/ui").Handler(http.StripPrefix("/ui", http.FileServer(http.Dir(staticPath))))
	r.PathPrefix("/api").Handler(http.StripPrefix("/api", NewAPI(session)))
	srv := http.Server{
		Handler: r,
		Addr:    address,
	}
	log.Printf("Going to start listen socket. Visit http://%s/ui/", srv.Addr)
	log.Fatal(srv.ListenAndServe())
}

func ConnectToCass(address, keyspace string) (*gocql.Session, error) {
	cluster := gocql.NewCluster(address)
	cluster.Keyspace = keyspace
	return cluster.CreateSession()
}
