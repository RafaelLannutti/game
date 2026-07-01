import wollok.game.*

// ============================
// OBSTACULOS
// ============================

class Obstaculo {
  var property position
  var property imagen
  var property anchoCeldas = 1
  var property altoCeldas  = 1

  method image() = imagen

  // Devuelve true si la posición 'pos' cae dentro del área que ocupa este obstáculo
  method ocupaCelda(pos) =
    pos.x().between(position.x(), position.x() + anchoCeldas - 1) &&
    pos.y().between(position.y(), position.y() + altoCeldas  - 1)

  method recibirImpacto(papa) {}
}
