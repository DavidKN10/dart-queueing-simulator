import 'package:yaml/yaml.dart';
import 'processes.dart';

/// Queueing system simulator.
class Simulator {
  final bool verbose;
  final List<Process> processes = []; // list to place created processes
  final List<ProcessedEvent> _processedEvents = [];
  int _currentTime = 0;

  Simulator(YamlMap yamlData, {this.verbose = false}) {
    for (final name in yamlData.keys) {
      final fields = yamlData[name];
      // replace print statements with process creation
      switch (fields['type']) {
        case 'singleton':
          processes.add(SingletonProcess(name, fields['arrival'], fields['duration']));
          break;
        case 'periodic':
          processes.add(PeriodicProcess(name, fields['duration'], fields['interarrival-time'], fields['first-arrival'], fields['num-repetitions']));
          break;
        case 'stochastic':
          processes.add(StochasticProcess(name, fields['mean-duration'], fields['mean-interarrival-time'], fields['first-arrival'], fields['end']));
          break;
      }
    }
  }

  void run() {
    // first generate and sort events by arrival time
    final List<Event> eventQueue = processes
      .expand((process) => process.generateEvents())
      .toList()
      ..sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    
    _currentTime = 0;
    _processedEvents.clear();

    while(eventQueue.isNotEmpty) {
      final Event event = eventQueue[0];

      // calculate start time and waiting time
      final int startTime = _currentTime > event.arrivalTime ? _currentTime : event.arrivalTime;
      final int waitTime = startTime - event.arrivalTime;

      // create a Processed Event with scheduling information
      final ProcessedEvent processedEvent = ProcessedEvent(
        event.processName, event.arrivalTime, event.duration, 
        startTime: startTime, waitTime: waitTime, endTime: startTime + event.duration);

      // update simulation state
      _currentTime = processedEvent.endTime;
      _processedEvents.add(processedEvent);

      // verbose output implementation
      if (verbose) {
        print("[T+${_currentTime}] Processed ${processedEvent.processName} "
        "| Scheduled: ${event.arrivalTime}-${event.arrivalTime + event.duration} "
        "| Actual: ${processedEvent.startTime}-${processedEvent.endTime} "
        "| Wait: ${processedEvent.waitTime}\n");
      }

      eventQueue.removeAt(0);
    }
  }

  void printReport() {
    // print simulation trace
    print("# Simulation trace\n");
    for(final event in _processedEvents) {
      final waitDescription = event.waitTime == 0 ? "no wait" : "waited ${event.waitTime}";
      print("t=${event.startTime}: ${event.processName}, duration ${event.duration} started (arrived @ ${event.arrivalTime}, ${waitDescription})");
    }     

    print("\n------------------------------------------------\n");

    // print per-process statistics
    print("# Per-process statistics\n");
    final stats = <String, Map<String, int>>{};
    for (final event in _processedEvents) {
      final processStats = stats.putIfAbsent(event.processName, 
        () => {'count': 0, 'totalWait': 0}
      );
      processStats['count'] = processStats['count']! + 1;
      processStats['totalWait'] = processStats['totalWait']! + event.waitTime;
    }

    stats.forEach((processName, data) {
      final avgWait = data['totalWait']! / data['count']!;
      print("${processName}:\n");
      print(" Events generated: ${data['count']}");
      print(" Total wait time: ${data['totalWait']}");
      print(" Average wait time: ${avgWait.toStringAsFixed(avgWait.truncateToDouble() == avgWait ? 0 : 2)}\n");
    });

    print("\n------------------------------------------------\n");
    
    // print summary statistics
    print("# Summary statistics\n");
    final totalEvents = _processedEvents.length;
    final totalWait = _processedEvents.fold(0, (sum, event) => sum + event.waitTime);
    final avgWaitTotal =  totalWait / totalEvents;

    print("Total num events: ${totalEvents}");
    print("Total wait time: ${totalWait}");
    print("Average wait time: ${avgWaitTotal.toStringAsFixed(avgWaitTotal.truncateToDouble() == avgWaitTotal ? 0 : 3)}");
  } 
}
