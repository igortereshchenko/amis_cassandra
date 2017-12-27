package main

import (
	"fmt"
	"github.com/gocql/gocql"
	"github.com/scylladb/gocqlx"
	"github.com/scylladb/gocqlx/qb"
	"time"
)

type Vehicle struct {
	PlateNumber string  `cql:"plate_number"`
	Model       string  `cql:"model"`
	TankVolume  float32 `cql:"tank_volume"`
}

type Petrol struct {
	Name  string  `cql:"name"`
	Price float32 `cql:"price"`
}

type Purchase struct {
	Volume float32 `cql:"volume"`
	Price  float32 `cql:"price"`
}

type Replenishment Purchase

type GasStation struct {
	Id                  gocql.UUID
	Name                string
	LastOilReserveState map[Petrol]gocql.UUID
}

type Driver struct {
	Id               gocql.UUID
	Name             string
	CarsTanks        map[Vehicle]gocql.UUID
	LastBalanceState gocql.UUID
}

type Transaction struct {
	Id gocql.UUID

	StationId *gocql.UUID
	DriverId  *gocql.UUID
	Car       *Vehicle
	Petrol    *Petrol
	Time      time.Time

	StationReplenishment     *Replenishment
	Purchase                 *Purchase
	StationVolume            *float32
	CarTankFullness          *float32
	CarTankUsage             *float32
	UserBalance              *float32
	UserBalanceReplenishment *float32
}

type WishListItem struct {
	Date     time.Time
	DriverId gocql.UUID
	Wishes   map[string]float32
}

func RegisterGasStation(session *gocql.Session, name string) (gocql.UUID, error) {
	var station GasStation
	station.Id = gocql.TimeUUID()
	station.Name = name
	stmt, names := qb.Insert("gas_station").Columns("id", "name").ToCql()
	q := gocqlx.Query(session.Query(stmt).Consistency(gocql.Quorum), names).BindStruct(station)
	if err := q.ExecRelease(); err != nil {
		return gocql.UUID{}, fmt.Errorf("RegisterGasStation Query error: %s", err)
	}
	return station.Id, nil
}

func GetGasStation(session *gocql.Session, id gocql.UUID) (GasStation, error) {
	stmt, names := qb.Select("gas_station").Where(qb.Eq("id")).ToCql()
	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{"id": id})
	defer q.Release()
	var station GasStation
	if err := gocqlx.Get(&station, q.Query); err != nil {
		return GasStation{}, fmt.Errorf("GetGasStation Query error: %s", err)
	}
	return station, nil
}

func ReplenishGasStation(session *gocql.Session, stationId gocql.UUID, petrol Petrol, volume float32) error {
	oldVolume, err := GetStationGasVolume(session, stationId, petrol)
	if err != nil {
		return nil
	}

	var r Replenishment
	r.Price = petrol.Price
	r.Volume = volume

	newVolume := oldVolume + volume

	var t Transaction
	t.Id = gocql.TimeUUID()
	t.Time = t.Id.Time()
	t.StationId = &stationId
	t.Petrol = &petrol
	t.StationReplenishment = &r
	t.StationVolume = &newVolume

	stmt, names := qb.Batch().
		AddWithPrefix("t", qb.Insert("transactions").
			Columns("id", "time", "station_id", "station_replenishment", "station_volume", "petrol")).
		AddWithPrefix("g", qb.Update("gas_station").
			AddNamed("last_oil_reserve_state", "new_reserve_diff").
			Where(qb.Eq("id"))).
		ToCql()

	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{
		"t.id":         t.Id,
		"t.time":       t.Time,
		"t.station_id": stationId,
		"t.petrol": map[string]interface{}{
			"name":  petrol.Name,
			"price": petrol.Price,
		},
		"t.station_replenishment": map[string]interface{}{
			"price":  petrol.Price,
			"volume": volume,
		},
		"t.station_volume": newVolume,
		"g.id":             stationId,
		"g.new_reserve_diff": map[Petrol]gocql.UUID{
			petrol: t.Id,
		},
	})
	if err := q.ExecRelease(); err != nil {
		return fmt.Errorf("ReplenishGasStation batch error: %s", err)
	}
	return nil
}

