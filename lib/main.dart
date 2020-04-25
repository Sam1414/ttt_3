import 'package:flutter/material.dart';
import 'package:ttt_3/boardBack.dart';
import 'package:ttt_3/tGrid.dart';
import 'dart:math' show Random;

void main() {
  runApp(MaterialApp(
    title: 'ttt',
    home: FrontPage(),
  ));
}

enum mkr { x, o }
var _x = mkr.x;
var _o = mkr.o;

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  String marker = '';

  var selectedRadio = ' ';
  setSelectRadio(value) {
    setState(() {
      selectedRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            //leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
            title: Center(
              child: Text(
                'Tic-Tac-Toe',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(left: 35.0, top: 45.0, child: BoardBack()),
                  Column(
                    children: <Widget> [
                      Container(
                      margin: EdgeInsets.only(top: 65.0, bottom: 30.0),
                      child: Text(
                        'Choose Your Marker:',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 42.0),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: 'x',
                                  groupValue: selectedRadio,
                                  onChanged: (value) {
                                    setSelectRadio(value);
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      selectedRadio = 'x';
                                      marker = 'x';  
                                    });
                                  },
                                  child: Text(
                                    'X',
                                    style: TextStyle(fontSize: 95.0),
                                  ),
                                ),
                              ],
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12.0),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: 'o',
                                  groupValue: selectedRadio,
                                  onChanged: (value) {
                                    setSelectRadio(value);
                                  },
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      selectedRadio = 'o';
                                      marker = 'o';  
                                    });
                                  },
                                  child: Text(
                                    'O',
                                    style: TextStyle(fontSize: 95.0),
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 35.0),
                        child: RaisedButton(
                          elevation: 12.0,
                          splashColor: Colors.red,
                          textColor: Colors.white,
                          color: Colors.red[200],
                          padding: EdgeInsets.all(15.0),
                          child: Text('Play With Computer', style: TextStyle(fontSize: 30)),
                          onPressed: (marker == '' ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp(marker)),
                            );
                          }),
                        ),
                      ),
                      Container(margin: EdgeInsets.only(top: 70.0), child: Text('OR', style: TextStyle(fontSize: 40.0))),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          elevation: 12.0,
                          splashColor: Colors.red,
                          textColor: Colors.white,
                          color: Colors.red[200],
                          padding: EdgeInsets.all(15.0),
                          child: Text('Play With Friend', style: TextStyle(fontSize: 30)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlayFriend()),
                            );
                          },
                        ),
                      ),
                    ]),
                ],
              ),
            ])
        ),
    );
  }
}

class MyApp extends StatefulWidget {
  final String marker;
  MyApp(this.marker);

  @override
  _MyAppState createState() => _MyAppState(marker);
}

class _MyAppState extends State<MyApp> {
  String marker;
  String player;
  String opponent;
  var winner = ' ';
  bool compTurn = false;
  int c_row, c_col;

  List<List> _matrix = List<List>(3);

