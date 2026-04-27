import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MainApp());
}

enum ItemsPlayed { pedra, papel, tesoura }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  ItemsPlayed? escolhaUsuario;
  ItemsPlayed? escolhaCPU;
  String resultado = "...";

  int vitoriasUser = 0;
  int vitoriasCPU = 0;
  bool melhorDeCinco = false;

  void jogar() {
    if (escolhaUsuario == null) {
      setState(() => resultado = "Selecione uma opção!");
      return;
    }

    final cpu = ItemsPlayed.values[Random().nextInt(3)];
    final res = verificarVencedor(escolhaUsuario!, cpu);

    setState(() {
      escolhaCPU = cpu;
      resultado = res;

      if (res == "Você ganhou!") vitoriasUser++;
      if (res == "Você perdeu!") vitoriasCPU++;
    });

    if (melhorDeCinco) {
      verificarFimDeJogo();
    }
  }

  String verificarVencedor(ItemsPlayed player, ItemsPlayed cpu) {
    if (player == cpu) return "Empate!";
    if ((player == ItemsPlayed.pedra && cpu == ItemsPlayed.tesoura) ||
        (player == ItemsPlayed.papel && cpu == ItemsPlayed.pedra) ||
        (player == ItemsPlayed.tesoura && cpu == ItemsPlayed.papel)) {
      return "Você ganhou!";
    }
    return "Você perdeu!";
  }

  void verificarFimDeJogo() {
    if (vitoriasUser == 3 || vitoriasCPU == 3) {
      String campeao = vitoriasUser == 3 ? "Você" : "A Máquina";

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Fim da Melhor de Cinco!"),
            content: Text(
              "$campeao venceu a série por $vitoriasUser a $vitoriasCPU!",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  resetarPlacar();
                  Navigator.pop(context);
                },
                child: const Text("REINICIAR"),
              ),
            ],
          ),
        );
      });
    }
  }

  void resetarPlacar() {
    setState(() {
      vitoriasUser = 0;
      vitoriasCPU = 0;
      escolhaUsuario = null;
      escolhaCPU = null;
      resultado = "...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Jokenpo - Melhor de 5'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: resetarPlacar),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreItem("VOCÊ", vitoriasUser),
                const Text("VS", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildScoreItem("CPU", vitoriasCPU),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text("Modo Melhor de Cinco"),
            subtitle: const Text("Vence quem fizer 3 pontos primeiro"),
            value: melhorDeCinco,
            onChanged: (val) {
              setState(() {
                melhorDeCinco = val;
                resetarPlacar();
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Escolha uma Opção",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildOptionCard(ItemsPlayed.pedra),
                      const SizedBox(width: 10),
                      _buildOptionCard(ItemsPlayed.papel),
                      const SizedBox(width: 10),
                      _buildOptionCard(ItemsPlayed.tesoura),
                    ],
                  ),
                  const Divider(
                    color: Colors.red,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                    height: 40,
                  ),
                  SizedBox(
                    height: 100,
                    child: escolhaCPU == null
                        ? const Icon(Icons.close, size: 100)
                        : _getIconFor(escolhaCPU!, size: 80),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: jogar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text("JOGAR"),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    resultado,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          "$score",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOptionCard(ItemsPlayed item) {
    bool isSelected = escolhaUsuario == item;
    return GestureDetector(
      onTap: () => setState(() {
        escolhaUsuario = item;
        escolhaCPU = null;
        resultado = "...";
      }),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.black,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: _getIconFor(item, size: 40),
      ),
    );
  }

  Widget _getIconFor(ItemsPlayed item, {double size = 40}) {
    FaIconData icon;
    switch (item) {
      case ItemsPlayed.pedra:
        icon = FontAwesomeIcons.handBackFist;
        break;
      case ItemsPlayed.papel:
        icon = FontAwesomeIcons.hand;
        break;
      case ItemsPlayed.tesoura:
        icon = FontAwesomeIcons.handScissors;
        break;
    }
    return Center(
      child: FaIcon(icon, size: size, color: Colors.black87),
    );
  }
}