func GetStationGasVolume(session *gocql.Session, stationId gocql.UUID, petrol Petrol) (float32, error) {
	station, err := GetGasStation(session, stationId)
	if err != nil {
		return 0., fmt.Errorf("GetStationGasVolume error: %s", err)
	}

	var oldVolume float32 = 0.
	tid, ok := station.LastOilReserveState[petrol]
	if ok {
		stmt, names := qb.Select("transactions").Columns("station_volume").Where(qb.Eq("id")).ToCql()
		var t Transaction
		q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{"id": tid})
		defer q.Release()
		if err := gocqlx.Get(&t, q.Query); err != nil {
			return 0., fmt.Errorf("GetStationGasVolume get transaction error: %s", err)
		}
		oldVolume = *t.StationVolume
	}
	return oldVolume, nil
}

func RegisterDriver(session *gocql.Session, name string) (gocql.UUID, error) {
	var d Driver
	d.Id = gocql.TimeUUID()
	d.Name = name

	var t Transaction
	t.Id = gocql.TimeUUID()
	t.DriverId = &d.Id
	t.UserBalance = new(float32)
	t.Time = t.Id.Time()

	d.LastBalanceState = t.Id
	stmt, names := qb.Batch().
		AddWithPrefix("d", qb.Insert("driver").Columns("id", "name", "last_balance_state")).
		AddWithPrefix("t", qb.Insert("transactions").Columns("id", "driver_id", "user_balance", "time")).
		ToCql()

	q := gocqlx.Query(session.Query(stmt), names).BindStruct(struct {
		D Driver
		T Transaction
	}{
		D: d,
		T: t,
	})

	if err := q.ExecRelease(); err != nil {
		return gocql.UUID{}, fmt.Errorf("RegisterDriver: %v", err)
	}

	return d.Id, nil
}

func GetDriverBalance(session *gocql.Session, id gocql.UUID) (float32, error) {
	stmt, names := qb.Select("driver").Columns("last_balance_state").Where(qb.Eq("id")).ToCql()
	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{"id": id})
	defer q.Release()
	var d Driver
	if err := gocqlx.Get(&d, q.Query); err != nil {
		return 0., err
	}

	stmt, names = qb.Select("transactions").Columns("user_balance").Where(qb.Eq("id")).ToCql()
	q1 := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{"id": d.LastBalanceState})
	defer q1.Release()

	var t Transaction
	if err := gocqlx.Get(&t, q1.Query); err != nil {
		return 0., err
	}
	return *t.UserBalance, nil
}

func ReplenishDriverBalance(session *gocql.Session, id gocql.UUID, money float32) error {
	oldBalance, err := GetDriverBalance(session, id)
	if err != nil {
		return err
	}
	var t Transaction
	t.Id = gocql.TimeUUID()
	t.Time = t.Id.Time()
	t.DriverId = &id
	t.UserBalanceReplenishment = &money
	var newBalance = oldBalance + money
	t.UserBalance = &newBalance

	var d Driver
	d.Id = id
	d.LastBalanceState = t.Id

	stmt, names := qb.Batch().
		AddWithPrefix("d", qb.Insert("driver").Columns("id", "last_balance_state")).
		AddWithPrefix("t", qb.Insert("transactions").Columns("id", "driver_id", "user_balance", "user_balance_replenishment", "time")).
		ToCql()

	q := gocqlx.Query(session.Query(stmt), names).BindStruct(struct {
		D Driver
		T Transaction
	}{
		D: d,
		T: t,
	})

	if err := q.ExecRelease(); err != nil {
		return fmt.Errorf("RegisterDriver: %v", err)
	}

	return nil
}

func GetDriver(session *gocql.Session, id gocql.UUID) (Driver, error) {
	stmt, names := qb.Select("driver").Where(qb.Eq("id")).ToCql()
	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{"id": id})
	defer q.Release()
	var d Driver
	if err := gocqlx.Get(&d, q.Query); err != nil {
		return Driver{}, err
	}
	return d, nil
}

