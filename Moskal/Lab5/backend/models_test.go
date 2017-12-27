package main

import (
	"flag"
	"testing"
)

var cassAddress = flag.String("cass_address", "127.0.0.1", "Specify cass address")
var cassKeyspace = flag.String("cass_keyspace", "moskal", "Specify cass keyspace")

func TestStation(t *testing.T) {
	if *cassAddress == "" {
		t.Skip("cass_address cli argument wasn't specified")
	}
	session, err := ConnectToCass(*cassAddress, *cassKeyspace)
	if err != nil {
		t.Fatal(err)
	}
	defer session.Close()

	id, err := RegisterGasStation(session, "first gas station")
	if err != nil {
		t.Fatal(err)
	}
	t.Log(id)

	s, err := GetGasStation(session, id)
	if err != nil {
		t.Fatal(err)
	}
	t.Log(s)

	err = ReplenishGasStation(session, id, Petrol{Name: "A-95", Price: 30.}, 500)
	if err != nil {
		t.Fatal(err)
	}
	t.Log("Replenished")

	s, err = GetGasStation(session, id)
	if err != nil {
		t.Fatal(err)
	}
	t.Log(s)

	newVolume, err := GetStationGasVolume(session, id, Petrol{Name: "A-95", Price: 30.})
	if err != nil {
		t.Fatal(err)
	}

	if newVolume != 500. {
		t.Errorf("Unexpected station volume\nGot:%v\nExpected:%v\n", newVolume, 500.)
	}

	err = ReplenishGasStation(session, id, Petrol{Name: "A-95", Price: 30.}, 250)
	if err != nil {
		t.Fatal(err)
	}
	t.Log("Replenished second time")

	newVolume, err = GetStationGasVolume(session, id, Petrol{Name: "A-95", Price: 30.})
	if err != nil {
		t.Fatal(err)
	}

	if newVolume != 750. {
		t.Errorf("Unexpected station volume\nGot:%v\nExpected:%v\n", newVolume, 750.)
	}

}

func TestDriver(t *testing.T) {
	if *cassAddress == "" {
		t.Skip("cass_address cli argument wasn't specified")
	}
	session, err := ConnectToCass(*cassAddress, *cassKeyspace)
	if err != nil {
		t.Fatal(err)
	}
	defer session.Close()

	id, err := RegisterDriver(session, "First Driver")
	if err != nil {
		t.Fatal(err)
	}
	t.Log(id)

	balance, err := GetDriverBalance(session, id)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 0. {
		t.Errorf("Unexpected user balance\nGot:%v\nExpected:%v\n", balance, 0.)
	}

	err = ReplenishDriverBalance(session, id, 1050.)
	if err != nil {
		t.Fatal(err)
	}

	balance, err = GetDriverBalance(session, id)
	if err != nil {
		t.Fatal(err)
	}
	if balance != 1050. {
		t.Errorf("Unexpected user balance\nGot:%v\nExpected:%v\n", balance, 1050.)
	}

	d, err := GetDriver(session, id)
	if err != nil {
		t.Fatal(err)
	}
	if len(d.CarsTanks) != 0 {
		t.Errorf("Unexpected car count\nGot:%v\nExpected:%v\n", len(d.CarsTanks), 0)
	}

	err = DriverAddCar(session, id, Vehicle{Model: "Audi A4", PlateNumber: "AA-0000-AA", TankVolume: 50.})
	if err != nil {
		t.Fatal(err)
	}

	d, err = GetDriver(session, id)
	if err != nil {
		t.Fatal(err)
	}
	if len(d.CarsTanks) != 1 {
		t.Errorf("Unexpected car count\nGot:%v\nExpected:%v\n", len(d.CarsTanks), 1)
	}

	_, ok := d.CarsTanks[Vehicle{Model: "Audi A4", PlateNumber: "AA-0000-AA", TankVolume: 50.}]
	if !ok {
		t.Errorf("Added car not found in Driver record: have %v, should be %v", d.CarsTanks,
			Vehicle{Model: "Audi A4", PlateNumber: "AA-0000-AA", TankVolume: 50.})
	}

	v := Vehicle{Model: "Audi A4", PlateNumber: "AA-0000-AA", TankVolume: 50.}

	fullness, err := GetCarFulness(session, id, v)
	if err != nil {
		t.Fatal(err)
	}
	if fullness != 0. {
		t.Errorf("Unexpected car fullness\nGot:%v\nExpected:%v\n", fullness, 0.)
	}
}

