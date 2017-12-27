var app = angular.module('cassandra', ['lbServices','ui.router','angular.filter','ngCookies']);

app.config(($stateProvider, $urlRouterProvider ) => {
    $urlRouterProvider.otherwise('/');
    $stateProvider
        .state('login', {
            url: '/auth',
            templateUrl: 'views/Login/login.html'
        })
        .state('client', {
            url: '/client',
            templateUrl: 'views/Client/client.html'
        })
        .state('wishlist', {
            url: '/wishlist',
            templateUrl: 'views/WishList/wishlist.html'
        })
        .state('usercredit', {
            url: '/takeloan',
            templateUrl: 'views/UserCredit/usercredit.html'
        })
        .state('bank', {
            url: '/bank',
            templateUrl: 'views/Bank/bank.html'
        })
        .state('loan', {
            url: '/loan',
            templateUrl: 'views/Loan/credit.html'
        });
});
