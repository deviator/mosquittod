module mosquittod.client;

import std.algorithm : map;
import std.exception;
import std.array : array, Appender;
import std.format : formattedWrite;
import std.string;

public import mosquittod.api;

class MosquittoException : Exception
{
    MOSQ_ERR err;
    this(MOSQ_ERR err, string func)
    {
        this.err = err;
        super(format("%s returns %d (%s)", func, err, err));
    }
}

private void mosqCheck(alias fnc, Args...)(Args args)
{
    if (auto r = cast(MOSQ_ERR)fnc(args))
        throw new MosquittoException(r, __traits(identifier, fnc));
}

class MosquittoClient
{
protected:
    mosquitto_t mosq;

    static struct Callback
    {
        string pattern;
        int qos;
        void delegate(const(char)[], const(ubyte)[]) func;
    }

    Callback[] slist;

    bool _connected;

    Appender!(char[])[] buffers;

    char* toStringzBuf(string str, size_t n=0)
    {
        if (str == "") return null;
        buffers[n].clear();
        formattedWrite(buffers[n], "%s\0", str);
        return buffers[n].data.ptr;
    }

    extern(C) static
    {
        void onConnectCallback(mosquitto_t mosq, void* cptr, int res)
        {
            auto cli = enforce(cast(MosquittoClient)cptr, "null cli");
            enum Res
            {
                success = 0,
                unacceptable_protocol_version = 1,
                identifier_rejected = 2,
                broker_unavailable = 3
            }
            enforce(res == 0, format("connection error: %s", cast(Res)res));
            cli._connected = true;
            cli.subscribeList();
            if (cli.onConnect !is null) cli.onConnect();
        }

        void onDisconnectCallback(mosquitto_t mosq, void* cptr, int res)
        {
            auto cli = enforce(cast(MosquittoClient)cptr, "null cli");
            cli._connected = false;
        }

        void onMessageCallback(mosquitto_t mosq, void* cptr,
                                const mosquitto_message* msg)
        {
            auto cli = enforce(cast(MosquittoClient)cptr, "null cli");
            cli.onMessage(msg.topic, cast(ubyte[])msg.payload[0..msg.payloadlen]);
        }
    }

    void subscribeList()
    {
        foreach (cb; slist)
            mosqCheck!mosquitto_subscribe(mosq, null,
                            toStringzBuf(cb.pattern), cb.qos);
    }

    void onMessage(const char* topicZ, const(ubyte[]) payload)
    {
        foreach (cb; slist)
        {
            bool res;
            auto patt = toStringzBuf(cb.pattern);
            mosqCheck!mosquitto_topic_matches_sub(patt, topicZ, &res);
            if (res) cb.func(topicZ.fromStringz(), payload);
        }
    }

public:
    ///
    struct Settings
    {
        string host = "127.0.0.1";
        ushort port = 1883;
        string clientId;
        bool cleanSession = true;
        int keepalive = 5;
    }

    ///
    Settings settings;

    void delegate() onConnect;

    ///
    this(Settings s=Settings.init)
    {
        import core.stdc.errno;

        initMosquittoLib();

        buffers = new Appender!(char[])[](1); // for now need only 1 buffer
        foreach (buf; buffers) buf.reserve(1024);

        settings = s;

        mosq = enforce(mosquitto_new(toStringzBuf(s.clientId),
                        s.cleanSession, cast(void*)this),
                format("error while create mosquitto: %d", errno));

        mosquitto_connect_callback_set(mosq, &onConnectCallback);
        mosquitto_message_callback_set(mosq, &onMessageCallback);
    }

    ~this() { disconnect(); }

    ///
    bool connected() const @property { return _connected; }

    ///
    void loop(int timeoutMSecs=0)
    { mosqCheck!mosquitto_loop(mosq, timeoutMSecs, 1); }

    ///
    void connect()
    {
        mosqCheck!mosquitto_connect(mosq, toStringzBuf(settings.host),
                                    settings.port, settings.keepalive);
    }

    ///
    void reconnect() { mosqCheck!mosquitto_reconnect(mosq); }

    ///
    void disconnect() { mosqCheck!mosquitto_disconnect(mosq); }

    /// publish 
    int publish(string topic, int qos, const(void)[] data, bool retain=false)
    {
        int mid;
        mosqCheck!mosquitto_publish(mosq, &mid, toStringzBuf(topic),
                            cast(int)data.length, data.ptr, qos, retain);
        return mid;
    }

    /// ditto with qos=0
    int publish(string topic, const(void)[] data, bool retain=false)
    { return publish(topic, 0, data, retain); }

    /// you need copy message data in callback if requires
    void subscribe(string pattern, int qos, void delegate(const(char)[],
                    const(ubyte)[]) cb)
    {
        slist ~= Callback(pattern, qos, cb);
        if (connected) mosqCheck!mosquitto_subscribe(mosq, null,
                                    toStringzBuf(pattern), qos);
    }

    /// ditto
    void subscribe(string pattern, int qos, void delegate(const(ubyte)[]) cb)
    {
        slist ~= Callback(pattern, qos,
                    (const(char)[], const(ubyte)[] data){ cb(data); });
        if (connected) mosqCheck!mosquitto_subscribe(mosq, null,
                                    toStringzBuf(pattern), qos);
    }
}