func DriverAddCar(session *gocql.Session, id gocql.UUID, car Vehicle) error {
	var t Transaction
	t.Id = gocql.TimeUUID()
	t.Time = t.Id.Time()
	t.DriverId = &id
	t.CarTankFullness = new(float32)

	var d Driver
	d.Id = id
	d.CarsTanks = make(map[Vehicle]gocql.UUID, 1)
	d.CarsTanks[car] = t.Id

	stmt, names := qb.Batch().
		AddWithPrefix("d", qb.Update("driver").Add("cars_tanks").Where(qb.Eq("id"))).
		AddWithPrefix("t", qb.Insert("transactions").Columns("id", "time", "driver_id", "car_tank_fullness")).
		ToCql()

	q := gocqlx.Query(session.Query(stmt), names).BindStruct(struct {
		D Driver
		T Transaction
	}{
		D: d,
		T: t,
	})

	if err := q.ExecRelease(); err != nil {
		return fmt.Errorf("DriverAddCar error: %v", err)
	}

	return nil
}

func GetCarFulness(session *gocql.Session, id gocql.UUID, car Vehicle) (float32, error) {
	d, err := GetDriver(session, id)
	if err != nil {
		return 0., err
	}
	tid, ok := d.CarsTanks[car]
	if !ok {
		return 0., fmt.Errorf("Car %v not found in driver %v", car, d)
	}
	stmt, names := qb.Select("transactions").Columns("car_tank_fullness").Where(qb.Eq("id")).ToCql()
	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{"id": tid})
	defer q.Release()

	var t Transaction
	if err := gocqlx.Get(&t, q.Query); err != nil {
		return 0., err
	}
	return *t.CarTankFullness, nil
}

func RefillCar(session *gocql.Session, driverId gocql.UUID, car Vehicle, stationId gocql.UUID, petrol Petrol, purchase Purchase) error {
	fulness, err := GetCarFulness(session, driverId, car)
	if err != nil {
		return err
	}
	if purchase.Volume+fulness > car.TankVolume {
		return fmt.Errorf("Desired volume exceeds tank capacity")
	}

	availableGas, err := GetStationGasVolume(session, stationId, petrol)
	if err != nil {
		return err
	}
	if availableGas < purchase.Volume {
		return fmt.Errorf("Desired volume exceeds station available amount")
	}

	driverBalance, err := GetDriverBalance(session, driverId)
	if err != nil {
		return err
	}

	if driverBalance < purchase.Price*purchase.Volume {
		return fmt.Errorf("Not enough funds on driver balance")
	}

	var t Transaction
	t.Id = gocql.TimeUUID()
	t.Time = t.Id.Time()
	t.StationId = &stationId
	t.DriverId = &driverId
	t.Car = &car
	t.Purchase = &purchase
	t.Petrol = &petrol
	var newTankFullness float32 = fulness + purchase.Volume
	var newDriverBalance float32 = driverBalance - purchase.Price*purchase.Volume
	var newStationVolume float32 = availableGas - purchase.Volume

	t.CarTankFullness = &newTankFullness
	t.UserBalance = &newDriverBalance
	t.StationVolume = &newStationVolume

	stmt, names := qb.Batch().
		AddWithPrefix("t", qb.Insert("transactions").Columns("id", "time", "station_id", "driver_id", "car",
			"purchase", "petrol", "car_tank_fullness", "user_balance", "station_volume")).
		AddWithPrefix("g", qb.Update("gas_station").AddNamed("last_oil_reserve_state", "tid").Where(qb.Eq("id"))).
		AddWithPrefix("d", qb.Update("driver").AddNamed("cars_tanks", "car_state").Set("last_balance_state").Where(qb.Eq("id"))).
		ToCql()

	q := gocqlx.Query(session.Query(stmt), names).BindStructMap(struct {
		T Transaction
	}{
		T: t,
	}, qb.M{
		"g.id": stationId,
		"g.tid": map[Petrol]gocql.UUID{
			petrol: t.Id,
		},
		"d.id":                 driverId,
		"d.last_balance_state": t.Id,
		"d.car_state": map[Vehicle]gocql.UUID{
			car: t.Id,
		},
	})

	if err := q.ExecRelease(); err != nil {
		return err
	}
	return nil
}

