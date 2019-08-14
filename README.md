# taskbench
Task bench is a utility rake script used create fake tasks in foreman tasks/dynflow projects.

Setup:
On a satellite 
* ```mkdir -p /usr/share/foreman/app/services/task_bench```
* ```curl https://raw.githubusercontent.com/parthaa/taskbench/master/app/services/task_bench/dummy_task.rb > /usr/share/foreman/app/services/task_bench/dummy_task.rb``` 
* ```curl https://raw.githubusercontent.com/parthaa/taskbench/master/lib/tasks/taskbench.rake > /usr/share/foreman/lib/tasks/taskbench.rake```

Usage:
Create dummy tasks by
* ```foreman-rake taskbench:dummy count=20 forks=2```
This will create 20 dummy async tasks via 2 concurrent forks (each fork there by taking 10 entries). One can use this to verify various task statistics.
* ```foreman-rake taskbench:hostupdate``` will randomly pick hosts and try to run the HostUpdate task.
* ```foreman-rake taskbench:genapp``` will randomly pick hosts and try to run the ::Katello::GenerateApplicability task.

