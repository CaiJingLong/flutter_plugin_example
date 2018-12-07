package com.example.battlepower;

import java.util.Timer;
import java.util.TimerTask;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;

/**
 * BattlePowerPlugin
 */
public class BattlePowerPlugin implements MethodCallHandler {

    private static BasicMessageChannel<Object> runTimeSender;

    private static Timer timer;

    private static long startTime;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "battle_power");
        BattlePowerPlugin handler = new BattlePowerPlugin();
        channel.setMethodCallHandler(handler);

        runTimeSender = new BasicMessageChannel<>(registrar.messenger(), "run_time", new StandardMessageCodec());
        startTime = System.currentTimeMillis();
        startTimeSender();
    }

    public static void startTimeSender() {
        if (timer != null) {
            timer.cancel();
        } else {
            timer = new Timer();
        }

        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                if (runTimeSender != null) {
                    runTimeSender.send(System.currentTimeMillis() - startTime);
                }
            }
        }, 5000, 5000);
    }

    public static void cancelTimer() {
        timer.cancel();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "add":
                Integer x = call.argument("x");
                Integer y = call.argument("y");
                if (x != null && y != null) {
                    result.success(x + y);
                } else {
                    result.error("1", "不能为空", null);
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

}
