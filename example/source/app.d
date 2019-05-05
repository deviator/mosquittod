import std.stdio;
import core.thread;

import mosquittod;

void main()
{
    auto cli = new MosquittoClient();

    cli.connect();

    // for test: mosquitto_pub -t mqtt/example -m "hello mqtt"
    cli.subscribe("mqtt/example", (const(ubyte)[] data)
    { writefln("get: %s", cast(const(char[]))data); }, 1);

    while (true)
    {
        cli.loop();
        Thread.sleep(1.msecs);
    }
}