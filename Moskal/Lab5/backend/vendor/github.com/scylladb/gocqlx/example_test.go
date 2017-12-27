// Copyright (C) 2017 ScyllaDB
// Use of this source code is governed by a ALv2-style
// license that can be found in the LICENSE file.

// +build all integration

package gocqlx_test

import (
	"testing"
	"time"

	"github.com/scylladb/gocqlx"
	"github.com/scylladb/gocqlx/qb"
)

var personSchema = `
CREATE TABLE IF NOT EXISTS gocqlx_test.person (
    first_name text,
    last_name text,
    email list<text>,
    PRIMARY KEY(first_name, last_name)
)`

// Field names are converted to camel case by default, no need to add
// `db:"first_name"`, if you want to disable a filed add `db:"-"` tag.
type Person struct {
	FirstName string
	LastName  string
	Email     []string
}

func TestExample(t *testing.T) {
	session := createSession(t)
	defer session.Close()

	if err := createTable(session, personSchema); err != nil {
		t.Fatal("create table:", err)
	}

	p := &Person{
		"Patricia",
		"Citizen",
		[]string{"patricia.citzen@gocqlx_test.com"},
	}

	// Insert with query parameters bound from struct.
	{
		stmt, names := qb.Insert("gocqlx_test.person").
			Columns("first_name", "last_name", "email").
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindStruct(p)

		if err := q.ExecRelease(); err != nil {
			t.Fatal(err)
		}
	}

	// Insert with query parameters bound from struct extended with a map.
	{
		stmt, names := qb.Insert("gocqlx_test.person").
			Columns("first_name", "last_name", "email").
			TTL().
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindStructMap(p, qb.M{
			"_ttl": qb.TTL(86400 * time.Second),
		})

		if err := q.ExecRelease(); err != nil {
			t.Fatal(err)
		}
	}

	// Easy update with all parameters bound from struct.
	{
		p.Email = append(p.Email, "patricia1.citzen@gocqlx_test.com")

		stmt, names := qb.Update("gocqlx_test.person").
			Set("email").
			Where(qb.Eq("first_name"), qb.Eq("last_name")).
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindStruct(p)

		if err := q.ExecRelease(); err != nil {
			t.Fatal(err)
		}
	}

	// Advanced update, adding and removing elements to collections and counters.
	{
		stmt, names := qb.Update("gocqlx_test.person").
			AddNamed("email", "new_email").
			Where(qb.Eq("first_name"), qb.Eq("last_name")).
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindStructMap(p, qb.M{
			"new_email": []string{"patricia2.citzen@gocqlx_test.com", "patricia3.citzen@gocqlx_test.com"},
		})

		if err := q.ExecRelease(); err != nil {
			t.Fatal(err)
		}
	}

	// Batch insert two rows in a single query, advanced struct binding.
	{
		i := qb.Insert("gocqlx_test.person").Columns("first_name", "last_name", "email")

		stmt, names := qb.Batch().
			AddWithPrefix("a", i).
			AddWithPrefix("b", i).
			ToCql()

		batch := struct {
			A Person
			B Person
		}{
			A: Person{
				"Igy",
				"Citizen",
				[]string{"igy.citzen@gocqlx_test.com"},
			},
			B: Person{
				"Ian",
				"Citizen",
				[]string{"ian.citzen@gocqlx_test.com"},
			},
		}

		q := gocqlx.Query(session.Query(stmt), names).BindStruct(&batch)

		if err := q.ExecRelease(); err != nil {
			t.Fatal(err)
		}
	}

	// Get the first result into a struct.
	{
		stmt, names := qb.Select("gocqlx_test.person").
			Where(qb.Eq("first_name")).
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{
			"first_name": "Patricia",
		})
		defer q.Release()

		var p Person
		if err := gocqlx.Get(&p, q.Query); err != nil {
			t.Fatal("get:", err)
		}

		t.Log(p)
		// {Patricia Citizen [patricia.citzen@gocqlx_test.com patricia1.citzen@gocqlx_test.com patricia2.citzen@gocqlx_test.com patricia3.citzen@gocqlx_test.com]}
	}

	// Select, load all the results into a slice.
	{
		stmt, names := qb.Select("gocqlx_test.person").
			Where(qb.In("first_name")).
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{
			"first_name": []string{"Patricia", "Igy", "Ian"},
		})
		defer q.Release()

		var people []Person
		if err := gocqlx.Select(&people, q.Query); err != nil {
			t.Fatal("select:", err)
		}

		t.Log(people)
		// [{Ian Citizen [ian.citzen@gocqlx_test.com]} {Igy Citizen [igy.citzen@gocqlx_test.com]} {Patricia Citizen [patricia.citzen@gocqlx_test.com patricia1.citzen@gocqlx_test.com patricia2.citzen@gocqlx_test.com patricia3.citzen@gocqlx_test.com]}]
	}

	// Easy token based pagination.
	{
		p := &Person{
			"Ian",
			"Citizen",
			[]string{"ian.citzen@gocqlx_test.com"},
		}

		stmt, names := qb.Select("gocqlx_test.person").
			Columns("first_name").
			Where(qb.Token("first_name").Gt()).
			Limit(10).
			ToCql()

		q := gocqlx.Query(session.Query(stmt), names).BindStruct(p)
		defer q.Release()

		var people []Person
		if err := gocqlx.Select(&people, q.Query); err != nil {
			t.Fatal("select:", err)
		}

		t.Log(people)
		// [{Patricia  []} {Igy  []}]
	}

	// Named query compilation.
	{
		p := &Person{
			"Jane",
			"Citizen",
			[]string{"jane.citzen@gocqlx_test.com"},
		}

		stmt, names, err := gocqlx.CompileNamedQuery([]byte("INSERT INTO gocqlx_test.person (first_name, last_name, email) VALUES (:first_name, :last_name, :email)"))
		if err != nil {
			t.Fatal("compile:", err)
		}

		q := gocqlx.Query(session.Query(stmt), names).BindStruct(p)

		if err := q.ExecRelease(); err != nil {
			t.Fatal(err)
		}
	}
}
