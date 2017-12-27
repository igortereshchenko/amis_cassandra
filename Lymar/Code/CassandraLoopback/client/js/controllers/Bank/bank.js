app.controller('bank',
    ['$scope', '$location', 'Bank','Client', 'BankOperation', '$cookies',
    ($scope, $location, Bank, Client, BankOperation, $cookies) => {
        $scope.update = {};
        $scope.selectedBank;
        $scope.mustRemovedUsers;
        $scope.findAll = () => {
            Bank.findAll({})
                .$promise.then((banks) => {
                    if (banks) $scope.banks = banks;
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.findAllUsers = () => {
            Client.findAll({})
                .$promise.then((users) => {
                    console.log(users);
                    $scope.users = users;
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.delete = (bank, $event) => {
            $scope.update = {};
            $event.stopPropagation();
            Bank.deleteById({bankId:bank.bank_id})
                .$promise.then((banks) => {
                    $scope.banks = _.filter($scope.banks, (el) => el.bank_id !== bank.bank_id);
                })
                .catch((err) => {
                    console.log(err);
                });
        }

        $scope.updateBank = (bank) => {
            if (bank.id) {
                Bank.updateById({
                        bankId:bank.id,
                        bankname: bank.name
                    })
                    .$promise.then((banks) => {
                        _.map($scope.banks, (el) => {
                            if (el.bank_id === bank.id) el.bank_name = bank.name;
                            return el;
                        });
                        $scope.update = {};
                        $scope.selectedId = null;
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert('Select bank from table');
            }

        }

        $scope.create = (bankname) => {
            if (bankname) {
                Bank.create({
                        bankname: bankname
                    })
                    .$promise.then((bank) => {
                        $scope.banks.push(bank);
                        $scope.bankname = '';
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert('Enter bankname');
            }
        }

        $scope.select = (bank, $event) => {
            $scope.update.id = bank.bank_id;
            $scope.update.name = bank.bank_name;
            $scope.selectedId = bank.bank_id;
        }

        $scope.addUser = (user, bank) => {
            if (user && bank) {
                Bank.addUser({
                        bankId: bank.bank_id,
                        userId: user.user_id
                    })
                    .$promise.then((new_bank) => {
                        _.map($scope.banks, (el) => {
                            if (el.bank_id === new_bank.bank_id) {
                                const some = _.some(el.users, (user) => {
                                    return user === new_bank.user;
                                });
                                if (!el.users) el.users = [];
                                if (!some) {
                                    el.users.push(new_bank.user);
                                }
                            }
                            return el;
                        })
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert("Select user and bank");
            }
        }

        $scope.removeUserBank = (bank) => {
            $scope.mustRemovedUsers = bank.users;
        }

        $scope.removeUser = (user, bank) => {
            if (user && bank) {
                Bank.removeUser({
                        bankId: bank.bank_id,
                        userId: user
                    })
                    .$promise.then((new_bank) => {
                        _.map($scope.banks, (el) => {
                            if (el.bank_id === new_bank.bank_id) {
                                const some = _.some(el.users, (user) => {
                                    return user === new_bank.user;
                                });
                                if (some) {
                                    el.users = _.filter(el.users, (user) => {
                                        console.log(user !== new_bank.user)
                                        return user !== new_bank.user
                                    });
                                }
                            }
                            return el;
                        })
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            } else {
                alert("Select user or bank");
            }
        }

        $scope.showInOutCome = (bank) => {
            if (bank && bank.id) {
                BankOperation.bankMoneyInfo({bankId:bank.id})
                .$promise.then((money) => {
                    if (!money.length !== 2) {
                        const temp = Object.values(money[0]);
                        $scope.income = temp[0][0];
                        $scope.outcome = temp[0][1];
                    } else {
                        $scope.income = 0;
                        $scope.outcome = 0;
                    }
                })
                .catch((err) => {
                    console.log(err);
                });
            } else {
                alert('Select bank from table');
            }
        }

        $scope.findAll();
        $scope.findAllUsers();


    }]
);
