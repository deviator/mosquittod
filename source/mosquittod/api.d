module mosquittod.api;

import mosquittod.types;

import ssll;

import std.exception : enforce;

version (Posix)   private enum libNames = ["libmosquitto.so", "libmosquitto.so.1"];
version (Windows) private enum libNames = ["mosquitto.dll"];

private __gshared void* lib;

///
int initMosquittoLib(LoadApiSymbolsVerbose verb=LoadApiSymbolsVerbose.message)
{
    if (lib !is null) return MOSQ_ERR.SUCCESS;

    foreach (name; libNames)
    {
        lib = loadLibrary(name);
        if (lib !is null) break;
    }
    enforce(lib, "can't load libmosquitto");

    loadApiSymbols(verb);
    return mosquitto_lib_init();
}

///
int[3] mosquittoLibVersion()
{
    int[3] ver;
    mosquitto_lib_version(&ver[0], &ver[1], &ver[2]);
    return ver;
}

///
void cleanupMosquittoLib()
{
    mosquitto_lib_cleanup();
    unloadLibrary(lib);
}

mixin SSLL_INIT;

@api("lib"):
int mosquitto_lib_version(
    int* major,
    int* minor,
    int* revision) { mixin(SSLL_CALL); }

int mosquitto_lib_init() { mixin(SSLL_CALL); }

int mosquitto_lib_cleanup() { mixin(SSLL_CALL); }


mosquitto* mosquitto_new(
    const(char)* id,
    bool clean_session,
    void* obj) { mixin(SSLL_CALL); }

void mosquitto_destroy(mosquitto* mosq) { mixin(SSLL_CALL); }

int mosquitto_reinitialise(
    mosquitto* mosq,
    const(char)* id,
    bool clean_session,
    void* obj) { mixin(SSLL_CALL); }


int mosquitto_will_set(
    mosquitto* mosq,
    const(char)* topic,
    int payloadlen,
    const(void)* payload,
    int qos,
    bool retain) { mixin(SSLL_CALL); }

int mosquitto_will_set_v5(
    mosquitto* mosq,
    const(char)* topic,
    int payloadlen,
    const(void)* payload,
    int qos,
    bool retain,
    mosquitto_property* prop) { mixin(SSLL_CALL); }

int mosquitto_will_clear(mosquitto* mosq) { mixin(SSLL_CALL); }


int mosquitto_username_pw_set(
    mosquitto* mosq,
    const(char)* username,
    const(char)* password) { mixin(SSLL_CALL); }


int mosquitto_connect(
    mosquitto* mosq,
    const(char)* host,
    int port,
    int keepalive) { mixin(SSLL_CALL); }

int mosquitto_connect_bind(
    mosquitto* mosq,
    const(char)* host,
    int port,
    int keepalive,
    const(char)* bind_address) { mixin(SSLL_CALL); }

int mosquitto_connect_bind_v5(
    mosquitto* mosq,
    const(char)* host,
    int port,
    int keepalive,
    const(char)* bind_address,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }

int mosquitto_connect_async(
    mosquitto* mosq,
    const(char)* host,
    int port,
    int keepalive) { mixin(SSLL_CALL); }

int mosquitto_connect_bind_async(
    mosquitto* mosq,
    const(char)* host,
    int port,
    int keepalive,
    const(char)* bind_address) { mixin(SSLL_CALL); }

int mosquitto_connect_srv(
    mosquitto* mosq,
    const(char)* host,
    int keepalive,
    const(char)* bind_address) { mixin(SSLL_CALL); }

int mosquitto_reconnect(mosquitto* mosq) { mixin(SSLL_CALL); }

int mosquitto_reconnect_async(mosquitto* mosq) { mixin(SSLL_CALL); }

int mosquitto_disconnect(mosquitto* mosq) { mixin(SSLL_CALL); }

int mosquitto_disconnect_v5(
    mosquitto* mosq,
    int reason,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }


