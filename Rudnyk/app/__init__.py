from flask import Flask

from app.config import app_config
from app.cassandra_api import api


def create_app(config_name):
    if config_name is None:
        config_name = 'development'

    app = Flask(__name__)
    app.config.from_object(app_config.get(config_name))
    app.config.from_pyfile('config.py')

    # register blueprints
    app.register_blueprint(api)

    return app
