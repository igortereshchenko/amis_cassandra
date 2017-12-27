app.controller('usercredit',
    ['$scope', '$location', 'Bank','Client', 'Credit', 'BankOperation','$cookies',
    ($scope, $location, Bank, Client, Credit, BankOperation, $cookies) => {

                $scope.selectedWishListItem;
                $scope.findAll = () => {
                    BankOperation.findCredits({})
                        .$promise.then((banks) => {
                            $scope.bankOperations = banks;
                        })
                        .catch((err) => {
                            console.log(err);
                        });
                }

                $scope.findAllBanks = () => {
                    Bank.findAll({})
                        .$promise.then((banks) => {
                            $scope.banks = banks;
                        })
                        .catch((err) => {
                            console.log(err);
                        });
                }

                $scope.findAllCredits = () => {
                    Credit.findAll({})
                        .$promise.then((credits) => {
                            $scope.credits = credits;
                        })
                        .catch((err) => {
                            console.log(err);
                        });
                }

                $scope.createLoan = (bank, credit, user) => {
                    if (bank, credit, user) {
                        BankOperation.create({
                                bankId: bank.bank_id,
                                creditId: credit.credit_id,
                                userId: user,
                                remaining: credit.debt
                            })
                            .$promise.then((wishItem) => {
                                $scope.bankOperations.push(wishItem);
                            })
                            .catch((err) => {
                                console.log(err);
                            });
                    } else {
                        alert('Bank, credit, user are required');
                    }
                }

                $scope.payMoney = (bank, credit, user, payedMoney) => {
                    if (bank, credit, user) {
                        BankOperation.create({
                                bankId: bank.bank_id,
                                creditId: credit.credit_id,
                                userId: user,
                                userBalAcc: parseInt(payedMoney)
                            })
                            .$promise.then((payedMoney) => {
                                $scope.bankOperations.push(payedMoney);
                            })
                            .catch((err) => {
                                console.log(err);
                            });
                    } else {
                        alert('Bank, credit, user are required');
                    }
                }


                $scope.select = (bank, $event) => {
                    $scope.createLoan = bank.bank_operation_id;
                }

                $scope.selectedBank = (bank) => {
                    $scope.users = bank.users;
                }
                $scope.selectedBankMoneyFunc = (bank) => {
                    $scope.usersMoney = bank.users;
                }

                $scope.closedCredits = (user_id, bank_id) => {
                    if (user_id && bank_id) {
                        BankOperation.findClosedCredits({userId:user_id})
                        .$promise.then((ops) => {
                            $scope.bankOperations = ops;
                        })
                        .catch((err) => {
                            console.log(err);
                        });
                    } else {
                        alert('Bank and user are required');
                    }

                }

                $scope.payingProcess = (user_id, bank_id) => {
                    if (user_id && bank_id){
                        BankOperation.findPayingProcess({userId:user_id})
                        .$promise.then((ops) => {
                            $scope.bankOperations = ops;
                        })
                        .catch((err) => {
                            console.log(err);
                        });
                    } else {
                        alert('Bank and user are required');
                    }

                }

                $scope.newCredits = (user_id, bank_id) => {
                    if (user_id && bank_id){
                        BankOperation.findNewCredits({userId:user_id})
                        .$promise.then((ops) => {
                            $scope.bankOperations = ops;
                        })
                        .catch((err) => {
                            console.log(err);
                        });
                    } else {
                        alert('Bank and user are required');
                    }
                }

                $scope.selectedBankSituation = (bank) => {
                    $scope.usersSituation = bank.users;
                }

                $scope.findAll();
                $scope.findAllBanks();
                $scope.findAllCredits();

    }]
);