int mosquitto_publish(
    mosquitto* mosq,
    int* mid,
    const(char)* topic,
    int payloadlen,
    const(void)* payload,
    int qos,
    bool retain) { mixin(SSLL_CALL); }

int mosquitto_publish_v5(
    mosquitto* mosq,
    int* mid,
    const(char)* topic,
    int payloadlen,
    const(void)* payload,
    int qos,
    bool retain,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }

int mosquitto_subscribe(
    mosquitto* mosq,
    int* mid,
    const(char)* sub,
    int qos) { mixin(SSLL_CALL); }

int mosquitto_subscribe_v5(
    mosquitto* mosq,
    int* mid,
    const(char)* sub,
    int qos,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }

int mosquitto_subscribe_multiple(
    mosquitto* mosq,
    int* mid,
    int sub_count,
    const(char)** sub,
    int qos,
    int options,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }

int mosquitto_unsubscribe(
    mosquitto* mosq,
    int* mid,
    const(char)* sub) { mixin(SSLL_CALL); }

int mosquitto_unsubscribe_v5(
    mosquitto* mosq,
    int* mid,
    const(char)* sub,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }

int mosquitto_unsubscribe_multiple(
    mosquitto* mosq,
    int *mid,
    int sub_count,
    const(char)** sub,
    const mosquitto_property* prop) { mixin(SSLL_CALL); }


int mosquitto_message_copy(
    mosquitto_message* dst,
    const mosquitto_message* src) { mixin(SSLL_CALL); }

void mosquitto_message_free(mosquitto_message** message) { mixin(SSLL_CALL); }

void mosquitto_message_free_contents(mosquitto_message* message) { mixin(SSLL_CALL); }


int mosquitto_loop_forever(
    mosquitto* mosq,
    int timeout,
    int max_packets) { mixin(SSLL_CALL); }

int mosquitto_loop_start(mosquitto* mosq) { mixin(SSLL_CALL); }

int mosquitto_loop_stop(
    mosquitto* mosq,
    bool force) { mixin(SSLL_CALL); }

int mosquitto_loop(
    mosquitto* mosq,
    int timeout,
    int max_packets) { mixin(SSLL_CALL); }


int mosquitto_loop_read(
    mosquitto* mosq,
    int max_packets) { mixin(SSLL_CALL); }

int mosquitto_loop_write(
    mosquitto* mosq,
    int max_packets) { mixin(SSLL_CALL); }

int mosquitto_loop_misc(mosquitto* mosq) { mixin(SSLL_CALL); }


int mosquitto_socket(mosquitto* mosq) { mixin(SSLL_CALL); }

bool mosquitto_want_write(mosquitto* mosq) { mixin(SSLL_CALL); }

int mosquitto_threaded_set(
    mosquitto* mosq,
    bool threaded) { mixin(SSLL_CALL); }


//deprecated("use 'mosquitto_int_option' or 'mosquitto_void_option'")
//int mosquitto_opts_set(mosquitto* mosq,
//                       MOSQ_OPT option,
//                       void* value) { mixin(SSLL_CALL); }

int mosquitto_int_option(
    mosquitto* mosq,
    MOSQ_OPT option,
    int value) { mixin(SSLL_CALL); }

int mosquitto_void_option(
    mosquitto* mosq,
    MOSQ_OPT option,
    void* value) { mixin(SSLL_CALL); }

int mosquitto_string_option(
    mosquitto* mosq,
    MOSQ_OPT option,
    const(char)* value) { mixin(SSLL_CALL); }

void mosquitto_user_data_set(
    mosquitto* mosq,
    void* obj) { mixin(SSLL_CALL); }

void* mosquitto_userdata(mosquitto* mosq) { mixin(SSLL_CALL); }


int mosquitto_tls_set(
    mosquitto* mosq,
    const(char)* cafile,
    const(char)* capath,
    const(char)* certfile,
    const(char)* keyfile,
    mosq_tls_callback pw_callback) { mixin(SSLL_CALL); }

int mosquitto_tls_insecure_set(
    mosquitto* mosq,
    bool value) { mixin(SSLL_CALL); }

