from .base import *

# Database
# https://docs.djangoproject.com/en/2.1/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'HOST': '172.31.11.241',  # 'database-1.cyyodr81nqth.ap-northeast-1.rds.amazonaws.com',
        'NAME': 'mqtt',
        'USER': 'mqtt',
        'PASSWORD': '123456',
        'PORT': 3306,
        'OPTIONS': {
            'charset': 'utf8mb4',
        }
    }
}

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": [
            "redis://redis-client.ug7wg6.0001.apne1.cache.amazonaws.com:6379/6"
        ],
        "OPTIONS": {
            'DB': 1,
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
            "SOCKET_CONNECT_TIMEOUT": 4,
            "SOCKET_TIMEOUT": 2,
            "CONNECTION_POOL_KWARGS": {'decode_responses': True}
        }
    },
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'filters': {
        'add_request_info': {
            '()': 'utils.log.filters.RequestInfoFilter',
        }
    },
    'handlers': {
        'root_handler': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'encoding': 'utf8',
            'filename': '/var/log/mqtt-im/mqtt-im.log',
            'formatter': 'verbose',
            'maxBytes': 1024 * 1024 * 50,
            'backupCount': 10
        },
    },
    'formatters': {
        'verbose': {
            'format': '%(asctime)s - %(name)s:%(lineno)s - %(levelname)s - %(message)s',
        },
    },
    'root': {
        'handlers': ['root_handler'],
        'level': 'INFO',
        'propagate': True,
    },
}

CORS_ORIGIN_WHITELIST = (

)


ALLOWED_HOSTS = [
    '*'
]

EMQ_SYSTEM_USER = 'apple004'  # CMD消息（黑名单）
EMQ_HOST = 'localhost'
EMQ_PORT = 1883

NOTICE_URL = 'http://172.31.43.150:8098/m_im/mqttim_callback'
NOTICE_OFFLINE_URL = 'http://172.31.43.150:8098/m_im/mqttim_offline_callback'
NOTICE_ONLINE_URL = 'http://172.31.43.150:8098/m_im/mqttim_online_callback'
CHECK_URL = 'http://172.31.43.150:8098/m_im/mqttim_check'

IM_MESSAGE_AES_KEY = '!0tbzk$x2p1g*lov'
IM_MESSAGE_AES_IV = 'x%j$a6nsr81rn&$e'

IS_CLEAN_ACL_CACHE = True  # 是否清除acl缓存,如果开启了，就需要配置EMQX_API_HOST
EMQX_API_HOST = 'http://localhost:8081'  # emqx的api接口host
EMQX_API_USERNAME = 'admin'
EMQX_API_PASSWORD = 'public'

BETA = True
CELERY_BROKER_URL = 'amqp://deploy:deploy1234@127.0.0.1//apple'
