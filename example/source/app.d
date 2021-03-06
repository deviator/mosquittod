import std.stdio;
import std.format : format;
import core.thread;
import std.getopt;

import mosquittod;
import mosquittod.wrap;

int main(string[] args)
{
    enum topic = "mqtt/example";

    string ipaddr = "127.0.0.1";

    MosquittoClient.Settings sets;

    getopt(args,
        "p|port", &sets.port,
        "h|host", &sets.host,
    );

    MosquittoClient cli;

    try cli = new MosquittoClient(sets);
    catch (Exception e)
    {
        version (Windows)
        {
            import core.sys.windows.winbase;
            const err = GetLastError();
        }
        else
        {
            import core.stdc.errno;
            const err = errno;
        }
        stderr.writeln("error while loading library: ", err);
        return 1;
    }

    int major, minor, rev;
    stderr.writeln(mosquitto_lib_version(&major, &minor, &rev));
    stderr.writefln!"%d.%d.%d"(major, minor, rev);
    stderr.writeln(mosquittoLibVersion());

    cli.connect();

    if (args.length > 1 && args[1] == "bombardire")
    {
        foreach (i; 0 .. 100)
        {
            cli.publish(topic, 1, format("msg %d", i));
            cli.loop(); // need for handshake if qos!=0
            Thread.sleep(20.msecs);
        }
        Thread.sleep(10.msecs);
        cli.publish(topic, 1, "halt");
        cli.loop();

        return 0;
    }
    else if (args.length == 1)
    {
        bool run = true;

        // for test: mosquitto_pub -t mqtt/example -m "hello mqtt"
        cli.subscribe(topic, 2, (const(void)[] data)
        {
            auto sdata = cast(const(char[]))data;
            writefln("get: %s", sdata);
            stdout.flush();
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