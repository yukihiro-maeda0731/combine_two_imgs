import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:combine_two_imgs/PaintHistory.dart';


/*
 * ペイント
 */
class Painter extends StatefulWidget {

  // ペイントコントローラ
  final PaintController paintController;

  Painter({
    required this.paintController
  }) : super(key: ValueKey<PaintController>(paintController)) {

    assert(this.paintController != null);
  }

  @override
  _PainterState createState() => _PainterState();
}


/*
 * ペイント ステート
 */
class _PainterState extends State<Painter> {

  @override
  Widget build(BuildContext context) {

    return Container(

      // イベント監視
      child: GestureDetector(
        child: Stack(children: <Widget>[
          Expanded(
        child: Center(
        child: Image.network("https://picsum.photos/250?image=9"),
      )),
          CustomPaint(
            willChange: true,
            // ペイント部分
            painter: _CustomPainter(
              widget.paintController._paintHistory,
              repaint: widget.paintController,
            ),
          )

    ]
        ),

        // イベントリスナー
        onPanStart: _onPaintStart,
        onPanUpdate: _onPaintUpdate,
        onPanEnd: _onPaintEnd,

      ),
      width: 200,
      height: 200,
    );
  }


  /*
   * 線ペイントの開始
   */
  void _onPaintStart(DragStartDetails start) {

    widget.paintController._paintHistory.addPaint(_getGlobalToLocalPosition(start.globalPosition));
    widget.paintController._notifyListeners();
  }

  /*
   * 線ペイント更新
   */
  void _onPaintUpdate(DragUpdateDetails update) {

    widget.paintController._paintHistory.updatePaint(_getGlobalToLocalPosition(update.globalPosition));
    widget.paintController._notifyListeners();
  }

  /*
   * 線ペイントの終了
   */
  void _onPaintEnd(DragEndDetails end) {

    widget.paintController._paintHistory.endPaint();
    widget.paintController._notifyListeners();
  }

  /*
   * ローカルのオフセットへ変換
   */
  Offset _getGlobalToLocalPosition(Offset global) {

    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }
}


/*
 * カスタムペイント
 */
class _CustomPainter extends CustomPainter {

  final PaintHistory _paintHistory;

  _CustomPainter(
      this._paintHistory,
      {
        required Listenable repaint
      }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _paintHistory.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) => true;
}




/*
 * ペイントコントローラ
 */
class PaintController extends ChangeNotifier {

  // ペイント履歴
  PaintHistory _paintHistory = PaintHistory();
  // 線の色
  Color _drawColor = Color.fromARGB(255, 0, 255, 0);
  // 線幅
  double _thickness = 5.0;
  // 背景色
  Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);

  /*
   * コンストラクタ
   */
  PaintController() : super() {

    // ペイント設定
    Paint paint = Paint();
    paint.color = _drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = _thickness;
    _paintHistory.currentPaint = paint;
    _paintHistory.backgroundColor = _backgroundColor;
  }

  /*
   * リスナー実行
   */
  void _notifyListeners() {

    notifyListeners();
  }

}