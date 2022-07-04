import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

class Supe{
  String name;
  String photoUrl;

  Supe({
    required this.name,
    required this.photoUrl
  });
}

final supes = [
  Supe(name: 'Homelander', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/5/5b/Homelander-S3.png/revision/latest/scale-to-width-down/700?cb=20220604010605"),
  Supe(name: 'Black Noir', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/8/8b/Black-Noire-S3.png/revision/latest/scale-to-width-down/700?cb=20220604011407"),
  Supe(name: 'Starlight', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/f/fa/Starlight-S3.png/revision/latest/scale-to-width-down/700?cb=20220604010441"),
  Supe(name: 'Stormfront', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/b/bd/Stormfront_S2.jpg/revision/latest?cb=20200808194916"),
  Supe(name: 'A-Train', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/6/65/A-Train-S3.png/revision/latest/scale-to-width-down/700?cb=20220604010944"),
  Supe(name: 'The Deep', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/f/f8/Deep-S3.png/revision/latest/scale-to-width-down/700?cb=20220604011135"),
  Supe(name: 'Soldier Boy', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/f/f4/Soldier-Boy-S3.png/revision/latest/scale-to-width-down/700?cb=20220604012336"),
  Supe(name: 'Mindstorm', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/2/2b/Mindstorm_2022_2.PNG/revision/latest?cb=20220701164935"),
  Supe(name: 'Gunpowder', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/a/ae/Gunpowder.png/revision/latest/scale-to-width-down/700?cb=20220609114721"),
  Supe(name: 'Crimson Countess', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/8/8a/Crimson-Countess-pfp.png/revision/latest/scale-to-width-down/700?cb=20220605025832"),
  Supe(name: "Queen Maeve", photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/2/27/Queen-Maeve-S3.png/revision/latest/scale-to-width-down/700?cb=20220604010748"),
  Supe(name: 'Love Sausage', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/c/c2/LoveSausage-S3.png/revision/latest/scale-to-width-down/699?cb=20220624153726"),
  Supe(name: 'Head Popper', photoUrl: "https://static.wikia.nocookie.net/amazons-the-boys/images/6/6e/Victoria-Neuman-S3.png/revision/latest/scale-to-width-down/700?cb=20220604011950"),
];

extension RandomElement<T> on Iterable<T>{
  T getRandomElement() => elementAt(
    math.Random().nextInt(length),
  );
}

class SupesCubit extends Cubit<Supe?> {
  SupesCubit() : super(Supe(name: "Supe", photoUrl: ""));

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
        child: StreamBuilder<Supe?>(
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
                    Image.network(snapshot.data?.photoUrl ?? ""),
                    Text(snapshot.data?.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