  _MyAppState(String marker) {
    opponent = marker;
    if (marker == 'x')
      player = 'o';
    else
      player = 'x';
    //_resetMatrix();
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.brown,
        title: Container(
            child: Text(
          'Tic-Tac-Toe',
          style: TextStyle(fontSize: 27),
        )),
      ),
      body: Container(
        color: Colors.brown[300],
        child: Stack(
          children: <Widget>[
            Positioned(left: 39, top: 38, child: BoardBack()),
            Positioned(
              left: 68,
              top: 67,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(/*mainAxisAlignment: MainAxisAlignment.center, */
                      children: [
                    _buildElement(0, 0),
                    _buildElement(0, 1),
                    _buildElement(0, 2),
                  ]),
                  Row(/*mainAxisAlignment: MainAxisAlignment.center, */
                      children: [
                    _buildElement(1, 0),
                    _buildElement(1, 1),
                    _buildElement(1, 2),
                  ]),
                  Row(/*mainAxisAlignment: MainAxisAlignment.center, */
                      children: [
                    _buildElement(2, 0),
                    _buildElement(2, 1),
                    _buildElement(2, 2),
                  ]),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 60.0, bottom: 30),
                        child: RaisedButton(
                            padding: EdgeInsets.all(0.0),
                            textColor: Colors.white,
                            onPressed: _resetMatrix,
                            child: Container(
                              child: Text('Reset',
                                  style: TextStyle(fontSize: 35.0)),
                              padding: EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5.0, offset: Offset(2.0, 3.0))
                                ],
                                color: Colors.blue,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        winner,
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(left: 209, top: 208, child: TGrid()),
          ],
        ),
      ),
    );
  }

  _resetMatrix() async {
    //List<bool> boolVal = [true, false];
    var rnd = Random();
    //compTurn = boolVal[rnd.nextInt(2)];
    compTurn = !compTurn;
    
    setState(() {  
      for (var i = 0; i < _matrix.length; i++) {
        for (var j = 0; j < _matrix[i].length; j++) {
          _matrix[i][j] = ' ';
        }
        winner = ' ';
      }
    });
    if(compTurn) {
      c_row = rnd.nextInt(3);
      c_col = rnd.nextInt(3);
      await Future.delayed(const Duration(milliseconds: 220));
      setState(() {
        _matrix[c_row][c_col] = player;
      });
    }
  }

  _buildElement(int i, int j) {
    return GestureDetector(
      onTap: () {
        _updateMatrix(i, j);
      },
      child: Container(
        alignment: Alignment.center,
        width: 94,
        height: 94,
        padding: EdgeInsets.all(0),
        //color: Colors.green[100],
        decoration: BoxDecoration(
          color: Colors.grey[400],
          //border: Border.all(color: Colors.green),
        ),
        child: Text(
          _matrix[i][j],
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }

  bool isMoveLeft() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_matrix[i][j] == ' ') {
          return true;
        }
      }
    }
    return false;
  }

  int evaluate() {
    //RowCheck
    for (int row = 0; row < 3; row++) {
      if (_matrix[row][0] == _matrix[row][1] &&
          _matrix[row][1] == _matrix[row][2]) {
        if (_matrix[row][0] == player)
          return 10;
        else if (_matrix[row][0] == opponent) return -10;
      }
    }
    //ColumnCheck
    for (int col = 0; col < 3; col++) {
      if (_matrix[0][col] == _matrix[1][col] &&
          _matrix[1][col] == _matrix[2][col]) {
        if (_matrix[0][col] == player)
          return 10;
        else if (_matrix[0][col] == opponent) return -10;
      }
    }
    //DiagonalCheck-1
    if (_matrix[0][0] == _matrix[1][1] && _matrix[1][1] == _matrix[2][2]) {
      if (_matrix[0][0] == player)
        return 10;
      else if (_matrix[0][0] == opponent) return -10;
    }
    //DiagonalCheck-2
    if (_matrix[2][0] == _matrix[1][1] && _matrix[1][1] == _matrix[0][2]) {
      if (_matrix[2][0] == player)
        return 10;
      else if (_matrix[2][0] == opponent) return -10;
    }
    return 0;
  }

  int minimax(int depth, bool compTurn) {
    int score = evaluate();
    //Comp-Won
    if (score == 10) return score - depth;
    //Opp-Won
    if (score == -10) return score + depth;

    if (!isMoveLeft()) return 0;

    if (compTurn) {
      int bestScore = -1000;
      //Traverse all cells
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (_matrix[i][j] == ' ') {
            //CompMove
            _matrix[i][j] = player;
            int newScore = minimax(depth + 1, !compTurn);
            bestScore = (bestScore > newScore ? bestScore : newScore);
            //Undo this move
            _matrix[i][j] = ' ';
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      //Traverse all cells
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (_matrix[i][j] == ' ') {
            //CompMove
            _matrix[i][j] = opponent;
            int newScore = minimax(depth + 1, !compTurn);
            bestScore = (bestScore < newScore ? bestScore : newScore);
            //Undo this move
            _matrix[i][j] = ' ';
          }
        }
      }
      return bestScore;
    }
  }

  List<int> _getBestMove() {
    var bestScore = -1000;
    List<int> bestMove = List<int>(2);
    bestMove[0] = -1;
    bestMove[1] = -1;
    //Traversing all cells
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_matrix[i][j] == ' ') {
          //Computer Making the move
          _matrix[i][j] = player;
          //evaluating score for this move
          int moveScore = minimax(0, false);
          //Undo this move
          _matrix[i][j] = ' ';
          if (moveScore > bestScore) {
            bestScore = moveScore;
            bestMove[0] = i;
            bestMove[1] = j;
          }
        }
      }
    }
    return bestMove;
  }

  Future<void> _updateMatrix(int i, int j) async {
    //print(isMoveLeft());
    /*
      if(winner != ' ') {
        print('winner: ' + winner);
      }*/
    if (_matrix[i][j] != ' ') return;
    if (winner == ' ') {
      if (_matrix[i][j] == ' ') {
        setState(() {
          _matrix[i][j] = opponent;
        });
        await Future.delayed(const Duration(milliseconds: 250));
        if (evaluate() == -10) {
          winner = 'You Won!';
        }
        if (!isMoveLeft() && winner == ' ') {
          setState(() {
            winner = 'DRAW';
          });
        }
      }
      if (winner == ' ') {
        List<int> bestMove = List<int>(2);
        bestMove = _getBestMove();
        setState(() {
          if (bestMove[0] < 3 &&
              bestMove[0] >= 0 &&
              bestMove[1] < 3 &&
              bestMove[1] >= 0) {
            _matrix[bestMove[0]][bestMove[1]] = player;
          }
        });
        if (evaluate() == 10) {
          winner = 'You Lost!';
        }
        if (!isMoveLeft() && winner == ' ') {
          setState(() {
            winner = 'DRAW';
          });
        }
      }
    }
  }
}

