# pid-cpu-usage-mon
A program/local cluster CPU monitor in bash. You provide the monitoring interval in seconds and any part of your executed programs command or pid, pcum outputs the cpu usage in that interval as a percent and the pid.

The basic calling syntax is:
    bash $pcumDirectory/pcum.sh '$grep-search-terms' $monitoring-interval-seconds

Usage example for command line interface monitoring an app.js cluster every 5 seconds:

    bash pcum.sh 'app.js' 5
    0 15781
    0 15791
    0 15792
    0 15794
    0 15796
    0 15798
    0 15800
    0 15801
    0 15803

Or monitoring PID 1234 every second:

    bash pcum.sh 1234 1
    0 1234
    0 1234
    0 1234

More complex grep search terms are also acceptable, so long as those terms would appear in the pid or command fields of a ps command. This command finds the pid 1234 or 7890 as well as any process running program.py every second and polls the CPU usage.

    bash pcum.sh '1234\|7890\|program.py' 1

Usage example for node.js cluster monitoring:

    monitorProcess = child_process.exec("bash pcum.sh 'app.js' 5", function (error, stdout, stderr) {
    });
    monitorProcess.stdout.on('data', function (data) {
        var tmpStatsArr = data.split("\n");
        for (var i in tmpStatsArr)
        {
          //store cpu and pid values and do work
          var statsLine = tmpStatsArr[i].split(" ");
          var CPUusage = statsLine[0];
          var PID = statsLine[1];
        }
    });
