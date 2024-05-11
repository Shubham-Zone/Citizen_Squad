import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ExerciseTimeline extends StatelessWidget {
  const ExerciseTimeline({Key? key});

  @override
  Widget build(BuildContext context) {

    final List<Exercise> exercises = [
      Exercise(
        name: 'Push-ups',
        calories: 100,
        minutes: 10,
        isCompleted: true,
      ),
      Exercise(
        name: 'Jumping Jacks',
        calories: 80,
        minutes: 5,
        isCompleted: true,
      ),
      Exercise(
        name: 'Squats',
        calories: 120,
        minutes: 15,
        isCompleted: false,
      ),
      Exercise(
        name: 'Plank',
        calories: 90,
        minutes: 7,
        isCompleted: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Widget'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return CustomTimelineTile(
                  isFirst: index == 0,
                  isLast: index == exercises.length - 1,
                  exercise: exercises[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final Exercise exercise;

  const CustomTimelineTile({super.key,
    required this.isFirst,
    required this.isLast,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
            width: 30,
            height: 30,
            color: exercise.isCompleted ? Colors.green : Colors.grey,
            indicator: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: exercise.isCompleted ? Colors.green : Colors.grey,
                ),
                child: exercise.isCompleted
                    ?const Center(child: Icon(Icons.check),)
                    :const SizedBox()
            )
        ),
        afterLineStyle: LineStyle(
          thickness: 1,
          color: exercise.isCompleted ? Colors.green : Colors.grey,
        ),
        beforeLineStyle: LineStyle(
          thickness: 1,
          color: exercise.isCompleted ? Colors.green : Colors.grey,
        ),
        endChild: ExerciseCard(exercise: exercise),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.fitness_center),
        title: Text(exercise.name),
        subtitle: Text('${exercise.calories} kcal | ${exercise.minutes} min'),
      ),
    );
  }
}

class Exercise {
  final String name;
  final int calories;
  final int minutes;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.calories,
    required this.minutes,
    this.isCompleted = false,
  });
}