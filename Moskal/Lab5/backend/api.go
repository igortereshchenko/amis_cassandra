package main

import (
	"encoding/json"
	"fmt"
	"github.com/gocql/gocql"
	"github.com/gorilla/mux"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

func NewAPI(session *gocql.Session) http.Handler {
	var api API
	api.session = session
	r := mux.NewRouter()
	r.Path("/driver").Methods(http.MethodGet).HandlerFunc(LogMW(ErrMW(api.DriversList)))
	r.Path("/driver").Methods(http.MethodPost).HandlerFunc(LogMW(ErrMW(api.RegisterDriver)))
	r.Path("/car").Methods(http.MethodPost).HandlerFunc(LogMW(ErrMW(api.AddCar)))
	r.Path("/balance").Methods(http.MethodPost).HandlerFunc(LogMW(ErrMW(api.ReplenishBalance)))
	r.Path("/station").Methods(http.MethodGet).HandlerFunc(LogMW(ErrMW(api.StationsList)))
	r.Path("/station").Methods(http.MethodPost).HandlerFunc(LogMW(ErrMW(api.RegisterStation)))
	return r
}

type API struct {
	session *gocql.Session
}

func (api API) DriversList(w http.ResponseWriter, r *http.Request) (err error, code int) {
	type RestVehicle struct {
		Vehicle
		Fullness float32
		Refills  float32
	}
	type RestDriver struct {
		Id      gocql.UUID
		Name    string
		Cars    []RestVehicle
		Balance float32
	}
	var resp []RestDriver
	drivers, err := GetDrivers(api.session)
	if err != nil {
		return err, 500
	}
	for _, d := range drivers {
		var rd RestDriver
		rd.Id = d.Id
		rd.Name = d.Name
		refills, err := GetRefillsAggregation(api.session, d.Id)
		if err != nil {
			return err, 500
		}
		rd.Balance, err = GetDriverBalance(api.session, d.Id)
		if err != nil {
			return err, 500
		}

		for k, _ := range d.CarsTanks {
			fullness, err := GetCarFulness(api.session, d.Id, k)
			if err != nil {
				return err, 500
			}
			rd.Cars = append(rd.Cars, RestVehicle{Vehicle: k, Fullness: fullness, Refills: refills[k]})
		}
		resp = append(resp, rd)
	}
	b, err := json.Marshal(resp)
	if err != nil {
		return err, 500
	}
	_, err = w.Write(b)
	if err != nil {
		return err, 500
	}
	return nil, 200
}

func (api API) StationsList(w http.ResponseWriter, r *http.Request) (err error, code int) {
	type RestGasReserve struct {
		Petrol
		Volume   float32
		Turnover float32
	}
	type RestGasStation struct {
		Id      gocql.UUID
		Name    string
		Reserve []RestGasReserve
	}
	var resp []RestGasStation
	stations, err := GetGasStations(api.session)
	if err != nil {
		return err, 500
	}
	for _, d := range stations {
		var rr RestGasStation
		rr.Id = d.Id
		rr.Name = d.Name
		turnover, err := GetTurnoverAggregation(api.session, d.Id)
		if err != nil {
			return err, 500
		}

		for k, _ := range d.LastOilReserveState {
			volume, err := GetStationGasVolume(api.session, d.Id, k)
			if err != nil {
				return err, 500
			}
			rr.Reserve = append(rr.Reserve, RestGasReserve{Petrol: k, Volume: volume, Turnover: turnover[k]})
		}
		resp = append(resp, rr)
	}
	b, err := json.Marshal(resp)
	if err != nil {
		return err, 500
	}
	_, err = w.Write(b)
	if err != nil {
		return err, 500
	}
	return nil, 200
}

func (api API) RegisterDriver(w http.ResponseWriter, r *http.Request) (err error, code int) {
	b, err := ioutil.ReadAll(r.Body)
	defer r.Body.Close()
	var input map[string]string
	if err := json.Unmarshal(b, &input); err != nil {
		return err, http.StatusBadRequest
	}
	name, ok := input["Name"]
	if !ok || name == "" {
		return fmt.Errorf("Name field is mandatory non-empty string"), http.StatusBadRequest
	}
	if id, err := RegisterDriver(api.session, name); err != nil {
		return err, http.StatusInternalServerError
	} else {
		out, err := json.Marshal(map[string]interface{}{
			"Id": id,
		})
		if err != nil {
			return err, http.StatusInternalServerError
		}
		w.Write(out)
	}
	return nil, 200
}
func (api API) RegisterStation(w http.ResponseWriter, r *http.Request) (err error, code int) {
	b, err := ioutil.ReadAll(r.Body)
	defer r.Body.Close()
	var input map[string]string
	if err := json.Unmarshal(b, &input); err != nil {
		return err, http.StatusBadRequest
	}
	name, ok := input["Name"]
	if !ok || name == "" {
		return fmt.Errorf("Name field is mandatory non-empty string"), http.StatusBadRequest
	}
	if id, err := RegisterGasStation(api.session, name); err != nil {
		return err, http.StatusInternalServerError
	} else {
		out, err := json.Marshal(map[string]interface{}{
			"Id": id,
		})
		if err != nil {
			return err, http.StatusInternalServerError
		}
		w.Write(out)
	}
	return nil, 200
}
func (api API) AddCar(w http.ResponseWriter, r *http.Request) (err error, code int) {
	b, err := ioutil.ReadAll(r.Body)
	defer r.Body.Close()
	type In struct {
		DriverId    gocql.UUID
		Model       string
		PlateNumber string
		TankVolume  float32
	}
	var input In
	input.TankVolume = -1.
	if err := json.Unmarshal(b, &input); err != nil {
		return err, http.StatusBadRequest
	}
	var defaultUUID = gocql.UUID{}
	if input.Model == "" || input.PlateNumber == "" || input.TankVolume == 1. || input.DriverId == defaultUUID {
		return fmt.Errorf("Check mandatory fields"), http.StatusBadRequest
	}
	var car Vehicle
	car.Model = input.Model
	car.PlateNumber = input.PlateNumber
	car.TankVolume = input.TankVolume
	if err := DriverAddCar(api.session, input.DriverId, car); err != nil {
		return err, http.StatusInternalServerError
	} else {
		out, err := json.Marshal(map[string]interface{}{})
		if err != nil {
			return err, http.StatusInternalServerError
		}
		w.Write(out)
	}
	return nil, 200
}

func (api API) ReplenishBalance(w http.ResponseWriter, r *http.Request) (err error, code int) {
	b, err := ioutil.ReadAll(r.Body)
	defer r.Body.Close()
	type In struct {
		DriverId gocql.UUID
		Amount   float32
	}
	var input In
	input.Amount = -1.
	if err := json.Unmarshal(b, &input); err != nil {
		return err, http.StatusBadRequest
	}
	var defaultUUID = gocql.UUID{}
	if input.DriverId == defaultUUID || input.Amount == -1. {
		return fmt.Errorf("Check mandatory fields"), http.StatusBadRequest
	}
	if input.Amount < 0. {
		return fmt.Errorf("Amount must be greater than zero"), http.StatusBadRequest
	}
	if err := ReplenishDriverBalance(api.session, input.DriverId, input.Amount); err != nil {
		return err, http.StatusInternalServerError
	} else {
		out, err := json.Marshal(map[string]interface{}{})
		if err != nil {
			return err, http.StatusInternalServerError
		}
		w.Write(out)
	}
	return nil, 200
}
func ErrMW(f func(w http.ResponseWriter, r *http.Request) (error, int)) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		err, code := f(w, r)
		if err != nil {
			log.Printf("%s %s got error %s", r.Method, r.URL, err)
			msg, _ := json.Marshal(map[string]string{
				"error": err.Error(),
			})
			w.Header().Add("Content-Type", "application/json")
			w.WriteHeader(code)
			w.Write(msg)
		}
	}
}

func LogMW(f func(w http.ResponseWriter, r *http.Request)) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s started", r.Method, r.URL)
		s := time.Now()
		f(w, r)
		log.Printf("%s %s finished: elapsed %v s", r.Method, r.URL, time.Now().Sub(s).Seconds())
	}
}

func ExampleHandler(w http.ResponseWriter, r *http.Request) (error, int) {
	return fmt.Errorf("My custom error"), http.StatusBadRequest
}
