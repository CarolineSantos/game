import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String Player_X = "X";
  static const String Player_O = "O"; // Corrigi o nome de Player_Y para Player_O

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = Player_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(), // Aqui chamamos o método _headerText
            _gameContainer(), //cria os 9 numeros de 0 a 9, base do game
            _restartButton(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          "Tic Tac Toe",
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$currentPlayer turn", // Corrigi a formatação da string para incluir um apóstrofo
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //cria os 9 numeros de 0 a 9
  Widget _gameContainer(){
    return Container(
      height: MediaQuery.of(context).size.height/2,
      width: MediaQuery.of(context).size.height/2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3), 
        itemCount: 9,
        itemBuilder: (context, int index){
            return _box(index);
          }
        ),
    );
  }

//esse cara cria as box e ação de clicar
  Widget _box(int index){
    return InkWell(
      onTap: (){
        //on click of box


        if(gameEnd || occupied[index].isNotEmpty){//esse aqui bloqueia de trocar x por o
          return;
        }

        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();//troca de turno
          checkForWinner();//mostra o vencedor
          checkForDraw();//caso empate
        });
      },
      child: Container(
        color: occupied[index].isEmpty
          ?Colors.black26
          : occupied[index] == Player_X
            ?Colors.blue
            : Colors.orange,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(
              fontSize: 50),
          ),
        ),
      ),
    );
  }

  //troca de turno
  changeTurn(){
    if(currentPlayer == Player_X){
      currentPlayer = Player_O;
    }else{
      currentPlayer = Player_X;
    }
  }

  checkForWinner(){
    List<List<int>> winningList = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6],
    ];

    for(var winningPos in winningList){
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if(playerPosition0.isNotEmpty){
        if(playerPosition0 == playerPosition1 && playerPosition0 == playerPosition2){
          //all equal means player won
          showGameOverMessage("Player $playerPosition0 Won");
          gameEnd = true;
          return; 
        }
      }
    }
  }

  showGameOverMessage(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Game Over \n $mensagem",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        )
      ),
    );
  }

//caso empate
  checkForDraw(){
    if(gameEnd){
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied){
      if(occupiedPlayer.isEmpty){
        //at least one is empty not all are filled
        draw = false;
      }
    }

    if(draw){
      showGameOverMessage("Draw");
      gameEnd = true;
    }
  }

  _restartButton(){
    return ElevatedButton(
      onPressed: (){
        setState(() {
          initializeGame();
        });
      }, 
      child: const Text("Restart Game"));
  }
}
