from django.conf.urls import url
import views

urlpatterns = [
    url(r'^create_user/$', views.create_user),
    url(r'^create_shop/$', views.create_shop),
    url(r'^add_to_wish_list/$', views.add_to_wish_list),
    url(r'^update_user/(?P<user_id>[0-9]+)/$', views.update_user),
    url(r'^update_shop/(?P<record_id>[0-9]+)/$', views.update_shop),
    url(r'^sell/(?P<order_id>[0-9]+)/$', views.sell),
    url(r'^$', views.index, name='index'),
    # url(r'^api/', include('app.urls')),
]
