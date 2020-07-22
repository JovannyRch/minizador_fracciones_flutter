import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minimizador_fracciones/services/Admob.dart';
import 'package:launch_review/launch_review.dart';

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = "0";
  String output = "";
  Color _color = Color(0xEE6982E6);
  double _width = 10.0;
  double _height = 10.0;
  double _fontSize = 35;
  double kWidth = 0.17;
  String mcd = "";
  AdmobInterstitial interstitialAd;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Admob.initialize(AdmobService.getAdmobId(isTesting: false));
    interstitialAd = AdmobInterstitial(
      adUnitId: AdmobService.videoId(isTesting: false),
    );
    interstitialAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _mainUI(),
            _rateApp(),
          ],
        ),
      ),
    );
  }

  Widget _mainUI() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _displayScreen(),
      _keys(),
      Text(
        'jovannyrch.com',
        style: TextStyle(color: Colors.grey.shade300),
      ),
    ]);
  }

  Widget _rateApp() {
    return Positioned(
      right: 10.0,
      child: GestureDetector(
        onTap: () {
          this.callReview();
        },
        child: Container(
          width: 150.0,
          padding: EdgeInsets.all(2.0),
          margin: EdgeInsets.only(top: 15.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: _color,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.star,
                color: _color,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Califica la app",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void callReview() {
    LaunchReview.launch(
        androidAppId: "com.jovannyrch.minimizador_fracciones",
        iOSAppId: "585027354");
  }

  Widget _displayScreen() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        height: _height * 0.3,
        width: double.infinity,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                output,
                style: TextStyle(color: Colors.grey, fontSize: 30.0),
              ),
              SizedBox(height: 10.0),
              Text(
                input,
                style: TextStyle(
                  color: _color,
                  fontSize: 65.0,
                ),
                textAlign: TextAlign.end,
              ),
              Text(
                this.output.length > 0 ? "Mayor factor común:  $mcd" : "",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ));
  }

  Widget _keys() {
    return Container(
      height: _height * 0.6,
      child: Column(
        children: <Widget>[
          _rowConf(),
          _rowNumbers(7, 8, 9),
          _rowNumbers(4, 5, 6),
          _rowNumbers(1, 2, 3),
          _downColumn(),
        ],
      ),
    );
  }

  Widget _downColumn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        numberButton(0),
        _equalButton(),
      ],
    );
  }

  Widget _rowConf() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _functButton("CE", () {
          setState(() {
            clearDisplay();
          });
        }),
        _functButton("-", () {
          if (this.input.length == 1 && this.input[0] == "0") {
            setState(() {
              this.input = "-";
            });
          } else {
            setState(() {
              this.input += "-";
            });
          }
        }),
        _functButton("/", () {
          if (!this.input.contains("/")) {
            setState(() {
              this.input += "/";
            });
          }
        })
      ],
    );
  }

  Widget _functButton(String text, Function f, {main = false}) {
    return GestureDetector(
      onTap: f,
      child: _roundButton(Text(
        text,
        style: TextStyle(
          color: _color,
          fontSize: _fontSize * .8,
          fontWeight: FontWeight.w400,
        ),
      )),
    );
  }

  Widget _rowNumbers(int a, int b, int c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        numberButton(a),
        numberButton(b),
        numberButton(c),
      ],
    );
  }

  void clearDisplay() {
    this.input = "0";
    this.output = "";
  }

  int MCD(x, y) {
    if (x < 0) {
      x = x * -1;
    }
    if (y < 0) {
      y = y * -1;
    }
    while (y > 0) {
      var t = y;
      y = x % y;
      x = t;
    }
    return x;
  }

  void showMsg(String msg) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  Widget _equalButton() {
    return GestureDetector(
      onTap: () async {
        if (this.input.contains("/")) {
          if (await interstitialAd.isLoaded) {
            interstitialAd.show();
          } else {
            print("Sigue cargando ");
          }
          List<String> numbers = this.input.split("/");
          print(numbers);
          if (numbers[0] == "" || numbers[1] == "") {
            showMsg("Datos incompletos");
            return;
          }

          int a = int.parse(numbers[0]);
          int b = int.parse(numbers[1]);

          int mcd = this.MCD(a, b);
          if (b == 0) {
            showMsg("Recuerda que la división entre 0 no existe");
            return;
          } else if (mcd == 1) {
            showMsg("La fracción ya no se puede simplificar más");
          }
          setState(() {
            this.mcd = "$mcd";
            this.output = this.input.toString() + '';
            this.input = "${a ~/ mcd}/${b ~/ mcd}";
          });
        } else {
          showMsg("Agrega el denominador");
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        width: _width * (kWidth * 2.5),
        height: _width * kWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "=",
              style: TextStyle(fontSize: _fontSize, color: Colors.white),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(4, 4), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }

  Container _roundButton(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: _width * kWidth,
      height: _width * kWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[child],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(4, 4), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget numberButton(int number) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (this.input.length == 1 && number != 0 && this.input[0] == "0") {
            this.input = "";
          }
          this.input = this.input + number.toString();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        width: _width * kWidth,
        height: _width * kWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              number.toString(),
              style: TextStyle(
                  fontSize: _fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(4, 4), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
