"use strict";
var data = {
    Drivers: [],
    DriversInProgress: false,
    GasStations: [],
    GasStationsInProgress: false,
    Error: null,
    ShowNewDriverPopup: false,
    NewCarPopup: false,
    BalanceReplenishPopup: false,
    NewStationPopup: false,
    StationReplenishPopup: false,
    RefillPopup: false,
    SpendingPopup: false,
};

function Client(apiURL, data) {
    this.baseUrl = apiURL;
    this.data = data;
}

Client.prototype.reloadDrivers = function() {
    var self = this;
    if (self.data.DriversInProgress) return;
    self.data.Drivers = []
    self.data.DriversInProgress = true;
    setTimeout(function() {
    fetch(self.baseUrl + 'driver')
        .then(resp => resp.json())
        .then(data => {
            self.data.DriversInProgress = false;
            self.data.Drivers = data;
        })
        .catch(e => {
            console.log(e);
            self.data.DriversInProgress = false;
            self.data.Error = e;
        })
    }, 100);
}

Client.prototype.reloadGasStations = function() {
    var self = this;
    if (self.data.GasStationsInProgress) return;
    self.data.GasStations = []
    self.data.GasStationsInProgress = true;
    fetch(self.baseUrl + 'station')
        .then(resp => resp.json())
        .then(data => {
            self.data.GasStationsInProgress = false;
            self.data.GasStations = data;
        })
        .catch(e => {
            console.log(e);
            self.data.GasStationsInProgress = false;
            self.data.Error = e;
        })
}

Client.prototype.registerDriver = function(name) {
    var self = this;
    return fetch(self.baseUrl + 'driver', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({Name: name})
    });
}
Client.prototype.addCar = function(driverId, model, plateNumber, tankVolume) {
    var self = this;
    return fetch(self.baseUrl + 'car', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({
            DriverId: driverId,
            Model: model,
            PlateNumber: plateNumber,
            TankVolume: tankVolume
        })
    });
}
Client.prototype.replenishBalance = function(driverId, amount) {
    var self = this;
    return fetch(self.baseUrl + 'balance', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({
            DriverId: driverId,
            Amount: amount
        })
    });
}
Client.prototype.registerStation = function(name) {
    var self = this;
    return fetch(self.baseUrl + 'station', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({Name: name})
    });
}
Client.prototype.replenishGas = function(stationId, petrol, price, amount) {
    var self = this;
    return fetch(self.baseUrl + 'gas', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({
            StationId: stationId,
            Petrol: {
                Name: petrol,
                Price: price
            },
            Amount: amount
        })
    });
}
Client.prototype.refill = function(driverId, car, stationId, petrol, amount) {
    var self = this;
    return fetch(self.baseUrl + 'refill', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({
            DriverId: driverId,
            Car: car,
            StationId: stationId,
            Petrol: petrol,
            Amount: amount
        })
    });
}
Client.prototype.spend = function(driverId, car, amount) {
    var self = this;
    return fetch(self.baseUrl + 'spend', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'POST',
        body: JSON.stringify({
            DriverId: driverId,
            Car: car,
            Amount: amount
        })
    });
}
Client.prototype.deleteDriver = function(driverId) {
    var self = this;
    return fetch(self.baseUrl + 'driver', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'DELETE',
        body: JSON.stringify({
            DriverId: driverId,
        })
    });
}
Client.prototype.deleteStation = function(stationId) {
    var self = this;
    return fetch(self.baseUrl + 'station', {
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        method:'DELETE',
        body: JSON.stringify({
            StationId: stationId,
        })
    });
}
var client = new Client(window.location.protocol + '//' + window.location.host + '/api/', data)
client.reloadDrivers()
client.reloadGasStations()
