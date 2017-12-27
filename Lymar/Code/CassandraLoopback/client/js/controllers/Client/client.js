app.controller('client',
    ['$scope', '$location', 'Client', 'BankOperation', '$cookies', "$window",
    ($scope, $location, Client,BankOperation, $cookies, $window) => {
        $scope.selectedId = null;
        $scope.update = {};

        $scope.findAll = () => {
            Client.findAll({})
                .$promise.then((users) => {
                    if (users) {
                        $scope.users = users;
                    }
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.delete = (user, $event) => {
            $scope.update = {};
            $event.stopPropagation()
            Client.deleteById({userId:user.user_id})
                .$promise.then((users) => {
                    $scope.users = _.filter($scope.users, (el) => el.user_id !== user.user_id);

                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.updateUser = (user) => {
            if (user.id) {
            Client.updateById({
                    userId:user.id,
                    firstname: user.name,
                    middlename: user.middlename,
                    lastname: user.lastname,
                    balance: parseInt(user.balance)
                    })
                .$promise.then((users) => {
                    _.map($scope.users, (el) => {
                        if (el.user_id === user.id){
                            el.fio.firstname = user.name;
                            el.fio.middlename = user.middlename;
                            el.fio.lastname = user.lastname;
                            el.balance = user.balance;
                        }
                        return el;
                    });
                    alert('success');
                    $scope.update = {};
                    $scope.selectedId = null;
                })
                .catch((err) => {
                    console.log(err);
                });
            } else {
                alert('Select user from table');
            }
        }

        $scope.create = (name, middlename, lastname) => {
            if (name || middlename || lastname) {
                Client.create({
                        middlename: middlename,
                        firstname:name,
                        lastname: lastname
                    })
                    .$promise.then((users) => {
                        $scope.users.push(users);
                        $scope.name = '';
                        $scope.middlename = '';
                        $scope.lastname = '';
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert("Enter user data in fields");
            }
        }

        $scope.select = (user, $event) => {
            $scope.update.id = user.user_id
            $scope.update.name = user.fio.firstname;
            $scope.update.middlename = user.fio.middlename;
            $scope.update.lastname= user.fio.lastname;
            $scope.update.balance= user.balance;
            $scope.selectedId = user.user_id;
            $scope.countedBanks = '';
        }

        $scope.showCountedBanks = (user) => {
            if (user && user.id) {
                BankOperation.userBanks({userId:user.id})
                .$promise.then((users) => {
                    const temp = Object.values(users[0]);
                    $scope.countedBanks = temp[0];
                })
                .catch((err) => {
                    console.log(err);
                    alert("You don't have any credit in banks")
                });
            } else {
                alert('Select user from table');
            }

        }

        $scope.findAll();
    }]
);
