import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

enum Mao { pedra, papel, tesoura }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String resultado = "Escolha sua jogada!";
  String imagemDeFundo = "assets/images/inicio.png";

  void jogar(Mao player) {
    final cpu = Mao.values[Random().nextInt(3)];
    
    setState(() {
      if (player == cpu) {
        resultado = "Eita, empatou :V";
      } else if ((player == Mao.pedra && cpu == Mao.tesoura) ||
                 (player == Mao.papel && cpu == Mao.pedra) ||
                 (player == Mao.tesoura && cpu == Mao.papel)) {
        resultado = "Você ganhou... Dessa vez...";
        resultado = "perdeu otario kkkk";
      }

      if (cpu == Mao.pedra) imagemDeFundo = "assets/images/esquilo_pedra.png";
      else if (cpu == Mao.papel) imagemDeFundo = "assets/images/esquilo_papel.png";
      else imagemDeFundo = "assets/images/esquilo_tesoura.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery pega o tamanho total da tela do seu navegador
    final larguraTela = MediaQuery.of(context).size.width;
    final alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 1. O WALLPAPER QUE PREENCHE TUDO
          Container(
            width: larguraTela,
            height: alturaTela,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagemDeFundo),
                // O BoxFit.fill vai esticar a imagem para cobrir a tela toda.
                // Se não quiser que estique, use BoxFit.cover (cobre tudo, mas pode cortar as bordas).
                fit: BoxFit.cover, 
              ),
            ),
          ),

          // 2. A INTERFACE (TEXTO E BOTÕES)
          // Usamos o Align para colocar os botões na parte de baixo sem tapar o centro
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Texto no topo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                color: Colors.black26, // Faixa bem sutil só pra ler o texto
                child: Text(
                  resultado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // Botões no rodapé
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _botaoEmoji("🪨", Mao.pedra),
                    const SizedBox(width: 25),
                    _botaoEmoji("📄", Mao.papel),
                    const SizedBox(width: 25),
                    _botaoEmoji("✂️", Mao.tesoura),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botaoEmoji(String emoji, Mao mao) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () => jogar(mao),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(25),
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 40)),
      ),
    );
  }
}