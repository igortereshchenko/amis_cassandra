# from django.db import models
from cassandra.cqlengine.usertype import UserType
from cassandra.cqlengine import columns
from cassandra.cqlengine.models import Model


class Product(UserType):
    id = columns.Integer(primary_key=True)
    name = columns.Text()
    value_type = columns.Text()
    price = columns.Double()


# class Person(models.Model):
#     first_name = models.CharField(max_length=30)
#     last_name = models.CharField(max_length=30)

class User(Model):
    __keyspace__ = 'sergienko'
    user_id = columns.Integer(primary_key=True)
    user_balance = columns.Double()


class Shop(Model):
    __keyspace__ = 'sergienko'
    id = columns.Integer(primary_key=True)
    shop_id = columns.Integer(index=True)
    descendant = columns.Integer(index=True)
    product_type = columns.UserDefinedType(Product, index=True)
    got_product = columns.Double()
    has_product = columns.Double()
    sold_product = columns.Double()


class UserOrderList(Model):
    __keyspace__ = 'sergienko'
    id = columns.Integer(primary_key=True)
    user_id = columns.Integer()
    shop_id = columns.Integer()
    user_want_list = columns.Map(columns.UserDefinedType(Product), columns.Double())
    user_got_list = columns.Map(columns.UserDefinedType(Product), columns.Double())
    # name = Text(primary_key=True)
    # addr = UserDefinedType(Product)


# columns.sync_table(UserOrderList)