int mosquitto_tls_opts_set(
    mosquitto* mosq,
    int cert_reqs,
    const(char)* tls_version,
    const(char)* ciphers) { mixin(SSLL_CALL); }

int mosquitto_tls_psk_set(
    mosquitto* mosq,
    const(char)* psk,
    const(char)* identity,
    const(char)* ciphers) { mixin(SSLL_CALL); }


void mosquitto_connect_callback_set(
    mosquitto* mosq,
    mosq_base_callback on_connect) { mixin(SSLL_CALL); }

void mosquitto_connect_with_flags_callback_set(
    mosquitto* mosq,
    mosq_wf_callback on_connect) { mixin(SSLL_CALL); }

void mosquitto_connect_v5_callback_set(
    mosquitto* mosq,
    mosq_v5_base2_callback on_connect) { mixin(SSLL_CALL); }

void mosquitto_disconnect_callback_set(
    mosquitto* mosq,
    mosq_base_callback on_disconnect) { mixin(SSLL_CALL); }

void mosquitto_disconnect_v5_callback_set(
    mosquitto* mosq,
    mosq_v5_base1_callback on_disconnect) { mixin(SSLL_CALL); }

void mosquitto_publish_callback_set(
    mosquitto* mosq,
    mosq_base_callback on_publish) { mixin(SSLL_CALL); }

void mosquitto_publish_v5_callback_set(
    mosquitto* mosq,
    mosq_v5_base2_callback on_publish) { mixin(SSLL_CALL); }

void mosquitto_message_callback_set(
    mosquitto* mosq,
    mosq_msg_callback on_message) { mixin(SSLL_CALL); }

void mosquitto_message_v5_callback_set(
    mosquitto* mosq,
    mosq_v5_msg_callback on_message) { mixin(SSLL_CALL); }

void mosquitto_subscribe_callback_set(
    mosquitto* mosq,
    mosq_sub_callback on_subscribe) { mixin(SSLL_CALL); }

void mosquitto_subscribe_v5_callback_set(
    mosquitto* mosq,
    mosq_v5_sub_callback on_subscribe) { mixin(SSLL_CALL); }

void mosquitto_unsubscribe_callback_set(
    mosquitto* mosq,
    mosq_base_callback on_unsubscribe) { mixin(SSLL_CALL); }

void mosquitto_unsubscribe_v5_callback_set(
    mosquitto* mosq,
    mosq_v5_base1_callback on_unsubscribe) { mixin(SSLL_CALL); }

void mosquitto_log_callback_set(
    mosquitto* mosq,
    mosq_log_callback on_log) { mixin(SSLL_CALL); }

int mosquitto_reconnect_delay_set(
    mosquitto* mosq,
    uint reconnect_delay,
    uint reconnect_delay_max,
    bool reconnect_exponential_backoff) { mixin(SSLL_CALL); }

int mosquitto_socks5_set(
    mosquitto* mosq,
    const(char)* host,
    int port,
    const(char)* username,
    const(char)* password) { mixin(SSLL_CALL); }

const(char)* mosquitto_strerror(int mosq_errno) { mixin(SSLL_CALL); }

const(char)* mosquitto_connack_string(int connack_code) { mixin(SSLL_CALL); }

const(char)* mosquitto_reason_string(int reason_code) { mixin(SSLL_CALL); }

int mosquitto_string_to_command(
    const(char)* str,
    int* cmd) { mixin(SSLL_CALL); }

int mosquitto_sub_topic_tokenise(
    const(char)* subtopic,
    char*** topics,
    int* count) { mixin(SSLL_CALL); }

int mosquitto_sub_topic_tokens_free(
    char*** topics,
    int count) { mixin(SSLL_CALL); }

int mosquitto_topic_matches_sub(
    const(char)* sub,
    const(char)* topic,
    bool* result) { mixin(SSLL_CALL); }

int mosquitto_topic_matches_sub2(
    const(char)* sub,
    size_t sublen,
    const(char)* topic,
    size_t topiclen,
    bool* result) { mixin(SSLL_CALL); }

