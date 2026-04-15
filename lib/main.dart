import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

enum Mao {
  pedra,
  papel,
  tesoura,
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String resultado = "Escolha uma opção";

  Mao gerarCPU() {
    final random = Random();
    return Mao.values[random.nextInt(3)];
  }

  String verificarResultado(Mao player, Mao cpu) {
    if (player == cpu) return "Empate!";

    if ((player == Mao.pedra && cpu == Mao.tesoura) ||
        (player == Mao.papel && cpu == Mao.pedra) ||
        (player == Mao.tesoura && cpu == Mao.papel)) {
      return "Você ganhou!";
    } else {
      return "Você perdeu!";
    }
  }

  void jogar(Mao player) {
    final cpu = gerarCPU();
    final res = verificarResultado(player, cpu);

    setState(() {
      resultado =
          "Você: ${player.name}\nCPU: ${cpu.name}\nResultado: $res";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => jogar(Mao.pedra),
                  child: const Text("Pedra"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => jogar(Mao.papel),
                  child: const Text("Papel"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => jogar(Mao.tesoura),
                  child: const Text("Tesoura"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}