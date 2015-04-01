# pid-cpu-usage-mon
A program/local cluster CPU monitor in bash. You provide the monitoring interval in seconds and any part of your executed programs command or pid, pcum outputs the cpu usage in that interval as a percent and the pid

Usage example for command line interface monitoring app.js cluster every 5 seconds:

    bash pid-cpu-usage-mon.sh 'app.js' 5

Usage example for node.js cluster monitoring:

    monitorProcess = child_process.exec("bash pid-cpu-usage-mon.sh 'app.js' 5", function (error, stdout, stderr) {
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
