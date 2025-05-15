# MP Report

## Team

- Name(s): 
- AID(s): 

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The simulator builds without error
- [X] The simulator runs on at least one configuration file without crashing
- [X] Verbose output (via the `-v` flag) is implemented
- [X] I used the provided starter code
- The simulator runs correctly (to the best of my knowledge) on the provided configuration file(s):
  - [X] conf/sim1.yaml
  - [X] conf/sim2.yaml
  - [X] conf/sim3.yaml
  - [X] conf/sim4.yaml
  - [X] conf/sim5.yaml

## Summary and Reflection

The only files I modified were processes.dart and simulator.dart. In process.dart, I created a class for the singleton, periodic, and stochastics processes. The classes ProcessedEvent and ProcessStatistics were made later on as I was working on the simulator. ProcessedEvent is similar to a regular event, the only difference is that it contains one more parameter which is a set that has information on when the processes started, how long it had to wait, and when it ended. ProcessStatistics is used to track stats for each process. For my implementation of run() in simulator.dart, I first made a list of events and sorted them by arrival time. This is going to be the queue of events. The loop will run as long as the queue is not empty. For each iteration, the first event in the queue is used to make a ProcessedEvent object. _currentTime is updated which keeps track of current time in the simulation. _processedEvents is also updated which is a list that keeps track of events we already processed. Before the loop goes into the next iteration, we check if "-v" was added into the script so we do verbose output. 

Replace this paragraph with notes on what you enjoyed/disliked, found challenging, or wish you had known before starting this MP.

I liked how we were allowed to modify every file if we wanted to. It encouraged to have a different solution from the expected one. What I disliked, and what I also found challenging, was implementing the StochasticProcess class. The main reason for this is because I initially was not sure how it worked or how to use the ExpDistribution(). For a all tests except the fourth one, I was able to get the same output. For the fourth test, total wait time and average wait time were slightly different. I was not sure what rate or seed was used in ExpDistribution() to get the example output. 
