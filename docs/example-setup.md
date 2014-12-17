# How to set this up to create logs #

This is just a quick example on how to get up and running. You'll probably have to fine tune it some.

1. Compile `EfergyRPI_log.c` like explained in the `README`.
2. Start a `screen` session. That way the monitoring can run forever and you can check in on it:
    
    screen -U -S efergy

3. Run the logger inside `screen`. This will update the database with values every time it receives data from the Efergy monitor.

    ./collect.sh

4. Whenever you want, create a graph. This can be ad hoc or from `crontab`:

    ./makegraph.sh