func SubstractGas(session *gocql.Session, driverId gocql.UUID, car Vehicle, volume float32) error {
	fulness, err := GetCarFulness(session, driverId, car)
	if err != nil {
		return err
	}
	if fulness < volume {
		return fmt.Errorf("Desired volume exceeds tank amount")
	}

	var t Transaction
	t.Id = gocql.TimeUUID()
	t.Time = t.Id.Time()
	t.DriverId = &driverId
	t.Car = &car
	var newTankFullness float32 = fulness - volume

	t.CarTankFullness = &newTankFullness
	t.CarTankUsage = &volume

	stmt, names := qb.Batch().
		AddWithPrefix("t", qb.Insert("transactions").Columns("id", "time", "driver_id", "car",
			"car_tank_fullness", "car_tank_usage")).
		AddWithPrefix("d", qb.Update("driver").AddNamed("cars_tanks", "car_state").Where(qb.Eq("id"))).
		ToCql()

	q := gocqlx.Query(session.Query(stmt), names).BindStructMap(struct {
		T Transaction
	}{
		T: t,
	}, qb.M{
		"d.id": driverId,
		"d.car_state": map[Vehicle]gocql.UUID{
			car: t.Id,
		},
	})

	if err := q.ExecRelease(); err != nil {
		return err
	}
	return nil

}

func GetRefillsAggregation(session *gocql.Session, driverId gocql.UUID) (map[Vehicle]float32, error) {
	stmt, names := qb.Select("transactions").Columns("aggregateRefills(car, purchase.volume)").Where(qb.Eq("driver_id")).ToCql()
	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{
		"driver_id": driverId,
	})
	defer q.Release()
	var res map[Vehicle]float32
	if err := gocqlx.Get(&res, q.Query); err != nil {
		return nil, err
	}
	return res, nil
}

func GetTurnoverAggregation(session *gocql.Session, stationId gocql.UUID) (map[Petrol]float32, error) {
	stmt, names := qb.Select("transactions").
		Columns("aggregateTurnover(petrol, station_replenishment.volume, purchase.volume)").
		Where(qb.Eq("station_id")).
		ToCql()
	q := gocqlx.Query(session.Query(stmt), names).BindMap(qb.M{
		"station_id": stationId,
	})
	defer q.Release()
	var res map[Petrol]float32
	if err := gocqlx.Get(&res, q.Query); err != nil {
		return nil, err
	}
	return res, nil
}

func GetDrivers(session *gocql.Session) ([]Driver, error) {
	stmt, names := qb.Select("driver").ToCql()
	q := gocqlx.Query(session.Query(stmt), names)
	defer q.Release()

	var res []Driver
	if err := gocqlx.Select(&res, q.Query); err != nil {
		return nil, err
	}
	return res, nil
}

func GetGasStations(session *gocql.Session) ([]GasStation, error) {
	stmt, names := qb.Select("gas_station").ToCql()
	q := gocqlx.Query(session.Query(stmt), names)
	defer q.Release()

	var res []GasStation
	if err := gocqlx.Select(&res, q.Query); err != nil {
		return nil, err
	}
	return res, nil
}

func DeleteDriver(session *gocql.Session, driverId gocql.UUID) error {
	stmt, names := qb.Delete("driver").Where(qb.Eq("id")).ToCql()
	q := gocqlx.Query(session.Query(stmt).Consistency(gocql.Quorum), names).BindMap(qb.M{
		"id": driverId,
	})
	if err := q.ExecRelease(); err != nil {
		return fmt.Errorf("Delete Query error: %s", err)
	}
	return nil
}

func DeleteStation(session *gocql.Session, stationId gocql.UUID) error {
	stmt, names := qb.Delete("gas_station").Where(qb.Eq("id")).ToCql()
	q := gocqlx.Query(session.Query(stmt).Consistency(gocql.Quorum), names).BindMap(qb.M{
		"id": stationId,
	})
	if err := q.ExecRelease(); err != nil {
		return fmt.Errorf("Delete Query error: %s", err)
	}
	return nil
}
