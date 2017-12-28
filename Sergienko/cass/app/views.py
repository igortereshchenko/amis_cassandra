from django.http import Http404
from django.db import connection
from django.shortcuts import render
from django.shortcuts import redirect
from cassandra.cqlengine import connection
from cassandra.cqlengine.management import sync_table
from cassandra.cluster import Cluster
from app.models import User, Shop, Product, UserOrderList

session = None
id = 0

def get_id():
    global id
    id += 1
    return id


def connect():
    global session
    cluster = Cluster(['127.0.0.1'])
    session = cluster.connect()
    session.set_keyspace('sergienko')
    insert = ExampleModel(description="Hello world description")
    insert.save()
    cluster.shutdown()
    return HttpResponse("Hello world")


def create_user(request):
    user_id = get_id()
    user_balance = request.POST.get('balance', '')
    User.create(user_id=user_id, user_balance=user_balance)
    return redirect('index')


def create_shop(request):
    shop_id = request.POST.get('id', '')
    shop_id = shop_id if shop_id else get_id()
    product_name = request.POST.get('product_name')
    product_value_type = request.POST.get('product_value_type')
    product_price = request.POST.get('product_price')
    id = get_id()
    product_id = get_id()
    Shop.create(id=id, shop_id=shop_id, descendant=0, product_type=Product(
        id=product_id,
        name=product_name,
        value_type=product_value_type,
        price=product_price,
        ), got_product=0, has_product=0, sold_product=0)
    return redirect('index')


def update_shop(request, record_id):
    id = get_id()
    got = float(request.POST.get('got_product'))
    sold = float(request.POST.get('sold_product'))
    shop = Shop.objects.get(id=record_id)
    print shop
    new_has_product = shop.has_product + got - sold
    if new_has_product < 0:
        return render(request, "Shop cannot have goods less then 0")
    new_recod = Shop.create(
            id=id,
            shop_id=shop.shop_id,
            descendant=0,
            product_type=shop.product_type,
            got_product=got,
            sold_product=sold,
            has_product=new_has_product
            )
    new_recod.save()
    shop.descendant = new_recod.id
    shop.save()
    return redirect(index)


def update_user(request, user_id):
    user = User.objects.get(user_id=user_id)
    user.user_balance = request.POST.get('balance')
    user.save()
    return redirect('index')


def add_to_wish_list(request):
    id = get_id()
    user_id = request.POST.get('user_id')
    shop_id = request.POST.get('shop_id')
    product_name = request.POST.get('product_name')
    product_value_type = request.POST.get('product_value_type')
    product_price = request.POST.get('product_price')
    product_amount = request.POST.get('product_amount')
    UserOrderList.create(
            id=id,
            user_id=user_id,
            shop_id=shop_id,
            user_want_list={Product(
                id=0,
                name=product_name,
                value_type=product_value_type,
                price=product_price
                ): product_amount},
            user_got_list=None,
            )
    return redirect('index')


def sell(request, order_id):
    order = UserOrderList.objects.get(id=order_id)
    user = User.objects.get(user_id=order.user_id)
    order_total_price = 0
    for key in order.user_want_list.keys():
        order_total_price += order.user_want_list[key] * key.price
        shop = [shop for shop in Shop.objects.filter(shop_id=order.shop_id,
            descendant=0).allow_filtering()]
        # print dir(shop)
        # print shop.__dict__
        shop = shop[0]
        print shop.has_product
        print order.user_want_list[key]
        if shop.has_product < order.user_want_list[key]:
            print "need product"
            return "shop doesn't have enough product"
        else:
            sold = order.user_want_list[key]
            new_has_product = shop.has_product - sold
            id = get_id()
            new_recod = Shop.create(
                id=id,
                shop_id=shop.shop_id,
                descendant=0,
                product_type=shop.product_type,
                got_product=0,
                sold_product=sold,
                has_product=new_has_product
                )
            new_recod.save()
            shop.descendant = new_recod.id
            shop.save()
    if order_total_price > user.user_balance:
        print "need money"
        return "user doesn't have enough money"
    else:
        user.user_balance -= order_total_price
        user.save()
        print dir(order.user_want_list)
        cluster = Cluster(['127.0.0.1'])
        session = cluster.connect()
        session.set_keyspace('sergienko')
        print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        print order.user_want_list.keys()[0]
        query = "INSERT INTO user_order_list (id, user_got_list) VALUES (%s, %s) " % (order.id,
                str({(
                    order.user_want_list.keys()[0]['id'],
                    str(order.user_want_list.keys()[0]['name']),
                    str(order.user_want_list.keys()[0]['value_type']),
                    order.user_want_list.keys()[0]['price']
                    ):order.user_want_list[order.user_want_list.keys()[0]]}))

        session.execute(query)
    return redirect('index')




def index(request):
    # Product.create(name="milk", value_type="lt", price=1.00)
    users = [user for user in User.objects.all()]
    shops = [shop for shop in Shop.objects.filter(descendant=0)]
    cluster = Cluster(['127.0.0.1'])
    session = cluster.connect()
    session.set_keyspace('sergienko')
    shop_sum = []
    for shop in shops:
        try:
            query = ("select get_income_outcome_sum(got_product, sold_product) from shop where shop_id=%s and" +
            " product_type=%s " + "ALLOW FILTERING") % (
                shop.shop_id, str((
                    shop.product_type.id,
                    str(shop.product_type.name),
                    str(shop.product_type.value_type),
                    shop.product_type.price)
                ))
            print query
            result = session.execute(query)
            print result[0][0]
            shop_sum.append([shop.shop_id, result[0][0]])
        except Exception as e:
            print e
    orders = [order for order in UserOrderList.objects.all()]
    context = {
            'users': users,
            'shops': shops,
            'shop_sum': shop_sum,
            'orders': orders,

            }
    return render(request, 'init.html', context)