class PlayFriend extends StatefulWidget {
  @override
  _PlayFriendState createState() => _PlayFriendState();
}

class _PlayFriendState extends State<PlayFriend> {
  List<List> _matrix = List<List>(3);

  List<String> markers = List<String>(2);
  List<bool> boolVal = List<bool>(2);
  String player1, player2;
  bool turn;
  String winner = ' ';
  int ind1;
  int ind2;

  _PlayFriendState() {
    markers = ['x', 'o'];
    boolVal = [true, false];
    var rnd1 = new Random();
    var rnd2 = new Random();
    ind1 = rnd1.nextInt(2);
    print(ind1);
    ind2 = rnd2.nextInt(2);
    player1 = markers[ind1];
    player2 = markers[1 - ind1];
    turn = boolVal[ind2];
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.brown,
        title: Container(
            child: Text(
          'Tic-Tac-Toe',
          style: TextStyle(fontSize: 27),
        )),
      ),
      body: Container(
        color: Colors.brown[300],
        child: Stack(
          children: <Widget>[
            Positioned(left: 39, top: 38, child: BoardBack()),
            Positioned(
              left: 64,
              top: 67,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(/*mainAxisAlignment: MainAxisAlignment.center, */
                      children: [
                    _buildElement(0, 0),
                    _buildElement(0, 1),
                    _buildElement(0, 2),
                  ]),
                  Row(/*mainAxisAlignment: MainAxisAlignment.center, */
                      children: [
                    _buildElement(1, 0),
                    _buildElement(1, 1),
                    _buildElement(1, 2),
                  ]),
                  Row(/*mainAxisAlignment: MainAxisAlignment.center, */
                      children: [
                    _buildElement(2, 0),
                    _buildElement(2, 1),
                    _buildElement(2, 2),
                  ]),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 60.0, bottom: 30),
                        child: RaisedButton(
                            padding: EdgeInsets.all(0.0),
                            textColor: Colors.white,
                            onPressed: (winner == ' ' ? null : _resetMatrix),
                            child: Container(
                              child: Text('Reset',
                                  style: TextStyle(fontSize: 35.0)),
                              padding: EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 10.0,
                                bottom: 10.0,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5.0, offset: Offset(2.0, 3.0))
                                ],
                                color: Colors.blue,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Container(margin: EdgeInsets.only(top: 15.0), child: Text(winner, style: TextStyle(fontSize: 40, color: Colors.white),)),
                ],
              ),
            ),
            Positioned(left: 209, top: 208, child: TGrid()),
            Positioned(
              left: 0.0,
              top: 395.0,
              child: Container(
                width: 120.0,
                //height: 50.0,
                //padding: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(0.0),
                  color: Colors.red[200],
                  child: Text(player1, style: TextStyle(fontSize: 80.0),),
                  onPressed: (turn ? () {} : null),
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              top: 395.0,
              child: Container(
                width: 120.0,
                //height: 50.0,
                //padding: EdgeInsets.only(top: 10.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(0.0),
                  color: Colors.red[200],
                  child: Text(player2, style: TextStyle(fontSize: 80.0),),
                  onPressed: (!turn ? () {} : null),
                ),
              ),
            ),
            /*Positioned(  
              top: 510.0,
              //left: 60.0,
              child: Center(
                //alignment: Alignment.bottomRight,
                //margin: EdgeInsets.only(left: 130.0, right: 130.0),
                child: Text(
                  winner,
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
              )
            )*/
          ],
        ),
      ),
    );
  }

  _buildElement(int i, int j) {
    return GestureDetector(
      onTap: () {
        _setMarker(i, j);
      },
      child: Container(
        alignment: Alignment.center,
        width: 94,
        height: 94,
        padding: EdgeInsets.all(0),
        //color: Colors.green[100],
        decoration: BoxDecoration(
          color: Colors.grey[400],
          //border: Border.all(color: Colors.green),
        ),
        child: Text(
          _matrix[i][j],
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }

  _setMarker(int i, int j) {

    /*setState(() {
      player1 = markers[ind1];
      player2 = markers[1 - ind1];
      turn = boolVal[ind2];
    });*/

    if(_matrix[i][j] == ' ' && winner == ' ') {
      if(turn) {
        turn = !turn;
        setState(() {
          _matrix[i][j] = player1;
        });
      }
      else {
        turn = !turn;
        setState(() {
          _matrix[i][j] = player2;
        });
      }
      setState(() {
        if(evaluate() == 10) winner = player1 + ' wins';
        else if(evaluate() == -10) winner = player2 + ' wins';
        else if(!isMoveLeft() && winner == ' ') winner = 'DRAW';
      });
    }
  }

  bool isMoveLeft() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_matrix[i][j] == ' ') {
          return true;
        }
      }
    }
    return false;
  }

  _resetMatrix() {
    setState(() {
      markers = ['x', 'o'];
      boolVal = [true, false];
      var rnd1 = new Random();
      var rnd2 = new Random();
      ind1 = rnd1.nextInt(2);
      print(ind1);
      ind2 = rnd2.nextInt(2);
      player1 = markers[ind1];
      player2 = markers[1 - ind1];
      turn = boolVal[ind2];
    });
    setState(() {
      for (var i = 0; i < _matrix.length; i++) {
        for (var j = 0; j < _matrix[i].length; j++) {
          _matrix[i][j] = ' ';
        }
        winner = ' ';
      }
    });
  }

  int evaluate() {
    //RowCheck
    for (int row = 0; row < 3; row++) {
      if (_matrix[row][0] == _matrix[row][1] &&
          _matrix[row][1] == _matrix[row][2]) {
        if (_matrix[row][0] == player1)
          return 10;
        else if (_matrix[row][0] == player2) return -10;
      }
    }
    //ColumnCheck
    for (int col = 0; col < 3; col++) {
      if (_matrix[0][col] == _matrix[1][col] &&
          _matrix[1][col] == _matrix[2][col]) {
        if (_matrix[0][col] == player1)
          return 10;
        else if (_matrix[0][col] == player2) return -10;
      }
    }
    //DiagonalCheck-1
    if (_matrix[0][0] == _matrix[1][1] && _matrix[1][1] == _matrix[2][2]) {
      if (_matrix[0][0] == player1)
        return 10;
      else if (_matrix[0][0] == player2) return -10;
    }
    //DiagonalCheck-2
    if (_matrix[2][0] == _matrix[1][1] && _matrix[1][1] == _matrix[0][2]) {
      if (_matrix[2][0] == player1)
        return 10;
      else if (_matrix[2][0] == player2) return -10;
    }
    return 0;
  }
}
