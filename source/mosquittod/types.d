///
module mosquittod.types;

///
enum MOSQ_LOG
{
    NONE        = 0, ///
    INFO        = 1<<0, ///
    NOTICE      = 1<<1, ///
    WARNING     = 1<<2, ///
    ERR         = 1<<3, ///
    DEBUG       = 1<<4, ///
    SUBSCRIBE   = 1<<5, ///
    UNSUBSCRIBE = 1<<6, ///
    WEBSOCKETS  = 1<<7, ///
    INTERNAL    = 0x80000000U, ///
    ALL         = 0xFFFFFFFFU, ///
}

///
enum MOSQ_ERR 
{
    AUTH_CONTINUE = -4, ///
    NO_SUBSCRIBERS = -3, ///
    SUB_EXISTS = -2, ///
    CONN_PENDING = -1, ///
    SUCCESS = 0, ///
    NOMEM = 1, ///
    PROTOCOL = 2, ///
    INVAL = 3, ///
    NO_CONN = 4, ///
    CONN_REFUSED = 5, ///
    NOT_FOUND = 6, ///
    CONN_LOST = 7, ///
    TLS = 8, ///
    PAYLOAD_SIZE = 9, ///
    NOT_SUPPORTED = 10, ///
    AUTH = 11, ///
    ACL_DENIED = 12, ///
    UNKNOWN = 13, ///
    ERRNO = 14, ///
    EAI = 15, ///
    PROXY = 16, ///
    PLUGIN_DEFER = 17, ///
    MALFORMED_UTF8 = 18, ///
    KEEPALIVE = 19, ///
    LOOKUP = 20, ///
    MALFORMED_PACKET = 21, ///
    DUPLICATE_PROPERTY = 22, ///
    TLS_HANDSHAKE = 23, ///
    QOS_NOT_SUPPORTED = 24, ///
    OVERSIZE_PACKET = 25, ///
    OCSP = 26, ///
}

///
enum MOSQ_OPT
{
    PROTOCOL_VERSION = 1, ///
    SSL_CTX = 2, ///
    SSL_CTX_WITH_DEFAULTS = 3, ///
    RECEIVE_MAXIMUM = 4, ///
    SEND_MAXIMUM = 5, ///
    TLS_KEYFORM = 6, ///
    TLS_ENGINE = 7, ///
    TLS_ENGINE_KPASS_SHA1 = 8, ///
    TLS_OCSP_REQUIRED = 9, ///
    TLS_ALPN = 10, ///
}

///
enum MQTT_PROTOCOL
{
    V31  = 3, ///
    V311 = 4, ///
    V5   = 5, ///
}

///
struct mosquitto_message
{
    ///
    int mid;
    ///
    char* topic;
    ///
    void* payload;
    ///
    int payloadlen;
    ///
    int qos;
    ///
    bool retain;
}

///
alias mosquitto = void;

///
alias mosquitto_property = void;

///
struct libmosquitto_will
{
    ///
    char *topic;
    ///
    void *payload;
    ///
    int payloadlen;
    ///
    int qos;
    ///
    bool retain;
}

    ///
struct libmosquitto_auth
{
    ///
    char *username;
    ///
    char *password;
}

///
alias mosq_tls_callback = extern(C) int function(char*, int, int, void*);

///
struct libmosquitto_tls
{
    ///
    char *cafile;
    ///
    char *capath;
    ///
    char *certfile;
    ///
    char *keyfile;
    ///
    char *ciphers;
    ///
    char *tls_version;
    ///
    mosq_tls_callback pw_callback;
    ///
    int cert_reqs;
}

extern(C)
{
    alias mosq_base_callback = void function(mosquitto*, void*, int);
    alias mosq_wf_callback   = void function(mosquitto*, void*, int, int);
    alias mosq_msg_callback  = void function(mosquitto*, void*, const mosquitto_message*);
    alias mosq_sub_callback  = void function(mosquitto*, void*, int, int, const int*);
    alias mosq_log_callback  = void function(mosquitto*, void*, int, const(char)*);

    alias mosq_v5_base1_callback = void function(mosquitto*, void*, int, const mosquitto_property*);
    alias mosq_v5_base2_callback = void function(mosquitto*, void*, int, int, const mosquitto_property*);
    alias mosq_v5_msg_callback  = void function(mosquitto*, void*, const mosquitto_message*, const mosquitto_property*);
    alias mosq_v5_sub_callback  = void function(mosquitto*, void*, int, int, const int*, const mosquitto_property*);
}