func TestRefill(t *testing.T) {
	if *cassAddress == "" {
		t.Skip("cass_address cli argument wasn't specified")
	}
	session, err := ConnectToCass(*cassAddress, *cassKeyspace)
	if err != nil {
		t.Fatal(err)
	}
	defer session.Close()

	stationId, err := RegisterGasStation(session, "first gas station")
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("stationId: %s", stationId)

	petrol := Petrol{Name: "A-95", Price: 30.}

	err = ReplenishGasStation(session, stationId, petrol, 500)
	if err != nil {
		t.Fatal(err)
	}
	t.Log("Replenished")

	driverId, err := RegisterDriver(session, "First Driver")
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("driverId: %s", driverId)

	err = ReplenishDriverBalance(session, driverId, 1000.)
	if err != nil {
		t.Fatal(err)
	}

	v := Vehicle{Model: "Audi A4", PlateNumber: "AA-0000-AA", TankVolume: 50.}
	err = DriverAddCar(session, driverId, v)
	if err != nil {
		t.Fatal(err)
	}

	purchase := Purchase{
		Price:  petrol.Price,
		Volume: 10.,
	}
	if err := RefillCar(session, driverId, v, stationId, petrol, purchase); err != nil {
		t.Fatal(err)
	}

	newBalance, err := GetDriverBalance(session, driverId)
	if err != nil {
		t.Fatal(err)
	}
	if newBalance != 700. {
		t.Errorf("Wrong user balance after refill:Got:%v\nShould be:%v", newBalance, 700.)
	}

	newCarVolume, err := GetCarFulness(session, driverId, v)
	if err != nil {
		t.Fatal(err)
	}
	if newCarVolume != 10. {
		t.Errorf("Wrong car tank volume after refill:Got:%v\nShould be:%v", newCarVolume, 10.)
	}

	newStationVolume, err := GetStationGasVolume(session, stationId, petrol)
	if err != nil {
		t.Fatal(err)
	}
	if newStationVolume != 490. {
		t.Errorf("Wrong station volume after refill:Got:%v\nShould be:%v", newStationVolume, 490.)
	}

	if err := SubstractGas(session, driverId, v, 5.); err != nil {
		t.Fatal(err)
	}

	newCarVolume, err = GetCarFulness(session, driverId, v)
	if err != nil {
		t.Fatal(err)
	}
	if newCarVolume != 5. {
		t.Errorf("Wrong car tank volume after usage:Got:%v\nShould be:%v", newCarVolume, 5.)
	}

	refills, err := GetRefillsAggregation(session, driverId)
	if err != nil {
		t.Fatal(err)
	}
	if refills[v] != 10. {
		t.Errorf("Wrong car refills aggregation:Got:%v\nShould be:%v", refills[v], 10.)
	}

	turnover, err := GetTurnoverAggregation(session, stationId)
	if err != nil {
		t.Fatal(err)
	}
	if turnover[petrol] != 510. {
		t.Errorf("Wrong station turnover aggregation:Got:%v\nShould be:%v", turnover[petrol], 510.)
	}
}

func TestGetDrivers(t *testing.T) {
	t.Skip()
	if *cassAddress == "" {
		t.Skip("cass_address cli argument wasn't specified")
	}
	session, err := ConnectToCass(*cassAddress, *cassKeyspace)
	if err != nil {
		t.Fatal(err)
	}
	defer session.Close()

	q := session.Query("truncate driver")
	defer q.Release()
	if err := q.Exec(); err != nil {
		t.Fatal(err)
	}

	/*d1*/
	_, err = RegisterDriver(session, "First driver")
	if err != nil {
		t.Fatal(err)
	}

	/*d2*/
	_, err = RegisterDriver(session, "Second driver")
	if err != nil {
		t.Fatal(err)
	}

	drivers, err := GetDrivers(session)
	if err != nil {
		t.Fatal(err)
	}

	if len(drivers) != 2 {
		t.Errorf("Wrong drivers list length: Got: %v\nShould be: %v\n", len(drivers), 2)
	}
	t.Log(drivers)

}

func TestGetGasStations(t *testing.T) {
	t.Skip()
	if *cassAddress == "" {
		t.Skip("cass_address cli argument wasn't specified")
	}
	session, err := ConnectToCass(*cassAddress, *cassKeyspace)
	if err != nil {
		t.Fatal(err)
	}
	defer session.Close()

	q := session.Query("truncate gas_station")
	defer q.Release()
	if err := q.Exec(); err != nil {
		t.Fatal(err)
	}

	/*d1*/
	_, err = RegisterGasStation(session, "First station")
	if err != nil {
		t.Fatal(err)
	}

	/*d2*/
	_, err = RegisterGasStation(session, "Second station")
	if err != nil {
		t.Fatal(err)
	}

	stations, err := GetGasStations(session)
	if err != nil {
		t.Fatal(err)
	}

	if len(stations) != 2 {
		t.Errorf("Wrong drivers list length: Got: %v\nShould be: %v\n", len(stations), 2)
	}
	t.Log(stations)

}
