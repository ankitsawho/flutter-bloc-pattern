import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

const supes = [
  'Homelander',
  'Queen Maeve',
  'Black Noir',
  'Starlight',
  'Stormfront',
  'A-Train',
  'The Deep',
  'Soldier Boy',
  'TNT Twins',
  'Gunpowder',
  'Crimson Countess',
  'Love Sausage',
  'Head Popper'
];

extension RandomElement<T> on Iterable<T>{
  T getRandomElement() => elementAt(
    math.Random().nextInt(length),
  );
}

class SupesCubit extends Cubit<String?> {
  SupesCubit() : super(null);

  void pickRandomSupe() => emit(supes.getRandomElement());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SupesCubit cubit;

  @override
  void initState(){
    super.initState();
    cubit = SupesCubit();
  }

  @override
  void dispose(){
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generateBtn = ElevatedButton(
        onPressed: () => cubit.pickRandomSupe(),
        child: const Text("Pick a Supe"));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supe Picker"),
      ),
      body: Center(
        child: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return generateBtn;
              case ConnectionState.waiting:
                return generateBtn;
              case ConnectionState.active:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    generateBtn,
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