int mosquitto_pub_topic_check(const(char)* topic) { mixin(SSLL_CALL); }

int mosquitto_pub_topic_check2(
    const(char)* topic,
    size_t topiclen) { mixin(SSLL_CALL); }

int mosquitto_sub_topic_check(const(char)* topic) { mixin(SSLL_CALL); }

int mosquitto_sub_topic_check2(
    const(char)* topic,
    size_t topiclen) { mixin(SSLL_CALL); }

int mosquitto_validate_utf8(
    const(char)* str,
    int len) { mixin(SSLL_CALL); }

int mosquitto_subscribe_simple(
    mosquitto_message**	messages,
    int msg_count,
    bool want_retained,
    const(char)* topic,
    int qos,
    const(char)* host,
    int port,
    const(char)* client_id,
    int keepalive,
    bool clean_session,
    const(char)* username,
    const(char)* password,
    const libmosquitto_will* will,
    const libmosquitto_tls* tls) { mixin(SSLL_CALL); }

int mosquitto_subscribe_callback(
    mosq_msg_callback callback,
    void* userdata,
    const(char)* topic,
    int qos,
    const(char)* host,
    int port,
    const(char)* client_id,
    int keepalive,
    bool clean_session,
    const(char)* username,
    const(char)* password,
    const libmosquitto_will* will,
    const libmosquitto_tls* tls) { mixin(SSLL_CALL); }


int mosquitto_property_add_byte(
    mosquitto_property** proplist,
    int identifier,
    ubyte value) { mixin(SSLL_CALL); }

int mosquitto_property_add_int16(
    mosquitto_property** proplist,
    int identifier,
    ushort value) { mixin(SSLL_CALL); }

int mosquitto_property_add_int32(
    mosquitto_property** proplist,
    int identifier,
    uint value) { mixin(SSLL_CALL); }

int mosquitto_property_add_varint(
    mosquitto_property** proplist,
    int identifier,
    uint value) { mixin(SSLL_CALL); }

int mosquitto_property_add_binary(
    mosquitto_property** proplist,
    int identifier,
    const(void)* value,
    ushort len) { mixin(SSLL_CALL); }

int mosquitto_property_add_string(
    mosquitto_property** proplist,
    int identifier,
    const(char)* value) { mixin(SSLL_CALL); }

int mosquitto_property_add_string_pair(
    mosquitto_property** proplist,
    int identifier,
    const(char)* name,
    const(char)* value) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_byte(
		const mosquitto_property* proplist,
		int identifier,
		ubyte* value,
		bool skip_first) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_int16(
		const mosquitto_property* proplist,
		int identifier,
		ushort* value,
		bool skip_first) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_int32(
		const mosquitto_property* proplist,
		int identifier,
		uint* value,
		bool skip_first) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_varint(
    const mosquitto_property* proplist,
    int identifier,
    uint* value,
    bool skip_first) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_binary(
    const mosquitto_property* proplist,
    int identifier,
    void** value,
    ushort* len,
    bool skip_first) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_string(
    const mosquitto_property *proplist,
    int identifier,
    char** value,
    bool skip_first) { mixin(SSLL_CALL); }

const(mosquitto_property)* mosquitto_property_read_string_pair(
    const mosquitto_property* proplist,
    int identifier,
    char** name,
    char** value,
    bool skip_first) { mixin(SSLL_CALL); }

void mosquitto_property_free_all(mosquitto_property** properties);

int mosquitto_property_copy_all(
    mosquitto_property** dest,
    const mosquitto_property* src) { mixin(SSLL_CALL); }

int mosquitto_property_check_command(
    int command,
    int identifier) { mixin(SSLL_CALL); }

int mosquitto_property_check_all(
    int command,
    const mosquitto_property *properties) { mixin(SSLL_CALL); }

int mosquitto_string_to_property_info(
    const(char)* propname,
    int* identifier,
    int* type) { mixin(SSLL_CALL); }