Vue.component('new_driver_popup', {
    data: function() {
        console.log("new_driver_popup Data function called");
        return {
            name: '',
            error: ''
        }
    },
    methods: {
        close: function() {
            this.name = '';
            window.data.ShowNewDriverPopup = false;
        },
        register: function() {
            var self = this;
            //this.error = '';
            if (this.name == '') {
                this.error = 'Name is required';
            } else {
                window.client.registerDriver(this.name)
                    .then(resp => {
                        if (resp.status != 200) {
                            console.log(resp);
                            throw 'Failed to create new driver';
                        } else {
                            window.client.reloadDrivers();
                        }
                    })
                    .catch(e => {
                        window.data.Error = e
                    })
                    .then(() => {
                        self.close()
                    })
            }
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>New driver</p>
                <form v-on:submit.prevent="register()">
                    <input v-model="name" placeholder="Name">
                    <input type="submit" value="Add">
                    <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});
Vue.component('new_car_popup', {
    props: ['driver'],
    data: function() {
        console.log("new_car_popup Data function called");
        return {
            model: '',
            plateNumber: '',
            tankVolume: '',
            error: ''
        }
    },
    methods: {
        close: function() {
            this.model = this.plateNumber = this.tankVolume = '';
            window.data.NewCarPopup = false;
        },
        add: function() {
            var self = this;
            var fields = ['model', 'plateNumber', 'tankVolume'];
            this.error = '';
            if (this.tankVolume < 0.) {
                this.error = 'Tank Volume shoule greater than zero';
                return false;
            }
            window.client.addCar(this.driver.Id, this.model, this.plateNumber, this.tankVolume)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to add new car';
                    } else {
                        window.client.reloadDrivers();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
                .then(() => {
                    self.close()
                })
            return false;
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>Add a car to {{driver.Name}}</p>
                <form v-on:submit.prevent="add">
                <input v-model="model" placeholder="Model" required>
                <input v-model="plateNumber" placeholder="AA-0000-AA" required>
                <input v-model.number="tankVolume" placeholder="Tank volume" required>
                <input type="submit" value="Add">
                <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});

Vue.component('balance_replenish_popup', {
    props: ['driver'],
    data: function() {
        console.log("balance_replenish_popup Data function called");
        return {
            money: '',
            error: ''
        }
    },
    methods: {
        close: function() {
            this.money = '';
            window.data.BalanceReplenishPopup = false;
        },
        add: function() {
            var self = this;
            this.error = '';
            if (this.money < 0.) {
                this.error = 'Money value should be greater than zero';
                return false;
            }
            window.client.replenishBalance(this.driver.Id, this.money)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to replenish balance';
                    } else {
                        window.client.reloadDrivers();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
                .then(() => {
                    self.close()
                })
            return false;
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>Replenish {{driver.Name}} balance: {{driver.Balance}}$</p>
                <form v-on:submit.prevent="add">
                <input v-model.number="money" placeholder="$" required pattern="^[0-9]+$">
                <input type="submit" value="Add">
                <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});
Vue.component('station_replenish_popup', {
    props: ['station'],
    data: function() {
        console.log("station_replenish_popup Data function called");
        return {
            petrol: '',
            price: '',
            amount: '',
            error: ''
        }
    },
    methods: {
        close: function() {
            this.petrol = this.price = this.amount = '';
            window.data.StationReplenishPopup = false;
        },
        add: function() {
            var self = this;
            this.error = '';
            if (this.price < 0.) {
                this.error = 'Price value should be greater than zero';
                return false;
            }
            if (this.amount < 0.) {
                this.error = 'Amount value should be greater than zero';
                return false;
            }
            window.client.replenishGas(this.station.Id, this.petrol, this.price, this.amount)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to replenish gas station';
                    } else {
                        window.client.reloadGasStations();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
                .then(() => {
                    self.close()
                })
            return false;
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>Replenish {{station.Name}} gas reserve</p>
                <form v-on:submit.prevent="add">
                <input v-model="petrol" placeholder="A-95" required>
                <input v-model.number="price" placeholder="$" required pattern="^[0-9]+$">
                <input v-model.number="amount" placeholder="litres, e.g. 100" required pattern="^[0-9]+$">
                <input type="submit" value="Add">
                <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});
Vue.component('new_station_popup', {
    data: function() {
        return {
            name: '',
            error: ''
        }
    },
    methods: {
        close: function() {
            this.name = '';
            window.data.NewStationPopup = false;
        },
        add: function() {
            var self = this;
            this.error = '';
            window.client.registerStation(this.name)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to register station';
                    } else {
                        window.client.reloadGasStations();
                    }
                })
                .catch(e => {
                    console.log('Catched error');
                    console.log(e);
                    window.data.Error = e
                })
                .then(() => {
                    self.close()
                })
            return false;
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>New station</p>
                <form v-on:submit.prevent="add">
                <input v-model="name" placeholder="Gas station name" required>
                <input type="submit" value="Add">
                <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});

Vue.component('refill_popup', {
    props: {
        driver: { default: () => {} },
        car: { default: () => {} },
        stations: {default: () => []}
    },
    data: function() {
        console.log("refill Data function called");
        return {
            stationId: '',
            petrol: {},
            amount: '',
            error: ''
        }
    },
    computed: {
        petrols: function() {
            var res = [];
            for (var i = 0; i < this.stations.length; ++i) {
                var station = this.stations[i];
                if (station.Id == this.stationId) {
                    res = station.Reserve;
                }
            }
            return res;
        }
    },
    methods: {
        close: function() {
            this.stationId = '';
            this.petrol = {};
            this.amount = '';
            window.data.RefillPopup = false;
        },
        add: function() {
            var self = this;
            this.error = '';
            if (this.amount < 0.) {
                this.error = 'Amount value should be greater than zero';
                return false;
            }
            if (this.amount > this.petrol.Volume) {
                this.error = 'Amount value should not exceed station volume';
                return false;
            }
            if (this.car.Fullness + this.amount > this.car.TankVolume) {
                this.error = 'Amount value should not exceed car tank volume';
                return false;
            }
            if (this.amount * this.petrol.Price > this.driver.Balance) {
                this.error = 'Not enough funds';
                return false;
            }

            window.client.refill(this.driver.Id, this.car,
                this.stationId, this.petrol, this.amount)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to refill car';
                    } else {
                        window.client.reloadGasStations();
                        window.client.reloadDrivers();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
                .then(() => {
                    self.close()
                })
            return false;
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>Refill {{driver.Name}}: {{car.PlateNumber}} {{car.Model}}</p>
                <form v-on:submit.prevent="add">
                <select v-model:value="stationId" required>
                    <option v-for="{Id, Name} in stations" :value="Id"> {{Name}}</option>
                </select>
                <select v-model:value="petrol" required>
                    <option v-for="({Name, Price, Volume}, idx) in petrols"
                        :value="petrols[idx]">{{Name}} - {{Price}}$ - Available: {{Volume}}</option>
                </select>
                <input v-model.number="amount" placeholder="litres, e.g. 100" required pattern="^[0-9]+$">
                <input type="submit" value="Add">
                <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});

Vue.component('spending_popup', {
    props: ["driver", "car"],
    data: function() {
        return {
            amount: '',
            error: ''
        }
    },
    methods: {
        close: function() {
            this.amount = '';
            window.data.SpendingPopup = false;
        },
        add: function() {
            var self = this;
            this.error = '';
            if (this.amount > this.car.Fullness) {
                this.error = 'Amount value should not exceed amount in car tank';
                return false;
            }
            window.client.spend(this.driver.Id, this.car, this.amount)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to refill car';
                    } else {
                        window.client.reloadGasStations();
                        window.client.reloadDrivers();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
                .then(() => {
                    self.close()
                })
            return false;
        }
    },
    template: `
        <div class="fullscreen_popup">
            <div class="fullscreen_popup_content">
                <p>Refill {{driver.Name}}: {{car.PlateNumber}} {{car.Model}} {{car.Fullness}} litres</p>
                <form v-on:submit.prevent="add">
                    <input v-model.number="amount" placeholder="litres, e.g. 100" required pattern="^[0-9]+$">
                    <input type="submit" value="Add">
                    <button @click="close()">Close</button>
                </form>
                <p v-show="error">{{error}}</p>
            </div>
        </div>
    `
});




var app = new Vue({
    el: "#app",
    data: data,
    methods: {
        reloadDrivers: function() {
            window.client.reloadDrivers();
        },
        reloadGasStations: function() {
            window.client.reloadGasStations();
        },
        showDriverPopup: function() {
            this.ShowNewDriverPopup = true;
        },
        showStationPopup: function() {
            this.NewStationPopup = true;
        },
        showAddCarPopup: function(driverId) {
            var self = this;
            this.Drivers.forEach(function(el) {
                if (el.Id == driverId) {
                    self.NewCarPopup = el;
                }
            });
        },
        showBalanceReplenishPopup: function(driverId) {
            var self = this;
            this.Drivers.forEach(function(el) {
                if (el.Id == driverId) {
                    self.BalanceReplenishPopup = el;
                }
            });
        },
        showStationReplenishPopup: function(driverId) {
            var self = this;
            this.GasStations.forEach(function(el) {
                if (el.Id == driverId) {
                    self.StationReplenishPopup = el;
                }
            });
        },
        showRefillPopup: function(driver, car) {
            this.RefillPopup = {
                driver: driver,
                car: car
            };
        },
        showSpendingPopup: function(driver, car) {
            this.SpendingPopup = {
                driver: driver,
                car: car
            };
        },
        clearError: function() {
            this.Error = '';
        },
        deleteDriver: function(driverId) {
            window.client.deleteDriver(driverId)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to delete driver';
                    } else {
                        window.client.reloadDrivers();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
        },
        deleteStation: function(stationId) {
            window.client.deleteStation(stationId)
                .then(resp => {
                    if (resp.status != 200) {
                        console.log(resp);
                        throw 'Failed to delete station';
                    } else {
                        window.client.reloadGasStations();
                    }
                })
                .catch(e => {
                    window.data.Error = e
                })
        }
    },
    template: `
    <div>
        <p v-if="Error">{{Error}} <button @click="clearError()">Clear</button></p>
        <p>Drivers</p><button @click="reloadDrivers()">Reload</button>
        <p v-if="DriversInProgress">Loading...</p>
        <ul>
            <li v-for="({Id, Name, Balance, Cars}, driverIdx) in Drivers" :key="Id">
                <input :value="Id" disabled> {{Name}} {{Balance}}$ <button @click="deleteDriver(Id)">X</button>
                <table>
                    <thead>
                        <th>Model</th>
                        <th>PlateNumber</th>
                        <th>Fullness</th>
                        <th>Refills</th>
                        <th>TankVolume</th>
                        <th>Actions</th>
                    </thead>
                    <tbody>
                        <tr v-for="({Model, PlateNumber, Fullness, Refills, TankVolume}, carIdx) in Cars">
                            <td>{{Model}}</td>
                            <td>{{PlateNumber}}</td>
                            <td>{{Fullness}}</td>
                            <td>{{Refills}}</td>
                            <td>{{TankVolume}}</td>
                            <td>
                                <button @click="showRefillPopup(Drivers[driverIdx], Cars[carIdx])">Refill</button>
                                <button @click="showSpendingPopup(Drivers[driverIdx], Cars[carIdx])">Spend</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <button @click="showAddCarPopup(Id)">Add car</button>
                <button @click="showBalanceReplenishPopup(Id)">Replenish balance</button>
            </li>
            <li>
                <button @click="showDriverPopup()">Add Driver</button>
            </li>
        </ul>
        <hr>
        <p>Gas stations</p><button @click="reloadGasStations()">Reload</button>
        <p v-if="GasStationsInProgress">Loading...</p>
        <ul>
            <li v-for="{Id, Name, Reserve} in GasStations" :key="Id">
                <input :value="Id" disabled> {{Name}}
                <button @click="deleteStation(Id)">X</button>
                <table>
                    <thead>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Volume</th>
                        <th>Turnover</th>
                    </thead>
                    <tbody>
                        <tr v-for="{Name, Price, Volume, Turnover} in Reserve">
                            <td>{{Name}}</td>
                            <td>{{Price}}</td>
                            <td>{{Volume}}</td>
                            <td>{{Turnover}}</td>
                        </tr>
                    </tbody>
                </table>
                <button @click="showStationReplenishPopup(Id)">Replenish gas reserve</button>
            </li>
            <li>
                <button @click="showStationPopup()">Add Station</button>
            </li>
        </ul>
        <new_driver_popup v-show="ShowNewDriverPopup"></new_driver_popup>
        <new_station_popup v-show="NewStationPopup"></new_station_popup>
        <new_car_popup v-show="NewCarPopup" v-bind:driver="NewCarPopup"></new_car_popup>
        <balance_replenish_popup v-show="BalanceReplenishPopup" v-bind:driver="BalanceReplenishPopup"></balance_replenish_popup>
        <station_replenish_popup v-show="StationReplenishPopup" v-bind:station="StationReplenishPopup"></station_replenish_popup>
        <refill_popup v-if="RefillPopup" v-bind:stations="GasStations" v-bind:driver="RefillPopup.driver" v-bind:car="RefillPopup.car"></refill_popup>
        <spending_popup v-if="SpendingPopup" v-bind:driver="SpendingPopup.driver" v-bind:car="SpendingPopup.car"></spending_popup>
    </div>
    `
})
