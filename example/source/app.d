import std.stdio;
import std.format : format;
import core.thread;

import mosquittod;

int main(string[] args)
{
    enum topic = "mqtt/example";

    auto cli = new MosquittoClient();

    cli.connect();

    if (args.length > 1 && args[1] == "bombardire")
    {
        foreach (i; 0 .. 100)
        {
            cli.publish(topic~format("/%d", i), format("msg %d", i), 1);
            Thread.sleep(10.msecs);
        }
        Thread.sleep(10.msecs);
        cli.publish(topic, "halt", 1);

        return 0;
    }
    else if (args.length == 1)
    {
        bool run = true;

        // for test: mosquitto_pub -t mqtt/example -m "hello mqtt"
        cli.subscribe(topic ~ "/+", 2, (const(ubyte)[] data)
        {
            auto sdata = cast(const(char[]))data;
            writefln("get: %s", sdata);
            if (sdata == "halt") run = false;
        });

        while (run)
        {
            cli.loop();
            Thread.sleep(1.msecs);
        }
        return 0;
    }
    else
    {
        stderr.writefln(
            "unknown args %2$s\n"~
            "use for monitor: %1$s\n"~
            "use for bombardire: %1$s bombardire",
            args[0], args[1..$]);
        return 1;
    }
}